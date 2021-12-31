#!/bin/sh

# Set DNS to localhost
cat /etc/resolv.conf.tor > /etc/resolv.conf

# Apply nft definitions
echo 'define uid = '$(id -u tor) | cat - /etc/nftables.conf.template > /tmp/nftables.conf && mv /tmp/nftables.conf /etc/nftables.conf
nft -f /etc/nftables.conf
if [ $? -ne 0 ]; then
    echo "ERROR: Could not apply nftables definitions."
    echo "Try running the container with the capabilities NET_ADMIN and NET_RAW, e.g. by adding \"--cap-add=NET_ADMIN --cap-add=NET_RAW\" to your command."
    exit 1
fi

# unset http proxy variables
http_proxy_old=$http_proxy
https_proxy_old=$http_proxy_old
http_proxy=
https_proxy=

# Run tor under user "tor"
su-exec tor tor -f /etc/tor/torrc > /tmp/tor.log &

# Run privoxy under user "privoxy"
su-exec privoxy privoxy --no-daemon /etc/privoxy/config &> /tmp/privoxy.log &

# restore http proxy variables
export http_proxy=$http_proxy_old
export https_proxy=$https_proxy_old

# Wait for tor to be ready
DELAY=2
TRIES=30
TIMEOUT=$(( $DELAY * $TRIES ))
i=0
while [ "$i" -le $TRIES ]; do
	if grep -q 'Bootstrapped 100%' /tmp/tor.log &> /dev/null; then
		break
	fi
	if [ "$i" -ge "$TRIES" ]; then
		echo "Tor got not ready within $TIMEOUT s, aborting."
		exit 2
	fi
	sleep $DELAY
done

# Execute command
exec "$@"
