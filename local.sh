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

docker build -t moo -f alpine.Dockerfile --target dotnet6-jre-17 .
docker build -t moo -f ubuntu.Dockerfile --target dotnet6-jre-17 .
docker build -t moo -f amazonlinux.Dockerfile --target dotnet6-jre-17 .
