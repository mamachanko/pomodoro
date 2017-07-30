#/usr/bin/env bash

set -ex

cd build
python -m SimpleHTTPServer 1234 &> /dev/null &
SERVER_PID=$!
cd ..

cd feature-tests
TEST_URL="localhost:1234" ./gradlew clean build
cd ..

kill "${SERVER_PID}"
