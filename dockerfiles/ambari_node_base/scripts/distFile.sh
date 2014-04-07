#!/bin/sh
#
# Description: This script is mean to distribute the file to all the nodes from gateway machine.
# 
# Usage      : distFile.sh <file> <destination_directory>
# 
#

export src_file=$1
export dest_dir=$2
export node_file="/root/conf/nodes"

##########################################
#		            Functions
##########################################

function distributeFile {
   for cur_node in `grep -v $HOSTNAME ${node_file}`
   do
     echo "-------------------------------------"
     echo "On node ${cur_node}....."
     echo 
     scp -i ~/conf/training-keypair.pem ${src_file} root@${cur_node}:${dest_dir}

   done
}


##########################################
#		            MAIN
##########################################

distributeFile

echo "Distributed ${src_file} to all nodes. Placed in ${dest_dir}!!"
