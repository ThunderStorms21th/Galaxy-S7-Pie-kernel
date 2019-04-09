#!/sbin/sh
#
# Installin MTweaks
# Thx to MoroGoku
#
#


# Busybox 
BB=/sbin/busybox;

## MTWEAKS

	ui_print " "
	ui_print "@Installing MTWeaks App..."
	sh /tmp/ts/ts_clean.sh com.moro.mtweaks -as
	cp -rf /tmp/apps/com.moro.mtweaks-1 /data/app/com.moro.mtweaks-1
	cp -rf /tmp/ts/mtweaks/*.apk /data/.tskernel/apk
	cp -rf /ts/mtweaks/*.apk /data/.tskernel/apk
	cp -rf /mtweaks/*.apk /data/.tskernel/apk
	#apps/com.moro.mtweaks-1", "/data/app/com.moro.mtweaks-1");

