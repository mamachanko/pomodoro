#/usr/bin/env bash

set -ex

git pull --rebase

./test.sh

./build.sh

git push

./deploy.sh
