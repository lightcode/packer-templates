#!/bin/sh

# Install package from EPEL
yum install -y epel-release
yum install --enablerepo=epel -y htop

# Cleanup log files
find /var/log -type f | while read f; do echo -ne '' > $f; done;

# remove under tmp directory
rm -rf /tmp/* /var/tmp

find /etc/sysconfig/network-scripts/ifcfg-* \
  -type f -maxdepth 0 -not -name ifcfg-lo \
  -exec sed -i -e '/^UUID/d' -e '/^HWADDR/d' {} \;
