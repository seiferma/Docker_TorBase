FROM alpine:latest

RUN apk add --no-cache tor nftables torsocks su-exec
COPY ./torrc /etc/tor/
COPY ./nftables.conf /etc/nftables.conf
COPY ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/sh"]
