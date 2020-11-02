#!/bin/bash
unset CD_PATH
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${SCRIPT_DIR}" || exit 1

KIND_EXPERIMENTAL_DOCKER_NETWORK="bridge" \
  kind create cluster \
  --name "capi" \
  --config "./capi-mgmt.yaml"
