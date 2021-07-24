#!/bin/sh
set -eux

export PYTHONUNBUFFERED=1
export PYTHONDONTWRITEBYTECODE=1

# Custom handling for slim images that have no tool for downloading things by default
if [ "$IMAGE_FLAVOR" = "-alpine" ]; then
    apk add --no-cache rsync
else
    apt-get update
    apt-get install -y --no-install-recommends wget rsync
fi

echo "Downloading archive"
wget -q -O /tmp/poetry.tar.gz \
    "https://github.com/python-poetry/poetry/releases/download/${POETRY_VERSION}/poetry-${POETRY_VERSION}-linux.tar.gz"

echo "Verifying checksum"
[ "$POETRY_SHASUM  /tmp/poetry.tar.gz" = "$(sha256sum /tmp/poetry.tar.gz)" ] || (echo "Checksumming failed" && exit 1)

echo "Extracting"
mkdir -p "$POETRY_HOME/lib"
tar -xzf /tmp/poetry.tar.gz -C "$POETRY_HOME/lib"

echo "Marking executable, symlinking, disabling virtualenv creation"
chmod +x "$POETRY_HOME/bin/poetry"
ln -s "$POETRY_HOME/bin/poetry" "/usr/local/bin/poetry"
rsync -a "$POETRY_HOME/lib/poetry/_vendor/py${IMAGE_VERSION}/" "$POETRY_HOME/lib/"

poetry config virtualenvs.create false

echo "Cleanup"
rm -rf "$POETRY_HOME/lib/poetry/_vendor" /tmp/poetry* /tmp/installer.sh
find "$POETRY_HOME" -depth \
    \( \
        \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
        -o \
        \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
    \) -exec rm -rf '{}' +; \

# Custom handling for slim images to remove previous additions
if [ "$IMAGE_FLAVOR" = "-alpine" ]; then
    apk del --no-cache rsync
    apk cache clean
else
    apt-get purge -y --auto-remove wget rsync
    rm -rf /var/lib/apt/lists/*
fi
