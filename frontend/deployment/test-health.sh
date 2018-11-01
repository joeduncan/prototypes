#!/bin/bash
IMAGE=$1
NAME=$2
PORT=$3
HEALTHCHECK=$4

docker run --name $NAME -P -d $IMAGE

URL=$(docker inspect --format "http://127.0.0.1:{{ (index (index .NetworkSettings.Ports \"$PORT/tcp\") 0).HostPort }}$HEALTHCHECK" $NAME)

echo "checking if healthy: $URL..."

wget -S -q --spider --retry-connrefused --waitretry=1 --read-timeout=5 --timeout=5 --tries=60 $URL

STATUS=$?

docker logs $NAME
docker kill $NAME
docker rm $NAME

exit $STATUS
