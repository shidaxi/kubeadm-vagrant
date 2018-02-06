#!/bin/sh

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
setenforce 0
yum install -y net-tools bind-utils screen tree telnet kubelet kubeadm docker --nogpgcheck
systemctl enable kubelet && systemctl start kubelet
systemctl enable docker && systemctl start docker

setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=enforcing/g' /etc/selinux/config
swapoff -a
sed -i '/swap/s/^/#/g' /etc/fstab
sed -i '/search/d' /etc/resolv.conf

echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
