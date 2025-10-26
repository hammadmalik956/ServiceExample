# TASK 4 Kubernetes Cluster & GitOps
Set up a self-managed Kubernetes cluster (e.g., using kubeadm).

Configure GitOps (e.g., preferably FluxCD, ArgoCD or similar is also OK).

Deploy a storage solution of your choice (e.g., Longhorn or Ceph Rook).

Deploy an observability stack of your choice (e.g., Prometheus, Loki, Grafana)

Deploy the application to the cluster via GitOps using the published Helm chart.

Automatically deploy the application whenever a new version is released.


## Set up a self-managed Kubernetes cluster (e.g., using kubeadm).

<img width="1850" height="239" alt="image" src="./images/k8s-selfhosted.png" />

## Github Actions Pipeline to deploy k8s on AWS

<img width="1866" height="946" alt="image" src="./images/k8s-self-ci.png" />

## 

<img width="1866" height="946" alt="image" src="./images/k8s-selfhosted.png" />

## Deploy a storage solution of your choice (e.g., Longhorn ).

<img width="1771" height="463" alt="image" src="./images/longhorn.png" />

##

<img width="1771" height="463" alt="image" src="./images/longhorn-dash.png" />

##

## Deploy an observability stack of your choice (e.g., Prometheus, Loki, Grafana)

<img width="1771" height="463" alt="image" src="./images/k8s-monitoring.png" />

##
##

<img width="1771" height="463" alt="image" src="./images/grafana-dashboards.png" />

##

<img width="1603" height="654" alt="image" src="./images/flux.png" />

##
##

## Prometheus


<img width="1813" height="999" alt="image" src="./images/prometheus.png" />

## Accessing the Application from K8s using URL: http://${nodeIp}:${nodeport}/swagger/index.html

## Application is secured in private subnets and VPN must be connected to access the application

<img width="1775" height="1009" alt="image" src="./images/vpn-app.png" />


