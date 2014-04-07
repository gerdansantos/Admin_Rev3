#!/bin/bash

chkconfig sshd on 
chkconfig ntpd on

/etc/init.d/sshd start
/etc/init.d/ntpd start

setenforce 0
chkconfig iptables off
/etc/init.d/iptables stop

# Setup the hosts file and start DNS
service dnsmasq restart

export datanode_ip=$(ip addr | grep inet | grep eth0 | awk -F" " '{print $2}' | sed -e 's/\/.*$//')

grep -v rootfs /proc/mounts > /etc/mtab
umask 022

bash
