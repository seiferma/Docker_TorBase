FROM alpine:latest

RUN apk add --no-cache tor nftables torsocks su-exec privoxy
COPY ./torrc /etc/tor/
COPY ./nftables.conf.template /etc/nftables.conf.template
COPY ./entrypoint.sh /
COPY ./resolv.conf /etc/resolv.conf.tor
COPY ./privoxy_config /etc/privoxy/config

ENV http_proxy=http://127.0.0.1:8118
ENV https_proxy=http://127.0.0.1:8118

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/sh"]
