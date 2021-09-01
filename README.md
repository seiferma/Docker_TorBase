# Docker Base Image for Using Tor
[![](https://github.com/seiferma/Docker_TorBase/actions/workflows/docker-publish.yml/badge.svg?branch=main)](https://github.com/seiferma/Docker_TorBase/actions?query=branch%3Amain+)
[![](https://img.shields.io/github/issues/seiferma/Docker_TorBase.svg)](https://github.com/seiferma/Docker_TorBase/issues)
[![](https://img.shields.io/github/license/seiferma/Docker_TorBase.svg)](https://github.com/seiferma/Docker_TorBase/blob/main/LICENSE)

This image serves as base image for other images that would like to prohibit all traffic except for TOR. Thereto, this image blocks all traffic via filter rules. The DNS server is bound to the TOR DNS resolver, so name resolution works. To make an application to use TOR, you have to configure the proxy in the application or use tools like [torsocks](https://linux.die.net/man/1/torsocks), which is shipped with this image.

In order to run this (and derived) images, you have to ensure that
* the container is started with capabilities NET_ADMIN and NET_RAW

The image is available as `quay.io/seiferma/tor-base`. View all available tags on [quay.io](https://quay.io/repository/seiferma/tor-base?tab=tags).
