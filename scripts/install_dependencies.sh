#!/bin/bash

set -e
set -x

UNAME=$(uname)

case "$UNAME" in
    Linux)
        sudo add-apt-repository --yes ppa:kubuntu-ppa/backports
        sudo add-apt-repository --yes ppa:hlprasu/swig-trusty-backports
        sudo apt-get update -qq
        sudo apt-get install -q -y mingw-w64 g++-mingw-w64
        sudo apt-get install -q -y build-essential cmake             \
                                   libudev-dev libbluetooth-dev      \
                                   libv4l-dev libopencv-dev          \
                                   openjdk-7-jdk ant liblwjgl-java   \
                                   python-dev mono-mcs               \
                                   swig3.0 freeglut3-dev             \
                                   python-sphinx python-pip

        # Workaround to get BlueZ 5 on Travis CI (it doesn't yet have Ubuntu 16.04)
        # Based on: https://askubuntu.com/a/662349
        if [ -f /etc/lsb-release ] && [ ! -z "$TRAVIS_BUILD_ID" ]; then
            . /etc/lsb-release
            if [ "$DISTRIB_RELEASE" = "14.04" ]; then
                echo "Detected Ubuntu 14.04 LTS, installing BlueZ 5"
                sudo add-apt-repository --yes ppa:vidplace7/bluez5
                sudo apt-get update -qq
                sudo apt-get install -q -y libbluetooth-dev
            fi
        fi
        ;;
    Darwin)
        brew update
        brew install --force cmake git libtool automake autoconf swig python || true
        brew unlink libtool ; brew link --overwrite libtool
        pip2 install --user sphinx
        ;;
    *)
        echo "Unknown OS: $UNAME"
        exit 1
        ;;
esac
