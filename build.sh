#/usr/bin/env bash

rm -rf dist/

elm make \
  --yes \
  --output dist/index.html \
  src/Main.elm
