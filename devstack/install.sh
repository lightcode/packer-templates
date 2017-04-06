#!/bin/sh

#########################################################
# Install packages from EPEL
#########################################################

yum install -y epel-release
yum install --enablerepo=epel -y htop the_silver_searcher

useradd -s /bin/bash -d /opt/stack -m stack

echo "stack ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers


#########################################################
# Clean image
#########################################################

find /etc/sysconfig/network-scripts/ifcfg-* \
  -maxdepth 0 -type f -not -name ifcfg-lo \
  -exec sed -i -e '/^UUID/d' -e '/^HWADDR/d' {} \;

# Blank all log files
find /var/log -type f | while read f; do echo -n '' > $f; done

rm -rf /tmp/* /var/tmp/*
yum clean all

# Clear swap
swap="/dev/centos/swap"
swapoff "${swap}"
dd if=/dev/zero of="${swap}" bs=1M
mkswap "${swap}"

# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync
