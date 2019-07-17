FROM amd64/alpine:3.10

LABEL maintainer="rodolphe.franceschi@gmail.com"

ENV LND_VERSION "v0.7.0-beta"
ENV LND_SHA256 "2e7ed105b9e57103645bda30501cbf3386909cfed19a2fabcc3dc9117ce99a8f"

ENV LND_BASENAME "lnd-linux-amd64-${LND_VERSION}"
ENV LND_ARCHIVE "${LND_BASENAME}.tar.gz"
ENV LND_URL "https://github.com/lightningnetwork/lnd/releases/download/${LND_VERSION}/${LND_ARCHIVE}"
ENV LND_GROUP "lnd"
ENV LND_USER "lnd"


# Create lnd user + group
RUN addgroup ${LND_GROUP} && \
    adduser -D -G ${LND_GROUP} lnd

# Download + Install
RUN cd /tmp \
    && wget -qO ${LND_ARCHIVE} "${LND_URL}" \
    && echo "${LND_SHA256}  ${LND_ARCHIVE}" | sha256sum -c - \
    && tar -xzvf ${LND_ARCHIVE} \
    && mv ${LND_BASENAME}/* /usr/local/bin/ \
    && chmod a+x /usr/local/bin/lncli /usr/local/bin/lnd \
    && rm -rf /tmp/${LND_BASENAME}

# Create data directory
ENV LND_DATA /data
RUN mkdir "$LND_DATA" \
	&& chown -R ${LND_USER}:${LND_GROUP} "$LND_DATA" \
	&& ln -sfn "$LND_DATA" /home/${LND_USER}/.lnd \
	&& chown -h ${LND_USER}:${LND_GROUP} /home/${LND_USER}/.lnd
VOLUME /data

# Clear ENV variables
RUN unset LND_GROUP LND_USER LND_VERSION LND_BASENAME LND_ARCHIVE LND_URL LND_SHA256

COPY run_tests.sh /run_tests.sh
RUN chmod a+x /run_tests.sh

COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

EXPOSE 9735 9911 10009 8080

ENTRYPOINT ["/entrypoint.sh"]

USER lnd
CMD ["lnd"]