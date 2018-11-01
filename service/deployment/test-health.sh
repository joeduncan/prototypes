#!/bin/bash

IMAGE=$1
PORT=$2
HEALTHCHECK=$3
NAME=$(uuidgen)
MONGO="mongo-$NAME"

docker run --name $MONGO -P -d mongo
docker run --link $MONGO -e MONGO_HOST="mongodb://$MONGO:27017" -e MONGO_DB_NAME="testdb" --name $NAME -P -d $IMAGE

URL=$(docker inspect --format "http://127.0.0.1:{{ (index (index .NetworkSettings.Ports \"$PORT/tcp\") 0).HostPort }}$HEALTHCHECK" $NAME)

echo "checking if service is healthy: $URL..."

wget -S -q --spider --retry-connrefused --waitretry=1 --read-timeout=1 --timeout=1 --tries=3 $URL

STATUS=$?

docker logs $NAME
docker kill $NAME
docker rm $NAME
docker kill $MONGO
docker rm $MONGO

exit $STATUS
