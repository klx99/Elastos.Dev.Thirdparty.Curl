#!/bin/bash

SDK=19

BUILD_DIR="$PROJECT_DIR/build/android";
OUTPUT_DIR="$BUILD_DIR/output";

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
	$ANDROID_NDK_HOME/build/tools/make-standalone-toolchain.sh --arch=arm --platform=android-$SDK --stl=libc++ --install-dir="$ANDROID_TOOLCHAIN" --toolchain=arm-linux-androideabi-4.9

	touch "$BUILD_DIR/.toolchain";
fi

export PATH="$ANDROID_TOOLCHAIN/bin:$PATH"
export CFLAGS="-D__ANDROID_API__=$SDK"

