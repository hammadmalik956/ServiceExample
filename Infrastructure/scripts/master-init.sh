#!/bin/bash

set -ex

swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

cat <<EOF |  tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF |  tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sysctl --system

# Verify that the br_netfilter, overlay modules are loaded by running the following commands:
lsmod | grep br_netfilter
lsmod | grep overlay

# Verify that the net.bridge.bridge-nf-call-iptables, net.bridge.bridge-nf-call-ip6tables, and net.ipv4.ip_forward system variables are set to 1 in your sysctl config by running the following command:
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward



curl -LO https://github.com/containerd/containerd/releases/download/v2.0.0/containerd-2.0.0-linux-amd64.tar.gz
tar Cxzvf /usr/local containerd-2.0.0-linux-amd64.tar.gz
curl -LO https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
mkdir -p /usr/local/lib/systemd/system/
mv containerd.service /usr/local/lib/systemd/system/
mkdir -p /etc/containerd
containerd config default |  tee /etc/containerd/config.toml
sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
systemctl daemon-reload
systemctl enable --now containerd

# Check that containerd service is up and running
systemctl status containerd


curl -LO https://github.com/opencontainers/runc/releases/download/v1.3.2/runc.amd64
install -m 755 runc.amd64 /usr/local/sbin/runc


curl -LO https://github.com/containernetworking/plugins/releases/download/v1.8.0/cni-plugins-linux-amd64-v1.8.0.tgz
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.8.0.tgz


apt-get update
apt-get install -y apt-transport-https ca-certificates curl gpg

mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key |  gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | \
tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubelet kubeadm kubectl

apt-mark hold kubelet kubeadm kubectl


kubeadm version
kubelet --version
kubectl version --client


crictl config runtime-endpoint unix:///var/run/containerd/containerd.sock
aws_metadata_token=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
PRIVATE_IP=`curl -H "X-aws-ec2-metadata-token: $aws_metadata_token" http://169.254.169.254/latest/meta-data/local-ipv4`
echo "My private IP is $PRIVATE_IP"

kubeadm init --pod-network-cidr=172.16.0.0/16 --apiserver-advertise-address=$PRIVATE_IP --node-name master

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.30.4/manifests/tigera-operator.yaml

while ! kubectl get crd installations.operator.tigera.io &>/dev/null; do
  echo "Waiting for Calico CRDs..."
  sleep 10
done
curl https://raw.githubusercontent.com/projectcalico/calico/v3.30.4/manifests/custom-resources.yaml -O
sed -i 's/^\(\s*cidr:\s*\).*$/\1172.16.0.0\/16/' custom-resources.yaml

kubectl apply -f custom-resources.yaml

mkdir -p /home/ubuntu/.kube
cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
chown ubuntu:ubuntu /home/ubuntu/.kube/config


#installing aws cli for getting the join command from ssm parameter
apt install -y unzip curl
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version

kubeadm token create --print-join-command > /home/ubuntu/join_command.sh

# Fetch IMDSv2 token
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Export credentials for AWS CLI to use metadata with IMDSv2
export AWS_METADATA_SERVICE_TIMEOUT=5
export AWS_METADATA_SERVICE_NUM_ATTEMPTS=3
export AWS_EC2_METADATA_TOKEN=$TOKEN

PARAM_NAME="/prod/k8s/JOIN_COMMAND"
REGION="us-east-2"  
aws ssm put-parameter \
  --name "$PARAM_NAME" \
  --type "SecureString" \
  --value "$(cat /home/ubuntu/join_command.sh)" \
  --overwrite \
  --region "$REGION"

echo "Kubeadm join command successfully pushed to SSM parameter: $PARAM_NAME"

