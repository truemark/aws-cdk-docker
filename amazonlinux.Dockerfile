ARG NODE_VERSION=XX
FROM truemark/node:${NODE_VERSION}-amazonlinux-2023 AS node

FROM truemark/aws-cli:amazonlinux-2023 AS base
COPY --from=truemark/git:amazonlinux-2023 /usr/local/ /usr/local/
COPY --from=truemark/git-crypt:amazonlinux-2023 /usr/local/ /usr/local/
COPY --from=node /usr/local /usr/local/
RUN npm install -g typescript aws-cdk pnpm yarn esbuild && \
    npm config set fund false --location=global

FROM base AS dotnet6
RUN yum install -y libicu && \
    curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- -c 6.0 && \
    ln -s /root/.dotnet/dotnet /usr/local/bin/dotnet && \
    yum clean all && \
    dotnet tool install -g Amazon.Lambda.Tools
ENV DOTNET_ROOT="/root/.dotnet"
ENV PATH="/root/.dotnet:${PATH}"

FROM dotnet6 AS dotnet6-jre-17
RUN yum install -y java-17-amazon-corretto-headless which && yum clean all

FROM base AS dotnet7
RUN yum install -y libicu && \
    curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- -c 7.0 && \
    ln -s /root/.dotnet/dotnet /usr/local/bin/dotnet && \
    yum clean all && \
    dotnet tool install -g Amazon.Lambda.Tools
ENV DOTNET_ROOT="/root/.dotnet"
ENV PATH="/root/.dotnet:${PATH}"

FROM dotnet7 AS dotnet7-jre-17
RUN yum install -y java-17-amazon-corretto-headless which && yum clean all

FROM base AS dotnet8
RUN yum install -y libicu && \
    curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- -c 8.0 && \
    ln -s /root/.dotnet/dotnet /usr/local/bin/dotnet && \
    yum clean all && \
    dotnet tool install -g Amazon.Lambda.Tools
ENV DOTNET_ROOT="/root/.dotnet"
ENV PATH="/root/.dotnet:${PATH}"

FROM dotnet8 AS dotnet8-jre-21
RUN yum install -y java-21-amazon-corretto-headless which && yum clean all

FROM base AS go
ARG TARGETARCH
RUN curl -fsSL https://golang.org/dl/$(curl -fsSL "https://go.dev/VERSION?m=text" | head -n 1).linux-${TARGETARCH}.tar.gz | tar -C /usr/local -xz && \
    ln -s /usr/local/go/bin/go /usr/local/bin/go
