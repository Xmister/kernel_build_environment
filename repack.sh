#!/bin/bash
#now=$(date +"%Y%m%d_%H%M")
now=$(cat /home/xmister/htc/kernel/.version)
cd /home/xmister/htc/build
cp -f zImage* ../packing
cd ../packing
rm sense.cpio.gz
rm aosp.cpio.gz
cd sense
ls | cpio -o > ../sense.cpio
cd ..
gzip sense.cpio
cd aosp
ls | cpio -o > ../aosp.cpio
cd ..
gzip aosp.cpio
rm sense_boot.img
rm aosp_boot.img
mkbootimg --kernel zImage_sense --ramdisk sense.cpio.gz -o sense_boot.img
mkbootimg --kernel zImage_aosp --ramdisk aosp.cpio.gz -o aosp_boot.img
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
