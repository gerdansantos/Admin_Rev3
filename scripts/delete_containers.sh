docker ps -a | awk '{print $1}' | grep -v CONTAINER | xargs docker rm -f
