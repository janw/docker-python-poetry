#!/bin/sh
set -eux

# Custom handling for slim images that have no tool for downloading things by default
if [ "$IMAGE_FLAVOR" = "-slim" ]; then
    apt-get update; apt-get install -y --no-install-recommends wget
fi

echo "Downloading archive"
wget -q -O /tmp/poetry.tar.gz \
    https://github.com/sdispater/poetry/releases/download/${POETRY_VERSION}/poetry-${POETRY_VERSION}-linux.tar.gz

echo "Verifying checksum"
[ "$POETRY_SHASUM  /tmp/poetry.tar.gz" = "$(sha256sum /tmp/poetry.tar.gz)" ] || (echo "Checksumming failed" && exit 1)

echo "Extracting"
mkdir -p $POETRY_HOME/lib
tar -xzf /tmp/poetry.tar.gz -C $POETRY_HOME/lib

echo "Marking executable, symlinking, disabling virtualenv creation"
chmod +x $POETRY_HOME/bin/poetry
ln -s $POETRY_HOME/bin/poetry /usr/local/bin/poetry
poetry config virtualenvs.create false

echo "Cleanup"
find "$POETRY_HOME/lib/poetry/_vendor/" \
    -type d -mindepth 1 -maxdepth 1 ! -name "py${IMAGE_VERSION}" -exec rm -r {} \;
rm /tmp/poetry.tar.gz /tmp/installer.sh
find $POETRY_HOME -depth \
    \( \
        \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
        -o \
        \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
    \) -exec rm -rf '{}' +; \

# Custom handling for slim images to remove previous additions
if [ "$IMAGE_FLAVOR" = "-slim" ]; then
    apt-get purge -y --auto-remove wget
    rm -rf /var/lib/apt/lists/*
fi
