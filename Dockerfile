FROM alpine:3.3

MAINTAINER Yves Blusseau <90z7oey02@sneakemail.com> (@blusseau)

ENV DEBUG=false              \
	DOCKER_GEN_VERSION=0.7.3 \
	DOCKER_HOST=unix:///var/run/docker.sock

WORKDIR /opt/certbot
ENV PATH /opt/certbot/venv/bin:$PATH
RUN export BUILD_DEPS="git \
                build-base \
                libffi-dev \
                linux-headers \
                py-pip \
                python-dev" \
    && apk -U upgrade \
    && apk add dialog \
                python \
                openssl-dev \
		augeas-libs \
                ${BUILD_DEPS} \
    && pip --no-cache-dir install virtualenv \
    && git clone https://github.com/letsencrypt/letsencrypt /opt/certbot/src \
    && virtualenv --no-site-packages -p python2 /opt/certbot/venv \
    && /opt/certbot/venv/bin/pip install \
        -e /opt/certbot/src/acme \
        -e /opt/certbot/src \
        -e /opt/certbot/src/certbot-dns-route53 \ 
    && apk del ${BUILD_DEPS} \
    && rm -rf /var/cache/apk/*

RUN apk --update add bash curl ca-certificates procps jq tar && \
	curl -L -O https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz && \
	tar -C /usr/local/bin -xvzf docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz && \
	rm -f docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz && \
	apk del tar && \
	rm -rf /var/cache/apk/*

WORKDIR /app

ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh" ]
CMD ["/bin/bash", "/app/start.sh" ]

COPY /app/ /app/
