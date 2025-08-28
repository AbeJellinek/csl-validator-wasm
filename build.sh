#!/bin/bash
set -e

rm -rf dist/

docker build -t csl-validator-build .
docker create --name tmp csl-validator-build
docker cp tmp:/dist/ dist/
docker rm tmp

cp csl-validator.mjs worker.mjs LICENSE* dist/
