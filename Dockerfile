FROM alpine:latest

RUN apk add --no-cache tor nftables torsocks su-exec
COPY ./torrc /etc/tor/
COPY ./nftables.conf /etc/nftables.conf
COPY ./entrypoint.sh /
COPY ./resolv.conf /etc/resolv.conf.tor

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/sh"]
