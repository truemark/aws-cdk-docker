# AWS CDK Docker Image

This project aims to create a docker image to simplify running AWS CDK. The image
created is based on the truemark/aws-cli docker image to support OIDC authentication
and STS role changing. See https://github.com/truemark/aws-cli-docker.

## What images are available?

- Amazon Linux
  - public.ecr.aws/truemark/aws-cdk:latest
  - public.ecr.aws/truemark/aws-cdk:amazonlinux (same as latest)
  - public.ecr.aws/truemark/aws-cdk:go
  - public.ecr.aws/truemark/aws-cdk:dotnet8
  - public.ecr.aws/truemark/aws-cdk:dotnet8-jre-21
  - public.ecr.aws/truemark/aws-cdk:dotnet7
  - public.ecr.aws/truemark/aws-cdk:dotnet7-jre-17
  - public.ecr.aws/truemark/aws-cdk:dotnet6
  - public.ecr.aws/truemark/aws-cdk:dotnet6-jre-17
- Ubuntu
  - public.ecr.aws/truemark/aws-cdk:ubuntu
  - public.ecr.aws/truemark/aws-cdk:ubuntu-go
  - public.ecr.aws/truemark/aws-cdk:ubuntu-dotnet8
  - public.ecr.aws/truemark/aws-cdk:ubuntu-dotnet8-jre-21
  - public.ecr.aws/truemark/aws-cdk:ubuntu-dotnet7
  - public.ecr.aws/truemark/aws-cdk:ubuntu-dotnet7-jre-17
  - public.ecr.aws/truemark/aws-cdk:ubuntu-dotnet6
  - public.ecr.aws/truemark/aws-cdk:ubuntu-dotnet6-jre-17
- Alpine
  - public.ecr.aws/truemark/aws-cdk:alpine
  - public.ecr.aws/truemark/aws-cdk:alpine-go
  - public.ecr.aws/truemark/aws-cdk:alpine-dotnet8
  - public.ecr.aws/truemark/aws-cdk:alpine-dotnet7
  - public.ecr.aws/truemark/aws-cdk:alpine-dotnet6

*Notes:* 
 - To use these same images from DockerHub, just remove the *public.ecr/* from the image name.
 - These images are meant to be build and deploy images and are not meant to be use a runtime images for a service.

The following images exist in the repository, but are no longer maintained or built:

 - Amazon Linux
   - public.ecr.aws/truemark/aws-cdk:dotnetcore31
   - public.ecr.aws/truemark/aws-cdk:dotnetcore31-jre-17
   - public.ecr.aws/truemark/aws-cdk:dotnet5
   - public.ecr.aws/truemark/aws-cdk:dotnet5-jre-17

## How do I use this image in BitBucket pipelines?

The following is an example pipeline that executed CDK using this docker image.

```yml
definitions:
  exports: &exports >-
    export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}"
    AWS_OIDC_ROLE_ARN="arn:aws:iam::XXXXXXXXXXXX:role/bitbucket-provisioner"
    AWS_WEB_IDENTITY_TOKEN="${BITBUCKET_STEP_OIDC_TOKEN}"
    AWS_ROLE_SESSION_NAME="XXX"
    AWS_ASSUME_ROLE_ARN="arn:aws:iam::${AWS_ACCOUNT_ID}:role/ServiceAutomation"
    GIT_CRYPT_KEY="${GIT_CRYPT_KEY}"
  steps:
    - step: &diff
        name: Diff
        image: truemark/aws-cdk:latest
        oidc: true
        caches:
          - node
        script:
          - *exports
          - initialize
          - cdk diff
    - step: &deploy
        name: Deploy
        image: truemark/aws-cdk:latest
        oidc: true
        trigger: manual
        caches:
          - node
        script:
          - *exports
          - initialize
          - cdk deploy
pipelines:
  branches:
    develop:
      - step:
          <<: *diff
          name: Diff Dev
          deployment: dev-diff
      - step:
          <<: *deploy
          name: Deploy Dev
          deployment: dev
    main:
      - step:
          <<: *diff
          name: Diff Prod
          deployment: prod-diff
      - step:
          <<: *deploy
          name: Deploy Prod
          deployment: prod
```

## Maintainers

 - [erikrj](https://github.com/erikrj)

## License

The contents of this repository are under the BSD 3-Clause license. See the
license [here](https://github.com/truemark/aws-cdk-docker/blob/main/LICENSE.txt).


