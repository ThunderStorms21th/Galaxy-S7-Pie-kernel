#!/system/bin/sh

# ThunderStormS kill Google and MEdia servers script
busybox=/sbin/busybox || /xbin/busybox;

busybox touch /sdcard/TS1

TS1=/sdcard/TS1;

# START LOOP 7200sec = 2h
RUN_EVERY=7200

if [ -e $TS1 ]; then
	LASTRUN=`stat -t $TS1 | awk '{print $14}'`
else
	LASTRUN=0
fi;

# get current date in epoch format
CURRDATE=`date +%s`
# check interval
INTERVAL=$(expr $CURRDATE - $LASTRUN) 

if [ $INTERVAL -gt $RUN_EVERY ]; then
   if [ -e $TS1 ]; then
      rm -f $TS1;
   fi;
   else
   sh ts-kill.sh  >/dev/null
   sh /sbin/ts-kill.sh >/dev/null
fi;
  
##KILL MEDIA
if [ "`pgrep media`" ] && [ "`pgrep mediaserver`" ]; then
busybox killall -9 android.process.media
busybox killall -9 mediaserver
busybox killall -9 com.google.android.gms
busybox killall -9 com.google.android.gms.persistent
busybox killall -9 com.google.process.gapps
busybox killall -9 com.google.android.gsf
busybox killall -9 com.google.android.gsf.persistent
fi;

sleep 10

# FIX GOOGLE PLAY SERVICE
pm enable com.google.android.gms/.update.SystemUpdateActivity
pm enable com.google.android.gms/.update.SystemUpdateService
pm enable com.google.android.gms/.update.SystemUpdateService$ActiveReceiver
pm enable com.google.android.gms/.update.SystemUpdateService$Receiver
pm enable com.google.android.gms/.update.SystemUpdateService$SecretCodeReceiver
pm enable com.google.android.gsf/.update.SystemUpdateActivity
pm enable com.google.android.gsf/.update.SystemUpdatePanoActivity
pm enable com.google.android.gsf/.update.SystemUpdateService
pm enable com.google.android.gsf/.update.SystemUpdateService$Receiver
pm enable com.google.android.gsf/.update.SystemUpdateService$SecretCodeReceiver

# END OF LOOP
