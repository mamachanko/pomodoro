#/usr/bin/env bash

./build.sh

pushd dist
python -m SimpleHTTPServer 8001
popd
