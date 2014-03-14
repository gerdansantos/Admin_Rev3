#!/bin/bash

# Build the Docker images

# Build hwx/ambari_node_base first
cd ./dockerfiles/ambari_node_base
x=$(docker images | grep -c  hwx/ambari_node_base)
if [ x -eq 0 ]; then
	echo "Building hwx/ambari_node_base image..."
	docker build -t hwx/ambari_node_base .
	echo "Build of hwx/ambari_node_base complete!"
else
	echo "hwx/ambari_node_base image already built"
fi

# Build hwx/ambari_node
echo "Building hwx/ambari_node"
cd ../ambari_node
docker build -t hwx/ambari_node .
echo "Build of hwx/ambari_node complete!"

# Build hwx/ambari_server_base
# This image is probably pre-built on the VM
y=$(docker images | grep -c  hwx/ambari_server_base)
if [ y -eq 0 ]; then
	echo "Building hwx/ambari_server_base. This may take a long time!!!"
	cd ../ambari_server_base
	docker build -t hwx/ambari_server_base .
	echo "Build of hwx/ambari_server_base complete!"
else 
	echo "hwx/ambari_server_base image already built"
fi

# Build hwx/ambari_server
echo "Building hwx/ambari_server"
cd ../ambari_server
docker build -t hwx/ambari_server .
echo "Build of hwx/ambari_server complete!"

# Copy utility scripts into /root/scripts, which is already in the PATH
echo "Copying utility scripts..."
cp ../../scripts/* /root/scripts/

echo ""
echo "The images have successfully been built for this classroom VM"
