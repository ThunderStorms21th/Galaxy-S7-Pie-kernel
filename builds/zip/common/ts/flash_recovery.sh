#!/sbin/sh
#
# Recovery Flash script 1.0
#
# Thanks to dwander for original script
# 

variant=$1
bb=/sbin/busybox

cd /tmp/ts

$bb tar -Jxf recovery.tar.xz $variant-recovery.img

dd of=/dev/block/platform/155a0000.ufs/by-name/RECOVERY if=/tmp/ts/$variant-recovery.img


