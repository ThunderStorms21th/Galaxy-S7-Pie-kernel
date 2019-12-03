#!/bin/bash
#
# Thanks to djb77 
#
# Thanks to MoRoGoku for Cleaning Script
#
# ThundeRStorms cleaning script v1.6

echo ""
echo "Cleaning script for ThunderStorms kernel"
echo ""
echo "Start cleaning..." 
echo ""

# Clean Build Data
make clean
make ARCH=arm64 distclean

rm -f ./Edge_build.log
rm -f ./Flat_build.log

# Remove Release files
rm -f $PWD/builds/*.zip
rm -rf $PWD/builds/temp
rm -rf $PWD/builds/temp2
rm -f $PWD/arch/arm64/configs/tmp_defconfig

# Removed Created dtb Folder
rm -rf $PWD/arch/arm64/boot/dtb

# Recreate Ramdisk Placeholders
echo "" > $PWD/builds/TW-OREO/ramdisk/acct/.placeholder
echo "" > $PWD/builds/TW-OREO/ramdisk/cache/.placeholder
echo "" > $PWD/builds/TW-OREO/ramdisk/config/.placeholder
echo "" > $PWD/builds/TW-OREO/ramdisk/data/.placeholder
echo "" > $PWD/builds/TW-OREO/ramdisk/dev/.placeholder
echo "" > $PWD/builds/TW-OREO/ramdisk/lib/modules/.placeholder
echo "" > $PWD/builds/TW-OREO/ramdisk/mnt/.placeholder
echo "" > $PWD/builds/TW-OREO/ramdisk/proc/.placeholder
echo "" > $PWD/builds/TW-OREO/ramdisk/storage/.placeholder
echo "" > $PWD/builds/TW-OREO/ramdisk/sys/.placeholder
echo "" > $PWD/builds/TW-OREO/ramdisk/system/.placeholder

echo "" > $PWD/builds/TW-PIE/ramdisk/acct/.placeholder
echo "" > $PWD/builds/TW-PIE/ramdisk/cache/.placeholder
echo "" > $PWD/builds/TW-PIE/ramdisk/config/.placeholder
echo "" > $PWD/builds/TW-PIE/ramdisk/data/.placeholder
echo "" > $PWD/builds/TW-PIE/ramdisk/dev/.placeholder
echo "" > $PWD/builds/TW-PIE/ramdisk/keydata/.placeholder
echo "" > $PWD/builds/TW-PIE/ramdisk/keyrefuge/.placeholder
echo "" > $PWD/builds/TW-PIE/ramdisk/lib/modules/.placeholder
echo "" > $PWD/builds/TW-PIE/ramdisk/mnt/.placeholder
echo "" > $PWD/builds/TW-PIE/ramdisk/omr/.placeholder
echo "" > $PWD/builds/TW-PIE/ramdisk/proc/.placeholder
echo "" > $PWD/builds/TW-PIE/ramdisk/storage/.placeholder
echo "" > $PWD/builds/TW-PIE/ramdisk/sys/.placeholder
echo "" > $PWD/builds/TW-PIE/ramdisk/system/.placeholder

echo "" > $PWD/builds/LOS16/ramdisk/acct/.placeholder
echo "" > $PWD/builds/LOS16/ramdisk/config/.placeholder
echo "" > $PWD/builds/LOS16/ramdisk/data/.placeholder
echo "" > $PWD/builds/LOS16/ramdisk/dev/.placeholder
echo "" > $PWD/builds/LOS16/ramdisk/mnt/.placeholder
echo "" > $PWD/builds/LOS16/ramdisk/oem/.placeholder
echo "" > $PWD/builds/LOS16/ramdisk/proc/.placeholder
echo "" > $PWD/builds/LOS16/ramdisk/storage/.placeholder
echo "" > $PWD/builds/LOS16/ramdisk/sys/.placeholder
echo "" > $PWD/builds/LOS16/ramdisk/system/.placeholder

echo "" > $PWD/builds/LOS17/ramdisk/apex/.placeholder
echo "" > $PWD/builds/LOS17/ramdisk/debug_ramdisk/.placeholder
echo "" > $PWD/builds/LOS17/ramdisk/dev/.placeholder
echo "" > $PWD/builds/LOS17/ramdisk/mnt/.placeholder
echo "" > $PWD/builds/LOS17/ramdisk/proc/.placeholder
echo "" > $PWD/builds/LOS17/ramdisk/sys/.placeholder

echo "" > $PWD/builds/TREBLE-Q/ramdisk/acct/.placeholder
echo "" > $PWD/builds/TREBLE-Q/ramdisk/cache/.placeholder
echo "" > $PWD/builds/TREBLE-Q/ramdisk/carrier/.placeholder
echo "" > $PWD/builds/TREBLE-Q/ramdisk/config/.placeholder
echo "" > $PWD/builds/TREBLE-Q/ramdisk/data/.placeholder
echo "" > $PWD/builds/TREBLE-Q/ramdisk/dev/.placeholder
echo "" > $PWD/builds/TREBLE-Q/ramdisk/dqmdbg/.placeholder
echo "" > $PWD/builds/TREBLE-Q/ramdisk/efs/.placeholder
echo "" > $PWD/builds/TREBLE-Q/ramdisk/keydata/.placeholder
echo "" > $PWD/builds/TREBLE-Q/ramdisk/keyrefuge/.placeholder
echo "" > $PWD/builds/TREBLE-Q/ramdisk/lib/modules/.placeholder
echo "" > $PWD/builds/TREBLE-Q/ramdisk/mnt/.placeholder
echo "" > $PWD/builds/TREBLE-Q/ramdisk/oem/.placeholder
echo "" > $PWD/builds/TREBLE-Q/ramdisk/omr/.placeholder
echo "" > $PWD/builds/TREBLE-Q/ramdisk/proc/.placeholder
echo "" > $PWD/builds/TREBLE-Q/ramdisk/storage/.placeholder
echo "" > $PWD/builds/TREBLE-Q/ramdisk/sys/.placeholder
echo "" > $PWD/builds/TREBLE-Q/ramdisk/system/.placeholder
echo "" > $PWD/builds/TREBLE-Q/ramdisk/vendor/.placeholder

echo "" > $PWD/builds/TREBLE-P/ramdisk/acct/.placeholder
echo "" > $PWD/builds/TREBLE-P/ramdisk/cache/.placeholder
echo "" > $PWD/builds/TREBLE-P/ramdisk/carrier/.placeholder
echo "" > $PWD/builds/TREBLE-P/ramdisk/config/.placeholder
echo "" > $PWD/builds/TREBLE-P/ramdisk/data/.placeholder
echo "" > $PWD/builds/TREBLE-P/ramdisk/dev/.placeholder
echo "" > $PWD/builds/TREBLE-P/ramdisk/dqmdbg/.placeholder
echo "" > $PWD/builds/TREBLE-P/ramdisk/efs/.placeholder
echo "" > $PWD/builds/TREBLE-P/ramdisk/keydata/.placeholder
echo "" > $PWD/builds/TREBLE-P/ramdisk/keyrefuge/.placeholder
echo "" > $PWD/builds/TREBLE-P/ramdisk/lib/modules/.placeholder
echo "" > $PWD/builds/TREBLE-P/ramdisk/mnt/.placeholder
echo "" > $PWD/builds/TREBLE-P/ramdisk/oem/.placeholder
echo "" > $PWD/builds/TREBLE-P/ramdisk/omr/.placeholder
echo "" > $PWD/builds/TREBLE-P/ramdisk/proc/.placeholder
echo "" > $PWD/builds/TREBLE-P/ramdisk/storage/.placeholder
echo "" > $PWD/builds/TREBLE-P/ramdisk/sys/.placeholder
echo "" > $PWD/builds/TREBLE-P/ramdisk/system/.placeholder
echo "" > $PWD/builds/TREBLE-P/ramdisk/vendor/.placeholder


