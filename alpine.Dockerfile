FROM truemark/aws-cli:alpine-3.17 AS base
COPY --from=truemark/git:alpine-3.17 /usr/local/ /usr/local/
COPY --from=truemark/git-crypt:alpine-3.17 /usr/local/ /usr/local/
COPY --from=truemark/node:18-alpine-3.17 /usr/local /usr/local/
RUN apk add libstdc++ --no-cache && \
    npm install -g typescript aws-cdk pnpm yarn esbuild && \
    npm config set fund false --location=global

FROM base AS dotnet6
RUN apk add --no-cache curl && \
    curl -sSL https://dot.net/v1/dotnet-install.sh | bash -s -- -c 6.0 && \
    ln -s /root/.dotnet/dotnet /usr/local/bin/dotnet
ENV DOTNET_ROOT="/root/.dotnet"
ENV PATH="/root/.dotnet:${PATH}"

FROM base AS dotnet6
RUN apk add --no-cache curl && \
    curl -sSL https://dot.net/v1/dotnet-install.sh | bash -s -- -c 7.0 && \
    ln -s /root/.dotnet/dotnet /usr/local/bin/dotnet
ENV DOTNET_ROOT="/root/.dotnet"
ENV PATH="/root/.dotnet:${PATH}"
