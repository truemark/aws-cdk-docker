FROM truemark/aws-cli:amazonlinux-2023 AS base
COPY --from=truemark/git:amazonlinux-2023 /usr/local/ /usr/local/
COPY --from=truemark/git-crypt:amazonlinux-2023 /usr/local/ /usr/local/
COPY --from=truemark/node:18-amazonlinux-2023 /usr/local /usr/local/
RUN npm install -g typescript aws-cdk pnpm yarn esbuild && \
    npm config set fund false --location=global

FROM base AS dotnet6
RUN yum install -y findutils tar gzip && \
    curl -sSL https://dot.net/v1/dotnet-install.sh | bash -s -- -c 6.0 && \
    ln -s /root/.dotnet/dotnet /usr/local/bin/dotnet && \
    yum clean all
ENV DOTNET_ROOT="/root/.dotnet"
ENV PATH="/root/.dotnet:${PATH}"

FROM base AS dotnet7
RUN yum install -y findutils tar gzip && \
    curl -sSL https://dot.net/v1/dotnet-install.sh | bash -s -- -c 7.0 && \
    ln -s /root/.dotnet/dotnet /usr/local/bin/dotnet && \
    yum clean all
ENV DOTNET_ROOT="/root/.dotnet"
ENV PATH="/root/.dotnet:${PATH}"
