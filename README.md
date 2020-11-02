# capi-flux-demo

This demo shows signed-commit verification via GPG, as well as
apply's of 2 Kustomizations to a CAPD (Cluster API Provider Docker) Cluster created and managed from this same repo.

GPG verification and remote cluster applies are features of the
Flux 2 API. Check out the project here: https://fluxcd.io/

This repo is the result of a wild live-demo with many
folks from the Flux community.

It took an hour, but we finally got it working!

Commit history is signed and preserved for comedic effect!


## Pre-requisites

- Your computer
- These tools:
  - git
  - hub (optional)
  - gpg
  - flux
  - docker
  - kind
  - kubectl
  - clusterctl


## Forking

```shell
hub clone stealthybox/capi-flux-demo
cd capi-flux-demo
hub fork
```
Alternatively, fork in the web UI and clone.


## Key Verification

The most recent commit is signed by stealthybox's public key.
It's available in the [Secret provisioned by this repo](./config/capi-mgmt/flux-system/admin-public-gpg.yaml).

If you want to restrict the cluster to only apply commits
verified by this public key-list, **un-comment the verify section** in the [gotk-sync.yaml](./config/capi-mgmt/flux-system/gotk-sync.yaml).

Add your key there to continue committing with your own signed
commits :)


## Trying it out:

Provision the CAPI mgmt kind cluster:
```shell
kind/create.sh
clusterctl init --infrastructure docker
```

Bootstrap your fork to the cluster /w Flux:
```shell
GITHUB_USER=stealthybox
# set your own user here

export GITHUB_TOKEN="<personal access token with repo and SSH key rights>"

flux bootstrap github \
  --owner "${GITHUB_USER}" \
  --repository "capi-flux-demo" \
  --path "./config/capi-mgmt"
```

ClusterAPI should be setup with you computer's default Docker socket.

The repo will bootstrap with new SSH keys hooked up to your fork.

Check that the gitrepository has fetched and properly verified
the commit signature if you enabled it for the gotk-sync GitRepository.
```shell
kubectl get gitrepository -A
kubectl get kustomization -A
```


## Flux + Cluster API

If you're docker cluster API provider is working, a cluster called "child2" should already be creating or be created by now.
Bootstrapping this repo created the Cluster objects in our initial
capi mgmt cluster.

This repo uses Flux's Kustomization API to sync the
`./config/child2` directory to the child cluster to provision the
kindnet network.  
An additional GitRepository + Kustomization installs
[podinfo](https://github.com/stefanprodan/podinfo) to the `dev` namespace.

```shell
# mgmt cluster objects
kubectl get gitrepository -A
kubectl get kustomization -A
kubectl get cluster -A

./capi-get-kubeconfig.sh

# list the sync'd workloads in the child cluster
kubectl get po -A --kubeconfig child2.kubeconfig
```

This is possible because Cluster API produces a self-contained
kubeconfig file in a deterministic Secret for Clusters that it
provisions.

This Secret shows up in the same namespace as our Kustomization
(flux-system), because our Cluster is also declared there.


## Other notes

If you make more commits and want to poke the reconciler, run:
```
flux reconcile source git flux-system
```


## Cleaning up:

```shell
kind delete cluster --name capi
```
