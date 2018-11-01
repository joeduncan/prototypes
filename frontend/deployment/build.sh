#!/bin/bash -e
cd $(dirname "${BASH_SOURCE[0]}")

VERSION=$(git rev-parse HEAD)
IMAGE="boilerplate-frontend:$VERSION"

npm install --no-save
npm run build
docker build -t $IMAGE ../

./test-health.sh $IMAGE "frontend-$VERSION" 3000 /healthcheck

docker push $IMAGE