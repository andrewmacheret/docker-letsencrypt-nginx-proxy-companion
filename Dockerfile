FROM armhero/alpine:3.5

MAINTAINER Yves Blusseau <90z7oey02@sneakemail.com> (@blusseau)

ENV DEBUG=false              \
	DOCKER_GEN_VERSION=0.7.3 \
	DOCKER_HOST=unix:///var/run/docker.sock

WORKDIR /opt/certbot
ENV PATH /opt/certbot/venv/bin:$PATH
RUN export BUILD_DEPS="build-base \
                libffi-dev \
                linux-headers \
                py-pip \
                python-dev \
                curl \
                tar" \
    && apk -U upgrade \
    && apk add dialog \
                python \
                openssl-dev \
		augeas-libs \
                ${BUILD_DEPS} \
    && pip --no-cache-dir install virtualenv \
    && mkdir /opt/certbot/src \
    && curl -L https://github.com/certbot/certbot/archive/v1.3.0.tar.gz | tar xvzf - -C /opt/certbot/src --strip-components=1 \
    && virtualenv -p python2 /opt/certbot/venv \
    && /opt/certbot/venv/bin/pip install \
        -e /opt/certbot/src/acme \
        -e /opt/certbot/src/certbot \
        -e /opt/certbot/src/certbot-dns-route53 \
    && apk del ${BUILD_DEPS} \
    && rm -rf /var/cache/apk/*

RUN apk --update add bash curl ca-certificates procps jq openssl tar && \
	curl -L -O https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-armhf-$DOCKER_GEN_VERSION.tar.gz && \
	tar -C /usr/local/bin -xvzf docker-gen-linux-armhf-$DOCKER_GEN_VERSION.tar.gz && \
	rm -f docker-gen-linux-armhf-$DOCKER_GEN_VERSION.tar.gz && \
	apk del tar && \
	rm -rf /var/cache/apk/*

WORKDIR /app

ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh" ]
CMD ["/bin/bash", "/app/start.sh" ]

COPY /app/ /app/
