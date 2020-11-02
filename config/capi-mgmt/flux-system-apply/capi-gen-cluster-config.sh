clusterctl \
  --config ~/.cluster-api/dev-repository/config.yaml \
  config cluster child2 \
  --kubernetes-version 1.19.1 \
  -i docker:v0.3.8 \
  -n flux-system
