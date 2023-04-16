FROM truemark/aws-cli:ubuntu-jammy AS base
COPY --from=truemark/git:ubuntu-jammy /usr/local/ /usr/local/
COPY --from=truemark/git-crypt:ubuntu-jammy /usr/local/ /usr/local/
COPY --from=truemark/node:18-ubuntu-jammy /usr/local /usr/local/
RUN npm install -g typescript aws-cdk pnpm yarn esbuild && \
    npm config set fund false --location=global

FROM base AS dotnet6
RUN apt-get update && \
    apt-get install -y curl && \
    curl -sSL https://dot.net/v1/dotnet-install.sh | bash -s -- -c 6.0 && \
    ln -s /root/.dotnet/dotnet /usr/local/bin/dotnet && \
    apt-get remove -y curl && apt-get clean \
ENV DOTNET_ROOT="/root/.dotnet"
ENV PATH="/root/.dotnet:${PATH}"
