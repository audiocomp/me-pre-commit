FROM python:3.11-alpine3.18
LABEL maintainer="Steve Brown https://github.com/audiocomp"

# Update SSL
RUN apk add --no-cache --progress -v openssl

# Update PIP
RUN pip install --upgrade pip

# Copy files
COPY requirements.txt .
COPY .pre-commit-config.yaml .

# Install Packages
RUN apk update --no-cache
RUN apk add --no-cache --virtual .build-deps gcc libc-dev make \
    && apk add --no-cache git \
    && pip install --no-cache-dir -r requirements.txt \
    && git init . \
    && pre-commit autoupdate \
    && pre-commit install-hooks \
    && apk del .build-deps gcc libc-dev make
