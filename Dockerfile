FROM alpine:3.22

ARG TOR_VERSION=
ARG TORSOCKS_VERSION=
ARG PRIVOXY_VERSION=

RUN apk add --no-cache tor=${TOR_VERSION} nftables torsocks=${TORSOCKS_VERSION} su-exec privoxy=${PRIVOXY_VERSION}
COPY ./overlay/ /

ENV http_proxy=http://127.0.0.1:8118
ENV https_proxy=http://127.0.0.1:8118

ENTRYPOINT ["/entrypoint.sh"]
HEALTHCHECK --interval=60s --timeout=60s --start-period=15s --retries=3 CMD /usr/bin/wget --spider http://example.org || exit 1
CMD ["/bin/sh"]
