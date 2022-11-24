FROM truemark/aws-cli:ubuntu
COPY --from=truemark/git:latest /usr/local/ /usr/local/
# TODO Change to ubuntu instead of pinning distro
COPY --from=truemark/git-crypt:ubuntu-jammy /usr/local/ /usr/local/
COPY --from=truemark/node:latest /usr/local /usr/local/
RUN npm install -g aws-cdk
