#!/bin/sh

# Create tor user account
TOR_USER_NAME=tor-dckr
TOR_GROUP_NAME=tor-dckr
echo "Generating user account for tor"
if [ "$TOR_GID" == "" ]; then
	export TOR_GID=1500
fi
if [ "$TOR_UID" == "" ]; then
	export TOR_UID=1500
fi
addgroup -g $TOR_GID $TOR_GROUP_NAME
adduser -D -H -G $TOR_GROUP_NAME -u $TOR_UID $TOR_USER_NAME
mkdir /home/$TOR_USER_NAME/
chown $TOR_USER_NAME:$TOR_GROUP_NAME /home/$TOR_USER_NAME/

# Create privoxy user account
PRIVOXY_USER_NAME=privoxy-dckr
PRIVOXY_GROUP_NAME=privoxy-dckr
echo "Generating user account for privoxy"
if [ "$PRIVOXY_GID" == "" ]; then
	export PRIVOXY_GID=1501
fi
if [ "$PRIVOXY_UID" == "" ]; then
	export PRIVOXY_UID=1501
fi
addgroup -g $PRIVOXY_GID $PRIVOXY_GROUP_NAME
adduser -D -H -G $PRIVOXY_GROUP_NAME -u $PRIVOXY_UID $PRIVOXY_USER_NAME
chown -R $PRIVOXY_USER_NAME:$PRIVOXY_GROUP_NAME /etc/privoxy/

# Set DNS to localhost
cat /etc/resolv.conf.tor > /etc/resolv.conf

# Apply nft definitions
echo 'define uid = '$(id -u $TOR_USER_NAME) | cat - /etc/nftables.conf.template > /tmp/nftables.conf && mv /tmp/nftables.conf /etc/nftables.conf
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
su-exec $TOR_USER_NAME tor -f /etc/tor/torrc > /tmp/tor.log &

# Run privoxy under user "privoxy"
su-exec $PRIVOXY_USER_NAME privoxy --no-daemon /etc/privoxy/config &> /tmp/privoxy.log &

# restore http proxy variables
export http_proxy=$http_proxy_old
export https_proxy=$https_proxy_old

# Wait for tor to be ready
echo "Waiting for tor to become ready."
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
