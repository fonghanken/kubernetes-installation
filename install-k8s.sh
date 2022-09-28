docker run -it --rm --privileged roboxes/rhel8:latest bash
docker run -it --rm --privileged roboxes/centos8:latest bash


VERSION=1.24
curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/CentOS_8/devel:kubic:libcontainers:stable.repo
curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/CentOS_8/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo

dnf -y install 'dnf-command(copr)'
dnf -y copr enable rhcontainerbot/container-selinux

cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

CRIO_DIR=~/packages/cri-o
mkdir -p $CRIO_DIR
dnf install cri-o --downloadonly --downloaddir $CRIO_DIR

K8S_VER=1.24.2
K8S_DIR=~/packages/kubernetes
mkdir -p $K8S_DIR
dnf install kubeadm-$K8S_VER kubectl-$K8S_VER kubelet-$K8S_VER cri-tools-$K8S_VER --downloadonly --disableexcludes=kubernetes --downloaddir $K8S_DIR