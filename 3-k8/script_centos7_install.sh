sudo yum -y update

sudo yum -y install epel-release

sudo yum -y install git libvirt qemu-kvm virt-install virt-top libguestfs-tools bridge-utils

sudo yum install socat -y

sudo yum install -y conntrack

sudo curl -fsSL https://get.docker.com -o get-docker.sh

sudo sh get-docker.sh

sudo usermod -aG docker centos

suudo systemctl start docker

sudo yum -y install wget

sudo wget
