#!/bin/bash

export node1_ip=`head -1 /root/conf/hosts`
export node2_ip=`sed -n '2p' /root/conf/hosts`
export node3_ip=`sed -n '3p' /root/conf/hosts`
export node4_ip=`sed -n '4p' /root/conf/hosts`

export CONF=/root/conf

function update_host {

if [[ $node1_ip == '' ]] ; then
        echo "it is an AMI instance. Quitting."
        exit 123
else
		
	echo "================================"
	echo -e "Modifying HOSTS file for /etc/hosts on NODE1: \n\n"
	echo "================================"

	sed -i "s/NODE1/$node1_ip/g" $CONF/etc_hosts
	sed -i "s/NODE2/$node2_ip/g" $CONF/etc_hosts
	sed -i "s/NODE3/$node3_ip/g" $CONF/etc_hosts
	sed -i "s/NODE4/$node4_ip/g" $CONF/etc_hosts


	echo -e "Replacing existing /etc/hosts file... \n\n"
	mv /etc/hosts $CONF/etc_hosts_bkp
	cp $CONF/etc_hosts /etc/hosts

	cp $CONF/etc_hosts_template $CONF/etc_hosts


	echo "================================"
	echo -e "Modifying Hostname on NODE1: \n\n"
	echo "================================"

	sed -i "s/localhost.localdomain/node1/g" /etc/sysconfig/network
	hostname node1

	/root/scripts/known_hosts.sh 
	/root/scripts/distFile.sh /etc/hosts /etc
#	rm -rf /.ssh/known_hosts

	/root/scripts/distFile.sh ~/.ssh/known_hosts ~/.ssh

	ssh -i ~/conf/training-keypair.pem -o StrictHostKeyChecking=no -f root@node2 hostname node2
	ssh -i ~/conf/training-keypair.pem -o StrictHostKeyChecking=no -f root@node2 sed -i "s/localhost.localdomain/node2/g" /etc/sysconfig/network
	
	ssh -i ~/conf/training-keypair.pem -o StrictHostKeyChecking=no -f root@node3 hostname node3
	ssh -i ~/conf/training-keypair.pem -o StrictHostKeyChecking=no -f root@node3 sed -i "s/localhost.localdomain/node3/g" /etc/sysconfig/network
	
	ssh -i ~/conf/training-keypair.pem -o StrictHostKeyChecking=no -f root@node4 hostname node4
	ssh -i ~/conf/training-keypair.pem -o StrictHostKeyChecking=no -f root@node4 sed -i "s/localhost.localdomain/node4/g" /etc/sysconfig/network

fi
}

update_host


