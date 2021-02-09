#!/bin/bash
unset CD_PATH
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${SCRIPT_DIR}" || exit 1

$CLUSTER_NAME="capi"

KIND_EXPERIMENTAL_DOCKER_NETWORK="bridge" \
  kind create cluster \
  --name ${CLUSTER_NAME} \
  --config "./capi-mgmt.yaml"

  # replace_loopback:
sed -i "s/127.0.0.1.*/$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${CLUSTER_NAME}-control-plane):6443/" ~/.kube/config 
