#!/bin/sh

#export hosts="/root/conf/hosts"
export nodes="/root/conf/nodes"
export src_file=$1
export dest_dir=$2


##########################################
#               Functions
##########################################

function known_host {

        for cur_node in `cat ${nodes}`; do
                        echo "============="
                        echo "Adding $cur_node to known host list"
                        echo "============="
                        ssh -i ~/conf/training-keypair.pem -o StrictHostKeyChecking=no root@$cur_node /etc/init.d/iptables stop 2>&1 >> /dev/null

                        RETURN_CODE=$?
                        echo "Return code of ssh is $RETURN_CODE"

                        attempts=2
                        while [[ $attempts -le 6 &&  "$RETURN_CODE" -ne 0 ]] ; do
                                echo "Retrying to login to EC2: Attempt $attempts "
                                ssh -i ~/conf/training-keypair.pem -o StrictHostKeyChecking=no root@$cur_node /etc/init.d/iptables stop 2>&1 >> /dev/null
                                RETURN_CODE=$?
                                echo "RETURN_CODE=$RETURN_CODE"
                                sleep 20
                                (( attempts = $attempts + 1 ))
                        done

                        if [[ "$RETURN_CODE" -ne 0 ]] ; then
                                echo "FATAL: Failed to login to EC2. Exiting"
                                exit 123
                        fi
        done
}

known_host
