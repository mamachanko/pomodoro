#/usr/bin/env bash

set -ex

./build.sh

elm test
