#/usr/bin/env bash

# This script is only intended to be used for local development on this project.
# It depends on a buildx node called "beta. You can create such an environment
# by executing "docker buildx create --name beta"

set -euo pipefail

#docker buildx build \
#  --builder beta \
#  --push \
#  --platform linux/arm64,linux/amd64 \
#  -t truemark/aws-cdk:beta .

docker build -t moo --build-arg NODE_VERSION=18 -f alpine.Dockerfile --target dotnet6-jre-17 .
#docker build -t moo --build-arg NODE_VERSION=18 -f ubuntu.Dockerfile --target dotnet6-jre-17 .
#docker build -t moo --build-arg NODE_VERSION=18 -f amazonlinux.Dockerfile --target dotnet6-jre-17 .
