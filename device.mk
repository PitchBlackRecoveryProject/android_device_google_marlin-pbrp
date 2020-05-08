#
# Copyright (C) 2016 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This file includes all definitions that apply to ALL marlin and sailfish devices
#
# Everything in this directory will become public

ifeq ($(TARGET_PREBUILT_KERNEL),)
    LOCAL_KERNEL := device/google/marlin/Image.gz-dtb
    BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
else
LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_SHIPPING_API_LEVEL := 25

PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel

# Write Manufacturer & Model information in created media files.
# IMPORTANT: ONLY SET THIS PROPERTY TO TRUE FOR PUBLIC DEVICES
ifneq ($(filter omni_sailfish% sailfish% omni_marlin% lineage_marlin% marlin% lineage_sailfish%, $(TARGET_PRODUCT)),)
PRODUCT_PROPERTY_OVERRIDES += \
    media.recorder.show_manufacturer_and_model=true
else
$(error "you must decide whether to write manufacturer and model information into created media files for this device. ONLY ENABLE IT FOR PUBLIC DEVICE.")
endif  #TARGET_PRODUCT

# Use the A/B updater.
AB_OTA_UPDATER := true
PRODUCT_PACKAGES += \
    update_engine \
    update_verifier

# Enable update engine sideloading by including the static version of the
# boot_control HAL and its dependencies.
PRODUCT_STATIC_BOOT_CONTROL_HAL := \
    bootctrl.msm8996 \
    libgptutils \
    libz \
    libcutils
PRODUCT_PACKAGES += \
    update_engine_sideload

# Tell the system to enable copying odexes from other partition.
PRODUCT_PACKAGES += \
	cppreopts.sh

PRODUCT_PACKAGES_DEBUG += \
    update_engine_client

# A/B updater updatable partitions list. Keep in sync with the partition list
# with "_a" and "_b" variants in the device. Note that the vendor can add more
# more partitions to this list for the bootloader and radio.
AB_OTA_PARTITIONS += \
    boot \
    system

# A/B OTA dexopt package
PRODUCT_PACKAGES += otapreopt_script

# A/B OTA dexopt update_engine hookup
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

# Bootloader HAL used for A/B updates.
PRODUCT_PACKAGES += \
    bootctrl.msm8996
PRODUCT_PACKAGES_DEBUG += \
    bootctl

# Partitions (listed in the file) to be wiped under recovery.
TARGET_RECOVERY_WIPE := \
    device/google/marlin/recovery.wipe.common

# b/35633646
# Statically linked toybox for modprobe in recovery mode
#PRODUCT_PACKAGES += \
    toybox_static

