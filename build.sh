#!/bin/bash
KBE_PATH=/home/xmister/htc/
KERNEL_DIR=kernel
KERNEL_PATH=$KBE_PATH/$KERNEL_DIR
TOOLCHAIN=arm-linux-gnueabi-
BUILD_DIR=build
BUILD_LOG=../build.log
cd $KBE_PATH
rm $BUILD_LOG
cd $KERNEL_PATH
#Sense
make clean 2>&1
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN clean >> $BUILD_LOG 2>&1
cat arch/arm/configs/ap33_android_defconfig arch/arm/configs/ap33_android_sense > .config
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -j6 >> $BUILD_LOG 2>&1
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -C drivers/net/wireless/compat-wireless_R5.SP2.03 KLIB=`pwd` KLIB_BUILD=`pwd` clean
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -C drivers/net/wireless/compat-wireless_R5.SP2.03 KLIB=`pwd` KLIB_BUILD=`pwd` -j2 >> $BUILD_LOG 2>&1
cd ..
rm -rf build/*
cp $KERNEL_DIR/arch/arm/boot/zImage $BUILD_DIR/zImage_sense
MOD_DIR=$BUILD_DIR/sense/system/lib/modules
mkdir -p $MOD_DIR
find $KERNEL_DIR/arch -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
find $KERNEL_DIR/crypto -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
find $KERNEL_DIR/fs -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
find $KERNEL_DIR/ipc -type f -name '*.ko' -exec cp -f {} $MOD_DIR \; 
find $KERNEL_DIR/net -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
find $KERNEL_DIR/drivers -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
find $KERNEL_DIR/drivers/net/wireless/compat-wireless_R5.SP2.03 -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
#Sense end
#AOSP
cd $KERNEL_PATH
ver=$(cat .version)
ver=$(($ver-1))
echo $ver > .version
make clean 2>&1
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN clean >> $BUILD_LOG 2>&1
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN ap33_android_defconfig >> $BUILD_LOG 2>&1
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -j6 >> $BUILD_LOG 2>&1
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -C drivers/net/wireless/compat-wireless_R5.SP2.03 KLIB=`pwd` KLIB_BUILD=`pwd` clean
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -C drivers/net/wireless/compat-wireless_R5.SP2.03 KLIB=`pwd` KLIB_BUILD=`pwd` -j2 >> $BUILD_LOG 2>&1
cd ..
cp $KERNEL_DIR/arch/arm/boot/zImage $BUILD_DIR/zImage_aosp
#AOSP end
MOD_DIR=$BUILD_DIR/aosp/system/lib/modules
mkdir -p $MOD_DIR
find $KERNEL_DIR/arch -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
find $KERNEL_DIR/crypto -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
find $KERNEL_DIR/fs -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
find $KERNEL_DIR/ipc -type f -name '*.ko' -exec cp -f {} $MOD_DIR \; 
find $KERNEL_DIR/net -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
find $KERNEL_DIR/drivers -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
find $KERNEL_DIR/drivers/net/wireless/compat-wireless_R5.SP2.03 -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
