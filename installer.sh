#!/bin/sh
set -eux

export PYTHONUNBUFFERED=1
export PYTHONDONTWRITEBYTECODE=1

python -m venv "$POETRY_HOME"

"$POETRY_HOME/bin/pip" install wheel
"$POETRY_HOME/bin/pip" install "poetry==$POETRY_VERSION"

echo "Symlinking, disabling virtualenv creation"
ln -s "$POETRY_HOME/bin/poetry" "/usr/local/bin/poetry"

poetry config virtualenvs.create false

echo "Cleanup"
rm -rf "$POETRY_HOME/lib/poetry/_vendor" /tmp/poetry* /tmp/installer.sh
find "$POETRY_HOME" -depth \
    \( \
    \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
    -o \
    \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
    \) -exec rm -rf '{}' +
