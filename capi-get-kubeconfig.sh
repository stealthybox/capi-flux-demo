clusterctl get kubeconfig \
  -n flux-system \
  child2 > child2.kubeconfig

sed -i \
  -e "s/server:.*/server: https:\/\/$(docker port child2-lb 6443/tcp | sed "s/0.0.0.0/127.0.0.1/")/g" \
  ./child2.kubeconfig
