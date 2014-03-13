#!/bin/bash

# Build the Docker images

# Build hwx/ambari_node_base first
echo "Building hwx/ambari_node_base image..."
cd ./dockerfiles/ambari_node_base
docker build -t hwx/ambari_node_base .
echo "Build of hwx/ambari_node_base complete!"

# Build hwx/ambari_node
echo "Building hwx/ambari_node"
cd ../ambari_node
docker build -t hwx/ambari_node .
echo "Build of hwx/ambari_node complete!"

# Build hwx/ambari_server_base
echo "Building hwx/ambari_server_base. This may take a long time!!!"
cd ../ambari_server_base
docker build -t hwx/ambari_server_base .
echo "Build of hwx/ambari_server_base complete!"

# Build hwx/ambari_server
echo "Building hwx/ambari_server"
cd ../ambari_server
docker build -t hwx/ambari_server .
echo "Build of hwx/ambari_server complete!"

echo ""
echo "The images have successfully been built for this classroom VM"
