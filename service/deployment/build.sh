#!/bin/bash -e
cd $(dirname "${BASH_SOURCE[0]}")

VERSION=$(git rev-parse HEAD)
IMAGE="prototype-service:$VERSION"

npm install --no-save
docker build -t $IMAGE ../

./test-health.sh $IMAGE 3000 /healthcheck

docker push $IMAGE

