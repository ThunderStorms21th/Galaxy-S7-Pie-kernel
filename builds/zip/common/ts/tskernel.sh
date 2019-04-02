#!/sbin/sh
# ------------------------------
# ThundeRStormS KERNEL INSTALLER
# Created by @djb77
#
# Credit also goes to @Tkkg1994,
# @lyapota, @Morogoku and 
# @dwander for bits of code
# ------------------------------

# Block location
BLOCK=/dev/block/platform/155a0000.ufs/by-name

# Variables
TSTEMP=/tmp/tstemp
AROMA=/tmp/aroma
TS=/data/media/0/TSkernel
CONFIG=$TGP/config
KERNELPATH=$TSTEMP/kernels
BUILDPROP=/system/build.prop

	## System Patches

	# Remove unwatned McRegistry entry
	rm -f /system/app/mcRegistry/ffffffffd00000000000000000000004.tlbin
	# Clean Apex data
	rm -rf /data/data/com.sec.android.app.apex
	# Remove init.d Placeholder
	rm -f /system/etc/init.d/placeholder
	# Delete Wakelock.sh 
	rm -f /magisk/phh/su.d/wakelock*
	rm -f /su/su.d/wakelock*
	rm -f /system/su.d/wakelock*
	rm -f /system/etc/init.d/wakelock*

	## PERMISSIONS
	ui_print " "
	ui_print "@Setting Permissions"
	set_perm 0 2000 0644 /system/vendor/lib/libsecure_storage.so u:object_r:system_file:s0
	set_perm 0 2000 0644 /system/vendor/lib64/libsecure_storage.so u:object_r:system_file:s0
	set_perm 0 2000 0644 /system/vendor/lib/egl/libGLES_mali.so u:object_r:system_file:s0
	set_perm 0 2000 0644 /system/vendor/lib64/egl/libGLES_mali.so u:object_r:system_file:s0
	set_perm 0 0 0644 /system/priv-app/PersonalPageService/* u:object_r:system_file:s0

