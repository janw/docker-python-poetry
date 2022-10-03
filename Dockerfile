# Image flavors: '-alpine', '-slim', '-buster', ''
ARG IMAGE_FLAVOR=-alpine
ARG IMAGE_VERSION=3.10

FROM python:${IMAGE_VERSION}${IMAGE_FLAVOR}

ENV POETRY_HOME=/etc/poetry

COPY poetry.sh $POETRY_HOME/bin/poetry
COPY installer.sh /tmp/

# Image flavors: '-alpine', '-slim', '-buster', ''
ARG IMAGE_FLAVOR=-alpine
ARG IMAGE_VERSION=3.10

ENV POETRY_VERSION=1.1.15
ENV POETRY_SHASUM=1c7e6a5175dbabe240cf10fd8167f31a07c404d7cd0b55cb5c68c160049cf486

RUN set -ex; \
    sh /tmp/installer.sh

WORKDIR /src
