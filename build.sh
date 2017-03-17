#/usr/bin/env bash

rm -rf dist/

elm make \
  --yes \
  --output dist/elm.js \
  src/Pomodoro.elm

cp src/static/* ./dist
