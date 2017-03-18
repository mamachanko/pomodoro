#/usr/bin/env bash

set -ex

rm -rf dist/

elm make \
  --yes \
  --output dist/elm.js \
  src/Pomodoro.elm

cp src/static/* ./dist
