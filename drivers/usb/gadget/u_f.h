/*
 * u_f.h
 *
 * Utility definitions for USB functions
 *
 * Copyright (c) 2013 Samsung Electronics Co., Ltd.
 *		http://www.samsung.com
 *
 * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#ifndef __U_F_H__
#define __U_F_H__

#include <linux/usb/gadget.h>

/* Variable Length Array Macros **********************************************/
#define vla_group(groupname) size_t groupname##__next = 0
#define vla_group_size(groupname) groupname##__next

#define vla_item(groupname, type, name, n) \
	size_t groupname##_##name##__offset = ({			       \
		size_t align_mask = __alignof__(type) - 1;		       \
		size_t offset = (groupname##__next + align_mask) & ~align_mask;\
		size_t size = (n) * sizeof(type);			       \
		groupname##__next = offset + size;			       \
		offset;							       \
	})

#define vla_item_with_sz(groupname, type, name, n) \
	size_t groupname##_##name##__sz = (n) * sizeof(type);		       \
	size_t groupname##_##name##__offset = ({			       \
		size_t align_mask = __alignof__(type) - 1;		       \
		size_t offset = (groupname##__next + align_mask) & ~align_mask;\
		size_t size = groupname##_##name##__sz;			       \
		groupname##__next = offset + size;			       \
		offset;							       \
	})

#define vla_ptr(ptr, groupname, name) \
	((void *) ((char *)ptr + groupname##_##name##__offset))

struct usb_ep;
struct usb_request;

/**
 * alloc_ep_req - returns a usb_request allocated by the gadget driver and
 * allocates the request's buffer.
 *
 * @ep: the endpoint to allocate a usb_request
 * @len: usb_requests's buffer suggested size
 * @default_len: used if @len is not provided, ie, is 0
 *
 * In case @ep direction is OUT, the @len will be aligned to ep's
 * wMaxPacketSize. In order to avoid memory leaks or drops, *always* use
 * usb_requests's length (req->length) to refer to the allocated buffer size.
 * Requests allocated via alloc_ep_req() *must* be freed by free_ep_req().
 */
struct usb_request *alloc_ep_req(struct usb_ep *ep, size_t len, int default_len);

/* Frees a usb_request previously allocated by alloc_ep_req() */
static inline void midi_free_ep_req(struct usb_ep *ep, struct usb_request *req)
{
	kfree(req->buf);
	usb_ep_free_request(ep, req);
}

#endif /* __U_F_H__ */
