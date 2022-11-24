FROM truemark/aws-cli:latest
COPY --from=truemark/git:latest /usr/local/ /usr/local/
COPY --from=truemark/git-crypt:amazonlinux /usr/local/ /usr/local/
COPY --from=truemark/node:latest /usr/local /usr/local/
RUN npm install -g aws-cdk
