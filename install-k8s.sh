docker run -it --rm --privileged roboxes/rhel8:latest bash
docker run -it --rm --privileged roboxes/centos8:latest bash


export VERSION=1.24
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

export CRIO_DIR=~/packages/cri-o
mkdir -p $CRIO_DIR
dnf install cri-o --downloadonly --downloaddir $CRIO_DIR

export KUBECTL_DIR=~/packages/kubectl
mkdir -p $KUBECTL_DIR
dnf install kubectl-$VERSION* --downloadonly --disableexcludes=kubernetes --downloaddir $KUBECTL_DIR

export KUBEADM_DR=~/packages/kubeadm
mkdir -p $KUBEADM_DR
dnf install kubeadm-$VERSION* --downloadonly --disableexcludes=kubernetes --downloaddir $KUBEADM_DR

export KUBELET_DIR=~/packages/kubelet
mkdir -p $KUBELET_DIR
dnf install kubelet-$VERSION* --downloadonly --disableexcludes=kubernetes --downloaddir $KUBELET_DIR