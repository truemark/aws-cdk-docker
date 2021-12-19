#!/usr/bin/env bash
docker build --platform linux/amd64 -t truemark/aws-cdk:beta .
docker build --platform linux/amd64 --build-arg SOURCE_IMAGE=truemark/aws-cdk:beta -t truemark/aws-cdk-pipe:beta -f pipe.Dockerfile .
#docker run -it --rm \
#  -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
#  -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
#  -e "AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN}" \
#  -e 'AWS_ASSUME_ROLE_ARN=arn:aws:iam::${AWS_ACCOUNT_ID}:role/OrganizationAccountAccessRole' \
#  -e "AWS_ROLE_SESSION_NAME=erik" \
#  -e "COMMAND=aws sts get-caller-identity --query 'Account' --output text" \
#  -e "DEBUG=true" \
#  truemark/aws-cdk-pipe:beta
docker push truemark/aws-cdk:beta
docker push truemark/aws-cdk-pipe:beta
