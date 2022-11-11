FROM truemark/aws-cli:latest
COPY --from=truemark/git:amazonlinux-2 /usr/local/ /usr/local/
RUN curl -sSL https://rpm.nodesource.com/setup_16.x | bash - && \
    yum install -q -y nodejs zip unzip && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    npm install -g typescript aws-cdk esbuild yarn pnpm --quiet
