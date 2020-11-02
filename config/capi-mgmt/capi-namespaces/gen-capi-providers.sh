#!/bin/bash
unset CD_PATH
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${SCRIPT_DIR}" || exit 1

for fl in --core=cluster-api --bootstrap=kubeadm --control-plane=kubeadm --infrastructure=docker; do
    fname="$(echo $fl | tr -d '-' | tr '=' '_').yaml";
    echo "---" > "$fname"
    clusterctl config provider $fl -oyaml >> "$fname"
done
