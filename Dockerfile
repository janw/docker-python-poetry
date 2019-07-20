ARG IMAGE_VERSION=3.7
ARG IMAGE_FLAVOR=
FROM python:${IMAGE_VERSION}${IMAGE_FLAVOR}

ARG POETRY_HOME=/poetry
COPY poetry.sh $POETRY_HOME/bin/poetry
COPY installer.sh /tmp/

ARG IMAGE_VERSION=3.7
ARG IMAGE_FLAVOR=-alpine
ENV POETRY_VERSION=0.12.17
ENV POETRY_SHASUM=862bff9bb15c0193aa831b9acb886f61a23a055c8910ea094e996d663c974037

RUN sh /tmp/installer.sh

WORKDIR /src