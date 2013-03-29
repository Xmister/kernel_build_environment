#!/bin/bash
cd /home/xmister/htc/
rm build.log
cd /home/xmister/htc/kernel
#Sense
make clean 2>&1
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- clean >> ../build.log 2>&1
#make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- ap33_android_defconfig >> ../build.log 2>&1
cat arch/arm/configs/ap33_android_defconfig arch/arm/configs/ap33_android_sense > .config
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- -j6 >> ../build.log 2>&1
cd ..
rm -rf build/*
cp kernel/arch/arm/boot/zImage build/zImage_sense
MOD_DIR=build/sense/system/lib/modules
mkdir -p $MOD_DIR
find kernel/arch -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
find kernel/crypto -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
find kernel/drivers -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
find kernel/fs -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
find kernel/ipc -type f -name '*.ko' -exec cp -f {} $MOD_DIR \; 
find kernel/net -type f -name '*.ko' -exec cp -f {} $MOD_DIR \; 
#Sense end
#AOSP
cd /home/xmister/htc/kernel
ver=$(cat .version)
ver=$(($ver-1))
echo $ver > .version
make clean 2>&1
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- clean >> ../build.log 2>&1
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- ap33_android_defconfig >> ../build.log 2>&1
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- -j6 >> ../build.log 2>&1
cd ..
cp kernel/arch/arm/boot/zImage build/zImage_aosp
#AOSP end
MOD_DIR=build/aosp/system/lib/modules
mkdir -p $MOD_DIR
find kernel/arch -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
find kernel/crypto -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
find kernel/drivers -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
find kernel/fs -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
find kernel/ipc -type f -name '*.ko' -exec cp -f {} $MOD_DIR \; 
find kernel/net -type f -name '*.ko' -exec cp -f {} $MOD_DIR \; 
