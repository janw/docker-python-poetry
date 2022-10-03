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

ENV POETRY_VERSION=1.2.1

RUN set -ex; \
    sh /tmp/installer.sh

WORKDIR /src
