# Image flavors: '-alpine', '-slim', '-buster', ''
ARG IMAGE_FLAVOR=-alpine
ARG IMAGE_VERSION=3.9

FROM python:${IMAGE_VERSION}${IMAGE_FLAVOR}

ENV POETRY_HOME=/etc/poetry

COPY poetry.sh $POETRY_HOME/bin/poetry
COPY installer.sh /tmp/

# Image flavors: '-alpine', '-slim', '-buster', ''
ARG IMAGE_FLAVOR=-alpine
ARG IMAGE_VERSION=3.9

ENV POETRY_VERSION=1.1.7
ENV POETRY_SHASUM=d9ece46b4874e93e1464025891d14c83d75420feec8621a680be14376e77198b

RUN set -ex; \
    sh /tmp/installer.sh

WORKDIR /src
