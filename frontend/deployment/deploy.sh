#!/bin/bash -e
cd $(dirname "${BASH_SOURCE[0]}")

VERSION=$(git rev-parse HEAD)

# deploy via kubectl etc