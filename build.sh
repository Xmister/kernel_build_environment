#!/bin/bash
KBE_PATH=/home/xmister/htc/
KERNEL_DIR=kernel
KERNEL_PATH=${KBE_PATH}/${KERNEL_DIR}
TOOLCHAIN=arm-linux-gnueabi-
BUILD_DIR=build
BUILD_LOG="../build.log"
cd $KBE_PATH
cd $KERNEL_PATH
rm $BUILD_LOG
#Sense
echo "Initializing Sense build..."
make clean >> $BUILD_LOG 2>&1
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN clean >> $BUILD_LOG 2>&1
cat arch/arm/configs/ap33_android_defconfig arch/arm/configs/ap33_android_sense > .config
echo "Building kernel..."
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -j6 >> $BUILD_LOG 2>&1
echo "Building wireless module..."
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -C drivers/net/wireless/compat-wireless_R5.SP2.03 KLIB=`pwd` KLIB_BUILD=`pwd` clean >> $BUILD_LOG 2>&1
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -C drivers/net/wireless/compat-wireless_R5.SP2.03 KLIB=`pwd` KLIB_BUILD=`pwd` -j2 >> $BUILD_LOG 2>&1
echo "Saving binaries..."
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
echo "Sense build done."
#Sense end
#AOSP
cd $KERNEL_PATH
ver=$(cat .version)
ver=$(($ver-1))
echo $ver > .version
echo "Initializing AOSP build..."
make clean >> $BUILD_LOG 2>&1
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN clean >> $BUILD_LOG 2>&1
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN ap33_android_defconfig >> $BUILD_LOG 2>&1
echo "Building kernel..."
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -j6 >> $BUILD_LOG 2>&1
echo "Building wireless module..."
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -C drivers/net/wireless/compat-wireless_R5.SP2.03 KLIB=`pwd` KLIB_BUILD=`pwd` clean >> $BUILD_LOG 2>&1
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -C drivers/net/wireless/compat-wireless_R5.SP2.03 KLIB=`pwd` KLIB_BUILD=`pwd` -j2 >> $BUILD_LOG 2>&1
echo "Saving binaries..."
cd ..
cp $KERNEL_DIR/arch/arm/boot/zImage $BUILD_DIR/zImage_aosp
MOD_DIR=$BUILD_DIR/aosp/system/lib/modules
mkdir -p $MOD_DIR
find $KERNEL_DIR/arch -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
find $KERNEL_DIR/crypto -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
find $KERNEL_DIR/fs -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
find $KERNEL_DIR/ipc -type f -name '*.ko' -exec cp -f {} $MOD_DIR \; 
find $KERNEL_DIR/net -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
find $KERNEL_DIR/drivers -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
find $KERNEL_DIR/drivers/net/wireless/compat-wireless_R5.SP2.03 -type f -name '*.ko' -exec cp -f {} $MOD_DIR \;
echo "AOSP build done."
#AOSP end
