FROM jdubz/elixir:1.10.3

MAINTAINER Josh Williams <vmizzle@gmail.com>

ENV REFRESHED_AT=2020-06-08 \
	NODE_VERSION=12.18.0

RUN apk add --no-cache --virtual .node-build \
		build-base \
		linux-headers \
		python \
		wget && \
	wget -P /tmp -nv https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}.tar.gz && \
	tar -C /tmp -xzf /tmp/node-v${NODE_VERSION}.tar.gz && \
	rm /tmp/node-v${NODE_VERSION}.tar.gz && \
	cd /tmp/node-v${NODE_VERSION} && \
	./configure --prefix=/opt/node && \
	make -j$(nproc) && \
	make install && \
	cd / && rm -rf /tmp/node-v${NODE_VERSION} && \
	apk del --force .node-build

ENV PATH=${PATH}:/opt/node/bin

RUN apk add --no-cache libstdc++ inotify-tools

ENV MIX_HOME=/opt/mix \
	HEX_HOME=/opt/hex

RUN mix local.hex --force && \
	mix local.rebar --force

WORKDIR /usr/src/app

CMD ["/bin/sh"]
