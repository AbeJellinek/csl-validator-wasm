#!/bin/bash
set -e

./build.sh
cp package.json dist/
npm publish dist/
