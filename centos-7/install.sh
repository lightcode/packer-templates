#!/bin/sh

#########################################################
# Install packages from EPEL
#########################################################

yum install -y epel-release
yum install --enablerepo=epel -y htop


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

# Zero out the rest of the free space using dd, then delete the written file.
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Clear swap
swap="/dev/centos/swap"
swapoff "${swap}"
dd if=/dev/zero of="${swap}" bs=1M
mkswap "${swap}"

# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync
