clusterctl get kubeconfig \
  -n gotk-system \
  child > child.kubeconfig

sed -i \
  -e "s/server:.*/server: https:\/\/$(docker port child-lb 6443/tcp | sed "s/0.0.0.0/127.0.0.1/")/g" \
  ./child.kubeconfig
