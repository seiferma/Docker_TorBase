# Docker Base Image for Using Tor
This image serves as base image for other images that would like to prohibit all traffic except for TOR. Thereto, this image blocks all traffic via filter rules. The DNS server is bound to the TOR DNS resolver, so name resolution works. To make an application to use TOR, you have to configure the proxy in the application or use tools like [torsocks](https://linux.die.net/man/1/torsocks), which is shipped with this image.

In order to run this (and derived) images, you have to ensure that
* the container is started with capabilities NET_ADMIN and NET_RAW

The image is available via the [Github Container Registry](https://github.com/users/seiferma/packages/container/package/torbase).
