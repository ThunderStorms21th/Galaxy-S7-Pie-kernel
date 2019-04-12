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

	# Clean Apex data
	rm -rf /data/data/com.sec.android.app.apex
	# Remove init.d Placeholder
	rm -f /system/etc/init.d/placeholder
	# Delete Wakelock.sh 
	rm -f /magisk/phh/su.d/wakelock*
	rm -f /su/su.d/wakelock*
	rm -f /system/su.d/wakelock*
	rm -f /system/etc/init.d/wakelock*
	mkdir -p /system/t 2>/dev/null;

	# rm -Rf /system/vendor/firmware

	## PERMISSIONS
	ui_print " "
	ui_print "@Setting Permissions"
	set_perm 0 2000 0644 /system/lib/libsecure_storage.so u:object_r:system_file:s0
	set_perm 0 2000 0644 /system/lib/libsecure_storage_jni.so u:object_r:system_file:s0
	set_perm 0 2000 0644 /system/lib64/libsecure_storage.so u:object_r:system_file:s0
	set_perm 0 2000 0644 /system/lib64/libsecure_storage_jni.so u:object_r:system_file:s0
	set_perm 0 0 0644 /system/priv-app/PersonalPageService/* u:object_r:system_file:s0

	set_perm 0 0 0644 /system/vendor/firmware/bcm4359C0_murata.hcd u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/bcm4359C0_semco.hcd u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/companion_2l1_master_setfile.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/companion_2l1_master_setfile_d.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/companion_2l1_mode_setfile.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/companion_2l1_mode_setfile_d.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/companion_fw_2l1.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/companion_fw_2l1_d.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/companion_fw_imx260.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/companion_fw_imx260_d.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/companion_imx260_master_setfile.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/companion_imx260_master_setfile_d.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/companion_imx260_mode_setfile.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/companion_imx260_mode_setfile_d.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/fimc_is_fw2_2l1.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/fimc_is_fw2_2l1_d.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/fimc_is_fw2_imx260.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/fimc_is_fw2_imx260_d.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/mfc_fw.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/nfc/sec_s3nrn81_firmware.bin u:object_r:vendor_firmware_file:s0  
	set_perm 0 0 0644 /system/vendor/firmware/ois_fw_dom.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/ois_fw_sec.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/seiren_fw_dram.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/seiren_fw_sram.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/setfile_2l1.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/setfile_2l1_d.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/setfile_4e6.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/setfile_4e6_d.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/setfile_imx260.bin u:object_r:vendor_firmware_file:s0 
	set_perm 0 0 0644 /system/vendor/firmware/setfile_imx260_d.bin u:object_r:vendor_firmware_file:s0 


