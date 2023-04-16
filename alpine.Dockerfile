FROM truemark/aws-cli:alpine-3.17
COPY --from=truemark/git:alpine-3.17 /usr/local/ /usr/local/
COPY --from=truemark/git-crypt:alpine-3.17 /usr/local/ /usr/local/
COPY --from=truemark/node:18-alpine-3.17 /usr/local /usr/local/
RUN apk add libstdc++ --no-cache && \
    npm install -g typescript aws-cdk pnpm yarn esbuild && \
    npm config set fund false --location=global
