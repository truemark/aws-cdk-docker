FROM amazon/aws-cli:latest
COPY --from=truemark/git:amazonlinux-2 /usr/local/ /usr/local/
RUN curl -sSL https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o /usr/local/bin/jq && \
    chmod +x /usr/local/bin/jq && \
    curl -sSL https://rpm.nodesource.com/setup_16.x | bash - && \
    yum install -q -y nodejs && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    npm install -g typescript aws-cdk --quiet
COPY helper.sh /usr/local/bin/helper.sh
COPY init.sh /usr/local/bin/init.sh
COPY cdkw /usr/local/bin/cdkw
ENTRYPOINT ["/usr/local/bin/cdkw"]
