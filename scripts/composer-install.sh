#!/usr/bin/env bash

# exit on error
set -eu

# must be run inside the project. this is a hack for codeship
if [ ! -z ${1+x} ]; then
  cd $1
fi

composer install