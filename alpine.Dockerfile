FROM truemark/aws-cli:alpine
COPY --from=truemark/git:musl /usr/local/ /usr/local/
COPY --from=truemark/git-crypt:alpine /usr/local/ /usr/local/
COPY --from=truemark/node:alpine /usr/local /usr/local/
RUN apk add libstdc++ --no-cache
RUN npm install -g aws-cdk
