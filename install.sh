#!/bin/bash
ADB=/home/xmister/Downloads/android-sdk-linux/platform-tools/adb
${ADB} shell mount -o remount,rw /system
cd /home/xmister/htc/build/sense
${ADB} push system /system
${ADB} shell chmod 0755 /system/lib/modules/*
${ADB} shell mount -o remount,ro /system
cd /home/xmister/htc/packing
cp -f *_boot.img /mnt/hgfs/C/Fastboot
