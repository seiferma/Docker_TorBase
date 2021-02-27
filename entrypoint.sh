#!/bin/sh

# Set DNS to localhost
echo "nameserver 127.0.0.1:9053" > /etc/resolv.conf

# Apply nft definitions
nft -f /etc/nftables.conf
if [ $? -ne 0 ]; then
    echo "ERROR: Could not apply nftables definitions."
    echo "Try running the container with the capabilities NET_ADMIN and NET_RAW, e.g. by adding \"--cap-add=NET_ADMIN --cap-add=NET_RAW\" to your command."
    exit 1
fi

# Run tor under user "tor"
su-exec tor tor -f /etc/tor/torrc > /tmp/tor.log &

# Execute command
exec "$@"
