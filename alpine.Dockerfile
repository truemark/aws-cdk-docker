FROM truemark/aws-cli:alpine-3.17 AS base
COPY --from=truemark/git:alpine-3.17 /usr/local/ /usr/local/
COPY --from=truemark/git-crypt:alpine-3.17 /usr/local/ /usr/local/
COPY --from=truemark/node:18-alpine-3.17 /usr/local /usr/local/
RUN apk add libstdc++ --no-cache && \
    npm install -g typescript aws-cdk pnpm yarn esbuild && \
    npm config set fund false --location=global

FROM base AS dotnet6
RUN apk add --no-cache icu-libs && \
    curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- -c 6.0 && \
    ln -s /root/.dotnet/dotnet /usr/local/bin/dotnet && \
    dotnet tool install -g Amazon.Lambda.Tools
ENV DOTNET_ROOT="/root/.dotnet"
ENV PATH="/root/.dotnet:${PATH}"

FROM dotnet6 AS dotnet6-jre-17
RUN apk add --no-cache openjdk17-jre-headless

FROM base AS dotnet7
RUN apk add --no-cache icu-libs && \
    curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- -c 7.0 && \
    ln -s /root/.dotnet/dotnet /usr/local/bin/dotnet && \
    dotnet tool install -g Amazon.Lambda.Tools
ENV DOTNET_ROOT="/root/.dotnet"
ENV PATH="/root/.dotnet:${PATH}"

FROM dotnet6 AS dotnet7-jre-17
RUN apk add --no-cache openjdk17-jre-headless

FROM base AS go
ARG TARGETARCH
RUN curl -fsSL https://golang.org/dl/$(curl -fsSL "https://go.dev/VERSION?m=text").linux-${TARGETARCH}.tar.gz | tar -C /usr/local -xz && \
    ln -s /usr/local/go/bin/go /usr/local/bin/go
