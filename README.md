# AWS CDK Docker Image

This project aims to create a docker image to simplify running AWS CDK. The image
created is based on the truemark/aws-cli docker image to support OIDC authentication
and STS role changing. See https://github.com/truemark/aws-cli-docker.

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
