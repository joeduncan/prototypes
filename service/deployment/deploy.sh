#!/bin/bash -e
cd $(dirname "${BASH_SOURCE[0]}")

VERSION=$(git rev-parse HEAD)
IMAGE="boilerplate-service:$VERSION"

echo "Deploying service ($IMAGE)"

# deploy with kubectl etc