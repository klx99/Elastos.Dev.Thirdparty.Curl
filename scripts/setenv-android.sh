#!/bin/bash
TARGET=android-19

if [ -z "$ANDROID_NDK_HOME" ]; then
	echo "Please set your ANDROID_NDK_HOME environment variable first"
	exit 1
fi

if [[ "$ANDROID_NDK_HOME" == .* ]]; then
	echo "Please set your ANDROID_NDK_HOME to an absolute path"
	exit 1
fi

#Configure toolchain
ANDROID_TOOLCHAIN="$BUILD_DIR/toolchain";
if [ ! -e "$BUILD_DIR/.toolchain" ]; then
	rm -rf "$ANDROID_TOOLCHAIN"
	$ANDROID_NDK_HOME/build/tools/make-standalone-toolchain.sh --arch=arm --platform=$TARGET --install-dir="$ANDROID_TOOLCHAIN"

	touch "$BUILD_DIR/.toolchain";
fi

export PATH="$PATH:$ANDROID_TOOLCHAIN/bin"

# Setup cross-compile environment
#export SYSROOT=$TOOLCHAIN/sysroot
#export ARCH=armv7
#export CC=$TOOLCHAIN/bin/arm-linux-androideabi-gcc
#export CXX=$TOOLCHAIN/bin/arm-linux-androideabi-g++
#export AR=$TOOLCHAIN/bin/arm-linux-androideabi-ar
#export AS=$TOOLCHAIN/bin/arm-linux-androideabi-as
#export LD=$TOOLCHAIN/bin/arm-linux-androideabi-ld
#export RANLIB=$TOOLCHAIN/bin/arm-linux-androideabi-ranlib
#export NM=$TOOLCHAIN/bin/arm-linux-androideabi-nm
#export STRIP=$TOOLCHAIN/bin/arm-linux-androideabi-strip
#export CHOST=$TOOLCHAIN/bin/arm-linux-androideabi
