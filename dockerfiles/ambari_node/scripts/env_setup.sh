#!/bin/bash

yum -y install wget httpd ntp 
/etc/init.d/httpd start

/root/scripts/update_hostname.sh

cp ~/conf/training-keypair.pem ~/.ssh/id_rsa
chmod 700 ~/.ssh/id_rsa
scp ~/.ssh/id_rsa node2:~/.ssh
scp ~/.ssh/id_rsa node3:~/.ssh
scp ~/.ssh/id_rsa node4:~/.ssh

chkconfig ntpd on
/etc/init.d/ntpd start

ssh -o StrictHostKeyChecking=no -f root@node2 "yum -y install ntp; chkconfig ntpd on; /etc/init.d/ntpd start"
ssh -o StrictHostKeyChecking=no -f root@node3 "yum -y install ntp; chkconfig ntpd on; /etc/init.d/ntpd start"
ssh -o StrictHostKeyChecking=no -f root@node4 "yum -y install ntp; chkconfig ntpd on; /etc/init.d/ntpd start"


setenforce 0
chkconfig iptables off
/etc/init.d/iptables stop

yum -y install yum-utils createrepo

mkdir -p /var/www/html/hdp/
cd /var/www/html/hdp

echo "copying repo files to /var/www/html/hdp folder. It takes 4-6 minutes..."
cp -r /root/repo/* .

createrepo /var/www/html/hdp/HDP-2.x
createrepo /var/www/html/hdp/HDP-2.0.6.0-76
createrepo /var/www/html/hdp/HDP-UTILS-1.1.0.16
createrepo /var/www/html/hdp/ambari-1.x
createrepo /var/www/html/hdp/Updates-ambari-1.4.1.25

cp ~/conf/*.repo /etc/yum.repos.d/
~/scripts/distFile.sh /etc/yum.repos.d/hdp.repo /etc/yum.repos.d
~/scripts/distFile.sh /etc/yum.repos.d/ambari.repo /etc/yum.repos.d

yum -y install yum-priorities
ssh -o StrictHostKeyChecking=no -f root@node2 yum -y install yum-priorities
ssh -o StrictHostKeyChecking=no -f root@node3 yum -y install yum-priorities
ssh -o StrictHostKeyChecking=no -f root@node4 yum -y install yum-priorities

echo "[main]" > /etc/yum/pluginconf.d/priorities.conf
echo "enabled=1" >> /etc/yum/pluginconf.d/priorities.conf
echo "gpgcheck=0" >> /etc/yum/pluginconf.d/priorities.conf
/root/scripts/distFile.sh /etc/yum/pluginconf.d/priorities.conf /etc/yum/pluginconf.d

#yum -y install ambari-server
#cp ~/conf/repoinfo.xml /var/lib/ambari-server/resources/stacks/HDPLocal/2.0.6/repos

#ambari-server setup -s
#ambari-server start
