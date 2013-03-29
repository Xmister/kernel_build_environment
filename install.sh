#!/bin/bash
adb shell mount -o remount,rw /system
cd /home/xmister/htc/build/sense
adb push system /system
adb shell chmod 0755 /system/lib/modules/*
adb shell mount -o remount,ro /system
cd /home/xmister/htc/packing
cp -f *_boot.img /mnt/hgfs/C/Fastboot
