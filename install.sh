#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

echo "================ Installing locales ======================="
apt-get clean && apt-get update
apt-get install -q locales=2.23*

dpkg-divert --local --rename --add /sbin/initctl
locale-gen en_US en_US.UTF-8
dpkg-reconfigure locales

echo "HOME=$HOME"
cd /u16

echo "================= Updating package lists ==================="
apt-get update

echo "================= Adding some global settings ==================="
mv gbl_env.sh /etc/profile.d/
mkdir -p "$HOME/.ssh/"
mv config "$HOME/.ssh/"
mv 90forceyes /etc/apt/apt.conf.d/
touch "$HOME/.ssh/known_hosts"
mkdir -p /etc/drydock

echo "================= Installing basic packages ==================="
apt-get install -y \
  build-essential=12.1* \
  curl=7.47* \
  gcc=4:5.3* \
  gettext=0.19* \
  htop=2.0* \
  libxml2-dev=2.9* \
  libxslt1-dev=1.1* \
  make=4.1* \
  nano=2.5* \
  openssh-client=1:7* \
  openssl=1.0* \
  software-properties-common=0.96* \
  sudo=1.8**  \
  texinfo=6.1* \
  zip=3.0* \
  unzip=6.0* \
  wget=1.17* \
  rsync=3.1* \
  psmisc=22.21* \
  netcat-openbsd=1.105* \
  vim=2:7.4* \
  groff=1.22.*

echo "================= Installing Python packages ==================="
apt-get install -q -y \
  python-pip=8.1* \
  python-software-properties=0.96* \
  python-dev=2.7*

pip install -q virtualenv==16.0.0
pip install -q pyOpenSSL==18.0.0

echo "================= Installing Git ==================="
add-apt-repository ppa:git-core/ppa -y
apt-get update
apt-get install -q -y git=1:2.*

echo "================= Installing Git LFS ==================="
curl -sS https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get install -q git-lfs=2.5.1

echo "================= Adding JQ 1.5x ==================="
apt-get install -q jq=1.5*

echo "================= Installing Node 8.x ==================="
. /u16/node/install.sh

echo "================= Installing Java 10.0.2 ==================="
. /u16/java/install.sh

echo "================= Installing Ruby 2.5.1  ==================="
. /u16/ruby/install.sh


echo "================= Adding gcloud ============"
CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list
curl -sS https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sudo apt-get update && sudo apt-get install -q google-cloud-sdk=211.0*

KUBECTL_VERSION=1.11.0
echo "================= Adding kubectl $KUBECTL_VERSION ==================="
curl -sSLO https://storage.googleapis.com/kubernetes-release/release/v"$KUBECTL_VERSION"/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

KOPS_VERSION=1.9.2
echo "Installing KOPS version: $KOPS_VERSION"
curl -LO https://github.com/kubernetes/kops/releases/download/"$KOPS_VERSION"/kops-linux-amd64
chmod +x kops-linux-amd64
mv kops-linux-amd64 /usr/local/bin/kops

HELM_VERSION=v2.9.1
echo "Installing helm version: $HELM_VERSION"
wget https://storage.googleapis.com/kubernetes-helm/helm-"$HELM_VERSION"-linux-amd64.tar.gz
tar -zxvf helm-"$HELM_VERSION"-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm
rm -rf linux-amd64

echo "================= Adding apache libcloud 2.3.0 ============"
sudo pip install 'apache-libcloud==2.3.0'

echo "================= Adding awscli 1.15.73 ============"
sudo pip install -q 'awscli==1.15.73'

echo "================= Adding awsebcli 3.14.3 ============"
sudo pip install -q 'awsebcli==3.14.3'

echo "================= Adding openstack client 3.16.0 ============"
sudo pip install 'python-openstackclient==3.16.0'
sudo pip install 'shade==1.29.0'

AZURE_CLI_VERSION=2.0*
echo "================ Adding azure-cli $AZURE_CLI_VERSION =============="
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | \
sudo tee /etc/apt/sources.list.d/azure-cli.list
curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo apt-get install -q apt-transport-https=1.2*
sudo apt-get update && sudo apt-get install -y -q azure-cli=$AZURE_CLI_VERSION

echo "================= Adding doctl 1.8.3 ============"
curl -OL https://github.com/digitalocean/doctl/releases/download/v1.8.3/doctl-1.8.3-linux-amd64.tar.gz
tar xf doctl-1.8.3-linux-amd64.tar.gz
sudo mv ~/doctl /usr/local/bin
rm doctl-1.8.3-linux-amd64.tar.gz

JFROG_VERSION=1.18.0
echo "================= Adding jfrog-cli $JFROG_VERSION  ==================="
wget -nv https://api.bintray.com/content/jfrog/jfrog-cli-go/"$JFROG_VERSION"/jfrog-cli-linux-amd64/jfrog?bt_package=jfrog-cli-linux-amd64 -O jfrog
sudo chmod +x jfrog
mv jfrog /usr/bin/jfrog

echo "================ Adding ansible 2.6.2 ===================="
sudo pip install -q 'ansible==2.6.2'

echo "================ Adding boto 2.49.0 ======================="
sudo pip install -q 'boto==2.49.0'

echo "================ Adding boto3 ======================="
sudo pip install -q 'boto3==1.7.72'

echo "================ Adding apache-libcloud 2.3.0 ======================="
sudo pip install -q 'apache-libcloud==2.3.0'

echo "================ Adding azure 3.0.0 ======================="
sudo pip install -q 'azure==3.0.0'

echo "================ Adding dopy 0.3.7 ======================="
sudo pip install -q 'dopy==0.3.7'

export TF_VERSION=0.11.7
echo "================ Adding terraform- $TF_VERSION  ===================="
export TF_FILE=terraform_"$TF_VERSION"_linux_amd64.zip

echo "Fetching terraform"
echo "-----------------------------------"
rm -rf /tmp/terraform
mkdir -p /tmp/terraform
wget -nv https://releases.hashicorp.com/terraform/$TF_VERSION/$TF_FILE
unzip -o $TF_FILE -d /tmp/terraform
sudo chmod +x /tmp/terraform/terraform
mv /tmp/terraform/terraform /usr/bin/terraform

echo "Added terraform successfully"
echo "-----------------------------------"

export PK_VERSION=1.2.5
echo "================ Adding packer $PK_VERSION  ===================="
export PK_FILE=packer_"$PK_VERSION"_linux_amd64.zip

echo "Fetching packer"
echo "-----------------------------------"
rm -rf /tmp/packer
mkdir -p /tmp/packer
wget -nv https://releases.hashicorp.com/packer/$PK_VERSION/$PK_FILE
unzip -o $PK_FILE -d /tmp/packer
sudo chmod +x /tmp/packer/packer
mv /tmp/packer/packer /usr/bin/packer

echo "Added packer successfully"
echo "-----------------------------------"

echo "================= Intalling Shippable CLIs ================="

git clone https://github.com/Shippable/node.git nodeRepo
./nodeRepo/shipctl/x86_64/Ubuntu_16.04/install.sh
rm -rf nodeRepo

echo "Installed Shippable CLIs successfully"
echo "-------------------------------------"

echo "================= Cleaning package lists ==================="
apt-get clean
apt-get autoclean
apt-get autoremove
