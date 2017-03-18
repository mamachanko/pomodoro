#/usr/bin/env bash

set -ex

./build.sh

pushd dist

python -m SimpleHTTPServer 8001

popd
