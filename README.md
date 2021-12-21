# AWS CDK Docker Image

This project aims to create a docker image to simplify running AWS CDK.

## How do I use this image?

To include git and git-crypt from this image into your docker image, insert
the following code into your Dockerfile.

```
COPY --from=truemark/git:amazonlinux-2 /usr/local/ /usr/local/
```

Replace the "amazonlinux-2" part of the tag with the distribution that best
matches the base docker image you are using. If there isn't a distribution
that works for your use case, submit an Issue requesting it to
https://github.com/truemark/git-docker/issues.

## Maintainers

 - [erikrj](https://github.com/erikrj)

## License

The contents of this repository are under the BSD 3-Clause license. See the
license [here](https://github.com/truemark/aws-cdk-docker/blob/main/LICENSE.txt).


