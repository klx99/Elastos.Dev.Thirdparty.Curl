#!/bin/bash

set -o errexit
set -o nounset

print_usage()
{
	echo '
NAME
       build-openssl-android

SYNOPSIS
       build-openssl-android [options]
       Example: ./build-openssl-android.sh

DESCRIPTION
       Auto build openssl for android script.

OPTIONS
       -h, --help
                 Optional. Print help infomation and exit successfully.';
}

parse_options()
{
	options=$($CMD_GETOPT -o h \
												--long "help" \
												-n 'build-openssl-android' -- "$@");
	eval set -- "$options"
	while true; do
		case "$1" in
			(-h | --help)
				print_usage;
				exit 0;
				;;
			(- | --)
				shift;
				break;
				;;
			(*)
				echo "Internal error!";
				exit 1;
				;;
		esac
	done
}

print_input_log()
{
	logtrace "*********************************************************";
	logtrace " Input infomation";
	logtrace "    openssl version : $OPENSSL_VERSION";
	logtrace "    debug verbose   : $DEBUG_VERBOSE";
	logtrace "*********************************************************";
}

download_tarball()
{
	if [ ! -e "$BUILD_DIR/.download" ]; then
		openss_url="$OPENSSL_BASE_URL/$OPENSSL_TARBALL";
		curl -O "$openss_url";
		echo "$openss_url" > "$BUILD_DIR/.download";
	fi

	loginfo "$OPENSSL_TARBALL has been downloaded."
}

build_openssl()
{
	if [ ! -e "$BUILD_DIR/$OPENSSL_NAME" ]; then
		tar xf "$OPENSSL_TARBALL";
	fi
	loginfo "$OPENSSL_TARBALL has been unpacked."
	cd "$BUILD_DIR/$OPENSSL_NAME";
	export ANDROID_NDK="$ANDROID_TOOLCHAIN";
	./Configure --prefix=$OUTPUT_DIR android-arm no-asm no-shared no-cast no-idea no-camellia;

	#make -j$MAX_JOBS && make install_engine
	make install_dev
}

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd);
PROJECT_DIR=$(dirname "$SCRIPT_DIR");
BUILD_DIR="$PROJECT_DIR/build/openssl/";
OUTPUT_DIR="$PROJECT_DIR/build/output/";

DEBUG_VERBOSE=false;

OPENSSL_BASE_URL="https://www.openssl.org/source";
OPENSSL_VERSION="1.1.1a";
OPENSSL_NAME="openssl-$OPENSSL_VERSION";
OPENSSL_TARBALL="$OPENSSL_NAME.tar.gz";

source "$SCRIPT_DIR/base.sh";
source "$SCRIPT_DIR/setenv-android.sh";

main_run()
{
	loginfo "parsing options";
	parse_options $@;

	cd "$PROJECT_DIR";
	loginfo "change directory to $PROJECT_DIR";

	print_input_log;

	mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR";
	download_tarball;

	build_openssl;

	loginfo "DONE !!!";
}

main_run $@;
