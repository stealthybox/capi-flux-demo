clusterctl \
  --config ~/.cluster-api/dev-repository/config.yaml \
  config cluster child2 \
  -n flux-system \
  --kubernetes-version 1.19.1 \
  -i docker:v0.3.8 \
  --worker-machine-count 1 \
