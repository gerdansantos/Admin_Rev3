#!/bin/bash

# Build the Docker images

# Build hwx/ambari_node_base first
cd ./dockerfiles/ambari_node_base
x=$(docker images | grep -c  hwx/ambari_node_base)
if [[ x -eq 0 ]]; then
	echo -e "\n*** Building hwx/ambari_node_base image... ***\n"
	docker build -t hwx/ambari_node_base .
	echo -e "\n*** Build of hwx/ambari_node_base complete! ***\n"
else
	echo -e "\n*** hwx/ambari_node_base image already built ***\n"
fi

# Build hwx/ambari_node
echo -e "\n*** Building hwx/ambari_node ***\n"
cd ../ambari_node
docker build -t hwx/ambari_node .
echo -e "\n*** Build of hwx/ambari_node complete! ***\n"

# Build hwx/ambari_server_base
# This image is probably pre-built on the VM
y=$(docker images | grep -c  hwx/ambari_server_base)
if [[ y -eq 0 ]]; then
	echo -e "\n*** Building hwx/ambari_server_base. This may take a long time!!! ***\n"
	cd ../ambari_server_base
	docker build -t hwx/ambari_server_base .
	echo -e "\n*** Build of hwx/ambari_server_base complete! ***\n"
else 
	echo -e "\n*** hwx/ambari_server_base image already built ***\n"
fi

# Build hwx/ambari_server
echo -e "\n*** Building hwx/ambari_server ***\n"
cd ../ambari_server
docker build -t hwx/ambari_server .
echo -e "\n*** Build of hwx/ambari_server complete! ***\n"

# Copy utility scripts into /root/scripts, which is already in the PATH
echo "Copying utility scripts..."
cp ../../scripts/* /root/scripts/

echo -e "\n*** The images have successfully been built for this classroom VM ***\n"
