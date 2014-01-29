#!/bin/bash
#now=$(date +"%Y%m%d_%H%M")
now=$(cat /home/xmister/htc/kernel/.version)
cd /home/xmister/htc/build
cp -f zImage* ../packing
cd ../packing
rm zImage
cp zImage_sense zImage
rm -rf ramdisk
cp -Ra sense ramdisk
rm sense_boot.img
cd ..
mkboot packing packing/sense_boot.img
cd packing
rm zImage
cp zImage_aosp zImage
rm -rf ramdisk
cp -Ra aosp ramdisk
rm aosp_boot.img
cd ..
mkboot packing packing/aosp_boot.img
rm -rf packing/ramdisk
#Sense
rm -rf /home/xmister/htc/release/system/lib
rm /home/xmister/htc/release/*.img
cp /home/xmister/htc/packing/sense_boot.img /home/xmister/htc/release
cp -R /home/xmister/htc/build/sense/system/lib /home/xmister/htc/release/system/lib
cd /home/xmister/htc/release/
zip -r xm_kernel_$(echo $now)_sense.zip *
mv *.zip /home/xmister/htc/update/
#AOSP
rm -rf /home/xmister/htc/release/system/lib
rm /home/xmister/htc/release/*.img
cp /home/xmister/htc/packing/aosp_boot.img /home/xmister/htc/release
cp -R /home/xmister/htc/build/aosp/system/lib /home/xmister/htc/release/system/lib
cd /home/xmister/htc/release/
zip -r xm_kernel_$(echo $now)_aosp.zip *
mv *.zip /home/xmister/htc/update/
#Publish files
u1-publish-folder /home/xmister/htc/update One/Worldwide
