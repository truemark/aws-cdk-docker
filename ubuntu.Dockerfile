ARG NODE_VERSION
FROM truemark/node:$NODE_VERSION-ubuntu-jammy AS node

FROM truemark/aws-cli:ubuntu-jammy AS base
COPY --from=truemark/git:ubuntu-jammy /usr/local/ /usr/local/
COPY --from=truemark/git-crypt:ubuntu-jammy /usr/local/ /usr/local/
COPY --from=node /usr/local /usr/local/
RUN npm install -g typescript aws-cdk pnpm yarn esbuild && \
    npm config set fund false --location=global

FROM base AS dotnet6
RUN apt-get update && \
    apt-get install -y libicu70 --no-install-recommends && \
    curl -sSL https://dot.net/v1/dotnet-install.sh | bash -s -- -c 6.0 && \
    ln -s /root/.dotnet/dotnet /usr/local/bin/dotnet && \
    apt-get clean && \
    dotnet tool install -g Amazon.Lambda.Tools
ENV DOTNET_ROOT="/root/.dotnet"
ENV PATH="/root/.dotnet:${PATH}"

FROM dotnet6 AS dotnet6-jre-17
RUN apt-get update && \
    apt-get install -y openjdk-17-jre-headless --no-install-recommends && \
    apt-get clean

FROM base AS dotnet7
RUN apt-get update && \
    apt-get install -y libicu70 --no-install-recommends && \
    curl -sSL https://dot.net/v1/dotnet-install.sh | bash -s -- -c 7.0 && \
    ln -s /root/.dotnet/dotnet /usr/local/bin/dotnet && \
    apt-get clean && \
    dotnet tool install -g Amazon.Lambda.Tools
ENV DOTNET_ROOT="/root/.dotnet"
ENV PATH="/root/.dotnet:${PATH}"

FROM dotnet7 AS dotnet7-jre-17
RUN apt-get update && \
    apt-get install -y openjdk-17-jre-headless --no-install-recommends && \
    apt-get clean

FROM base AS dotnet8
RUN apt-get update && \
    apt-get install -y libicu70 --no-install-recommends && \
    curl -sSL https://dot.net/v1/dotnet-install.sh | bash -s -- -c 8.0 && \
    ln -s /root/.dotnet/dotnet /usr/local/bin/dotnet && \
    apt-get clean && \
    dotnet tool install -g Amazon.Lambda.Tools
ENV DOTNET_ROOT="/root/.dotnet"
ENV PATH="/root/.dotnet:${PATH}"

FROM dotnet8 AS dotnet8-jre-21
RUN apt-get update && \
    apt-get install -y openjdk-21-jre-headless --no-install-recommends && \
    apt-get clean

FROM base AS go
ARG TARGETARCH
RUN curl -fsSL https://golang.org/dl/$(curl -fsSL "https://go.dev/VERSION?m=text" | head -n 1).linux-${TARGETARCH}.tar.gz | tar -C /usr/local -xz && \
    ln -s /usr/local/go/bin/go /usr/local/bin/go
