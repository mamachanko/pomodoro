#/usr/bin/env bash

set -ex

elm-format \
    --yes \
    src \
    tests
