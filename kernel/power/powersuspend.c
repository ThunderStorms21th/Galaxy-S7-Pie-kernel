/* kernel/power/powersuspend.c
 *
 * Copyright (C) 2005-2008 Google, Inc.
 * Copyright (C) 2013 Paul Reioux
 *
 * Modified by Jean-Pierre Rasquin <yank555.lu@gmail.com>
 *
 *  v1.1 - make powersuspend not depend on a userspace initiator anymore,
 *         but use a hook in autosleep instead.
 *
 *  v1.2 - make kernel / userspace mode switchable
 *
 *  v1.3 - add a hook in display panel driver as alternative kernel trigger
 *
 *  v1.4 - add a hybrid-kernel mode, accepting both kernel hooks (first wins)
 *
 *  v1.5 - fix hybrid-kernel mode cannot be set through sysfs
 *
 *  v1.6 - remove autosleep and hybrid modes (autosleep not working on shamu)
 *
 *  v1.6.1 - add autosleep and hybrid modes and hybrid default (UpInTheAir@XDA)
 *
 *  v1.7 - do only run state change if change actually requests a new state
 *
 *  v1.7.1 - replaced deprecated singlethread workqueue with updated schedule_work
 *
 *  v1.8 - add debug sysfs trigger to see how driver work
 *
 *  v1.8.1 - Replaced deprecated singlethread workqueue with updated schedule_work.
 *
 *  v1.9.0 - updated our outdated method of workqueue declaration
 *
 *
 *  v1.9.1 - Updated the depecrated method of declaring work but simply declaring
 *           the two work structs.  Also actually INITialized the work on init, and
 *           flushed it on exit.
 *
 * v1.9.2 Remove unneccessary "MODE" variable as we only have one mechanism of
 *		  action remaining. Also removed the useless state sysfs entry.  Like
 *		  state notifier, we can only see "state" when the screen is on, so
 *		  it is pointless to expose to userspace. Topped off with some cleanup.
 *
 * This software is licensed under the terms of the GNU General Public
 * License version 2, as published by the Free Software Foundation, and
 * may be copied, distributed, and modified under those terms.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */

#include <linux/powersuspend.h>

#define MAJOR_VERSION	1
#define MINOR_VERSION	9
#define SUB_MINOR_VERSION 2

/*
 * debug = 1 will print all
 */
static unsigned int debug = 0;
module_param_named(debug_mask, debug, uint, 0644);

#define dprintk(msg...)		\
do { 				\
	if (debug)		\
		pr_info(msg);	\
} while (0)

struct workqueue_struct *suspend_work_queue;

static DEFINE_MUTEX(power_suspend_lock);
static DEFINE_SPINLOCK(state_lock);
static LIST_HEAD(power_suspend_handlers);
struct work_struct power_suspend_work;
struct work_struct power_resume_work;
static void power_suspend(struct work_struct *work);
static void power_resume(struct work_struct *work);

static int state; // Yank555.lu : Current powersuspend state (screen on / off)

void register_power_suspend(struct power_suspend *handler)
{
	struct list_head *pos;

	mutex_lock(&power_suspend_lock);
	list_for_each(pos, &power_suspend_handlers) {
		struct power_suspend *p;
		p = list_entry(pos, struct power_suspend, link);
	}
	list_add_tail(&handler->link, pos);
	mutex_unlock(&power_suspend_lock);
}
EXPORT_SYMBOL(register_power_suspend);

void unregister_power_suspend(struct power_suspend *handler)
{
	mutex_lock(&power_suspend_lock);
	list_del(&handler->link);
	mutex_unlock(&power_suspend_lock);
}
EXPORT_SYMBOL(unregister_power_suspend);

static void power_suspend(struct work_struct *work)
{
	struct power_suspend *pos;
	unsigned long irqflags;
	int abort = 0;

	pr_info("[POWERSUSPEND] Entering Suspend...\n");
	mutex_lock(&power_suspend_lock);
	spin_lock_irqsave(&state_lock, irqflags);
	if (state == POWER_SUSPEND_INACTIVE)
		abort = 1;
	spin_unlock_irqrestore(&state_lock, irqflags);

	if (abort)
		goto abort_suspend;

	pr_info("[POWERSUSPEND] Suspending...\n");
	list_for_each_entry(pos, &power_suspend_handlers, link) {
		if (pos->suspend != NULL) {
			pos->suspend(pos);
		}
	}
	pr_info("[POWERSUSPEND] Suspend Completed.\n");
abort_suspend:
	mutex_unlock(&power_suspend_lock);
}

