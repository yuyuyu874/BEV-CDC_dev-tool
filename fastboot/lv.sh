#!/bin/bash
set -e

EXE_DIR="/mnt/c/Program Files/platform-tools/fastboot.exe"

echo "Starting LV flashing process..."
cd /mnt/c/work/lv/

echo "========================================"
echo "erace LA partition..."
echo "========================================"

"$EXE_DIR" erase la_boot_a
"$EXE_DIR" erase la_boot_b

echo "========================================"
echo "flashing LV partition..."
echo "========================================"

"$EXE_DIR" flash lv_boot quin-gvm-lemans-boot.img
"$EXE_DIR" flash lv_system machine-image-quin-gvm-lemans.ext4
"$EXE_DIR" flash lv_userdata quin-gvm-lemans-usrfs.ext4
"$EXE_DIR" flash lv_persist quin-gvm-lemans-persist.ext4
"$EXE_DIR" flash lv_vbmeta quin-gvm-lemans-vbmeta.img

echo "========================================"
echo "rebooting device..."
echo "========================================"

"$EXE_DIR" reboot