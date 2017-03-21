#!/usr/bin/env bash

set -ex

./format.sh
./build.sh

elm test