static void power_resume(struct work_struct *work)
{
	struct power_suspend *pos;
	unsigned long irqflags;
	int abort = 0;

	pr_info("[POWERSUSPEND] Entering Resume...\n");
	mutex_lock(&power_suspend_lock);
	spin_lock_irqsave(&state_lock, irqflags);
	if (state == POWER_SUSPEND_ACTIVE)
		abort = 1;
	spin_unlock_irqrestore(&state_lock, irqflags);

	if (abort)
		goto abort_resume;

	pr_info("[POWERSUSPEND] Resuming...\n");
	list_for_each_entry_reverse(pos, &power_suspend_handlers, link) {
		if (pos->resume != NULL) {
			pos->resume(pos);
		}
	}
	pr_info("[POWERSUSPEND] Resume Completed.\n");
abort_resume:
	mutex_unlock(&power_suspend_lock);
}

bool power_suspended = false;

void set_power_suspend_state(int new_state)
{
	unsigned long irqflags;

	if (state != new_state) {
		spin_lock_irqsave(&state_lock, irqflags);
		if (state == POWER_SUSPEND_INACTIVE && new_state == POWER_SUSPEND_ACTIVE) {
			pr_info("[POWERSUSPEND] Suspend State Activated.\n");
			state = new_state;
			power_suspended = true;
			schedule_work(&power_suspend_work);
		} else if (state == POWER_SUSPEND_ACTIVE && new_state == POWER_SUSPEND_INACTIVE) {
			pr_info("[POWERSUSPEND] Resume State Activated.\n");
			state = new_state;
			power_suspended = false;
			schedule_work(&power_resume_work);
		}
		spin_unlock_irqrestore(&state_lock, irqflags);
	} else {
		pr_info("[POWERSUSPEND] state change requested, but unchanged ?! Ignored !\n");
	}
}

void set_power_suspend_state_autosleep_hook(int new_state)
{
	dprintk("[POWERSUSPEND] autosleep resquests %s.\n", new_state == POWER_SUSPEND_ACTIVE ? "sleep" : "wakeup");
	// Only allow autosleep hook changes in autosleep & hybrid mode
	if (mode == POWER_SUSPEND_AUTOSLEEP || mode == POWER_SUSPEND_HYBRID)
		set_power_suspend_state(new_state);
}

EXPORT_SYMBOL(set_power_suspend_state_autosleep_hook);

void set_power_suspend_state_panel_hook(int new_state)
{
	pr_info("[POWERSUSPEND] panel requests %s.\n", new_state == POWER_SUSPEND_ACTIVE ? "Suspend" : "Resume");
	set_power_suspend_state(new_state);
}

EXPORT_SYMBOL(set_power_suspend_state_panel_hook);

// ------------------------------------------ sysfs interface ------------------------------------------

static ssize_t power_suspend_version_show(struct kobject *kobj,
		struct kobj_attribute *attr, char *buf)
{
	int data = 0;

	sscanf(buf, "%d\n", &data);

	switch (data) {
		case POWER_SUSPEND_AUTOSLEEP:
		case POWER_SUSPEND_PANEL:
		case POWER_SUSPEND_USERSPACE:	mode = data;
		case POWER_SUSPEND_HYBRID:	mode = data;
						return count;
		default:
			return -EINVAL;
	}
}

static struct kobj_attribute power_suspend_version_attribute =
	__ATTR(power_suspend_version, 0444,
		power_suspend_version_show,
		NULL);

static struct attribute *power_suspend_attrs[] =
{
	&power_suspend_version_attribute.attr,
	NULL,
};

static struct attribute_group power_suspend_attr_group =
{
	.attrs = power_suspend_attrs,
};

static struct kobject *power_suspend_kobj;

// ------------------ sysfs interface -----------------------
static int power_suspend_init(void)
{
	int sysfs_result;

	power_suspend_kobj = kobject_create_and_add("power_suspend",
		kernel_kobj);

	if (!power_suspend_kobj) {
		pr_err("%s kobject create failed!\n", __FUNCTION__);
	return -ENOMEM;
	}

	sysfs_result = sysfs_create_group(power_suspend_kobj,
		&power_suspend_attr_group);

	if (sysfs_result) {
		pr_info("%s group create failed!\n", __FUNCTION__);
		kobject_put(power_suspend_kobj);
	return -ENOMEM;
	}

	INIT_WORK(&power_suspend_work, power_suspend);
	INIT_WORK(&power_resume_work, power_resume);

	return 0;
}

static void power_suspend_exit(void)
{
	flush_work(&power_resume_work);
	flush_work(&power_suspend_work);

	if (power_suspend_kobj != NULL)
		kobject_put(power_suspend_kobj);
}

subsys_initcall(power_suspend_init);
module_exit(power_suspend_exit);

MODULE_AUTHOR("Paul Reioux <reioux@gmail.com> / Jean-Pierre Rasquin <yank555.lu@gmail.com>");
MODULE_DESCRIPTION("power_suspend - A replacement kernel PM driver for"
        "Android's deprecated early_suspend/late_resume PM driver!");
MODULE_LICENSE("GPL v2");

