FROM truemark/aws-cli:ubuntu-jammy
COPY --from=truemark/git:ubuntu-jammy /usr/local/ /usr/local/
COPY --from=truemark/git-crypt:ubuntu-jammy /usr/local/ /usr/local/
COPY --from=truemark/node:18-ubuntu-jammy /usr/local /usr/local/
RUN npm install -g typescript aws-cdk pnpm yarn esbuild && \
    npm config set fund false --location=global
