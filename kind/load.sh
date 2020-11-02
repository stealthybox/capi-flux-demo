#!/bin/bash
unset CD_PATH
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${SCRIPT_DIR}" || exit 1

for img in $(cat ../config/capi-mgmt/capi-namespaces/*.yaml | grep image: | awk '{print $2}' | sort -u); do
  kind load docker-image $img
done