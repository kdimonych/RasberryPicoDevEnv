#!/bin/bash
pushd ~
rm -fR .pico-sdk
git clone https://github.com/raspberrypi/pico-sdk.git .pico-sdk
git config --global --add safe.directory ${PWD}/.pico-sdk
pushd .pico-sdk
git submodule update --init
popd
popd