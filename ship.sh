#/usr/bin/env bash

set -ex

git pull --rebase

./test.sh

git push

./deploy.sh