PRODUCT_COPY_FILES += \
    device/google/marlin/recovery/root/etc/twrp.fstab:recovery/root/etc/twrp.fstab \
    device/google/marlin/recovery/root/sbin/bootctrl.msm8996.so:recovery/root/sbin/bootctrl.msm8996.so \
    device/google/marlin/recovery/root/sbin/libdiag.so:recovery/root/sbin/libdiag.so \
    device/google/marlin/recovery/root/sbin/libdrmfs.so:recovery/root/sbin/libdrmfs.so \
    device/google/marlin/recovery/root/sbin/libdrmtime.so:recovery/root/sbin/libdrmtime.so \
    device/google/marlin/recovery/root/sbin/libQSEEComAPI.so:recovery/root/sbin/libQSEEComAPI.so \
    device/google/marlin/recovery/root/sbin/librpmb.so:recovery/root/sbin/librpmb.so \
    device/google/marlin/recovery/root/sbin/libssd.so:recovery/root/sbin/libssd.so \
    device/google/marlin/recovery/root/sbin/qseecomd:recovery/root/sbin/qseecomd \
    device/google/marlin/recovery/root/sbin/android.hardware.keymaster@3.0-service:recovery/root/sbin/android.hardware.keymaster@3.0-service \
    device/google/marlin/recovery/root/vendor/compatibility_matrix.1.xml:recovery/root/vendor/compatibility_matrix.1.xml \
    device/google/marlin/recovery/root/vendor/compatibility_matrix.2.xml:recovery/root/vendor/compatibility_matrix.2.xml \
    device/google/marlin/recovery/root/vendor/compatibility_matrix.3.xml:recovery/root/vendor/compatibility_matrix.3.xml \
    device/google/marlin/recovery/root/vendor/compatibility_matrix.device.xml:recovery/root/vendor/compatibility_matrix.device.xml \
    device/google/marlin/recovery/root/vendor/compatibility_matrix.legacy.xml:recovery/root/vendor/compatibility_matrix.legacy.xml \
    device/google/marlin/recovery/root/vendor/etc/vintf/manifest.xml:recovery/root/vendor/etc/vintf/manifest.xml \
    device/google/marlin/recovery/root/vendor/system_manifest.xml:recovery/root/vendor/system_manifest.xml \
    device/google/marlin/recovery/root/vendor/etc/vintf/compatibility_matrix.xml:recovery/root/vendor/etc/vintf/compatibility_matrix.xml \
    device/google/marlin/recovery/root/vendor/lib64/hw/android.hardware.boot@1.0-impl.so:recovery/root/vendor/lib64/hw/android.hardware.boot@1.0-impl.so \
    device/google/marlin/recovery/root/vendor/lib64/hw/android.hardware.gatekeeper@1.0-impl.so:recovery/root/vendor/lib64/hw/android.hardware.gatekeeper@1.0-impl.so \
    device/google/marlin/recovery/root/vendor/lib64/hw/android.hardware.keymaster@3.0-impl.so:recovery/root/vendor/lib64/hw/android.hardware.keymaster@3.0-impl.so \
    device/google/marlin/recovery/root/vendor/lib64/hw/gatekeeper.msm8996.so:recovery/root/vendor/lib64/hw/gatekeeper.msm8996.so \
    device/google/marlin/recovery/root/vendor/lib64/hw/keystore.msm8996.so:recovery/root/vendor/lib64/hw/keystore.msm8996.so \
    device/google/marlin/recovery/root/vendor/lib64/hw/bootctrl.msm8996.so:recovery/root/vendor/lib64/hw/bootctrl.msm8996.so \
    device/google/marlin/recovery/root/vendor/lib64/libgptutils.so:recovery/root/vendor/lib64/libgptutils.so \
    device/google/marlin/recovery/root/init.recovery.usb.rc:recovery/root/init.recovery.usb.rc \
    device/google/marlin/recovery/root/init.recovery.common.rc:recovery/root/init.recovery.common.rc \
    device/google/marlin/recovery/root/init.recovery.marlin.rc:recovery/root/init.recovery.marlin.rc \
    device/google/marlin/recovery/root/init.recovery.sailfish.rc:recovery/root/init.recovery.sailfish.rc \
    device/google/marlin/recovery/root/nonplat_hwservice_contexts:recovery/root/nonplat_hwservice_contexts \
    device/google/marlin/recovery/root/plat_hwservice_contexts:recovery/root/plat_hwservice_contexts \
    device/google/marlin/recovery/root/nonplat_service_contexts:recovery/root/nonplat_service_contexts \
    device/google/marlin/recovery/root/plat_service_contexts:recovery/root/plat_service_contexts \
    device/google/marlin/recovery/root/sbin/android.hardware.gatekeeper@1.0-service:recovery/root/sbin/android.hardware.gatekeeper@1.0-service \
    device/google/marlin/recovery/root/sbin/prepdecrypt.sh:recovery/root/sbin/prepdecrypt.sh \
    device/google/marlin/recovery/root/sbin/android.hardware.boot@1.0-service:recovery/root/sbin/android.hardware.boot@1.0-service \
    device/google/marlin/recovery/root/sbin/libpuresoftkeymasterdevice.so:recovery/root/sbin/libpuresoftkeymasterdevice.so \
    device/google/marlin/recovery/root/sbin/libkeymaster3device.so:recovery/root/sbin/libkeymaster3device.so \
    device/google/marlin/recovery/root/sbin/android.hardware.confirmationui@1.0.so:recovery/root/sbin/android.hardware.confirmationui@1.0.so \
