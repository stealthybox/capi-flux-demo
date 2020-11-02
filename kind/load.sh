#!/bin/bash

# Convenience script for pre-loading images for the mgmt cluster

unset CD_PATH
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${SCRIPT_DIR}" || exit 1

config-build () {
  for f in $(find "../config/$1" -type f -path "*.yaml"); do
    cat $f
  done
}

parse-images() {
  grep 'image:' | sed 's/^[ -]*image:[ ]*//g' | sort -u
}

pull-then-load() {
  img=$1
  cl=$2
  docker image pull --quiet "$img"
  kind load docker-image "$img" --name "$cl"
}

cl="capi"
folder="capi-mgmt"
for img in $(config-build "$folder" | parse-images); do
  pull-then-load "$img" "$cl" &
done
wait

echo
echo "  Loaded images for $cl"
echo
