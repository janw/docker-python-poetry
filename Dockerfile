# Image flavors: '-alpine', '-slim', '-buster', ''
ARG IMAGE_FLAVOR=-alpine
ARG IMAGE_VERSION=3.8

FROM python:${IMAGE_VERSION}${IMAGE_FLAVOR}

ARG POETRY_HOME=/etc/poetry
COPY poetry.sh $POETRY_HOME/bin/poetry
COPY installer.sh /tmp/

# Image flavors: '-alpine', '-slim', '-buster', ''
ARG IMAGE_FLAVOR=-alpine
ARG IMAGE_VERSION=3.8

ENV POETRY_VERSION=1.0.0
ENV POETRY_SHASUM=943ea17135aa5a8d35fe037e39a9696da1a6ed5d470979d206a9bc861a4dbd4e

RUN set -ex; \
    sh /tmp/installer.sh

WORKDIR /src