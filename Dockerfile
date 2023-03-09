FROM python:3.9-alpine

RUN apk update --no-cache \
    && apk add --no-cache git \
    && pip install --no-cache-dir pre-commit

COPY .pre-commit-config.yaml .

RUN apk add --no-cache --virtual .build-deps gcc libc-dev make \
    && git init . && pre-commit install-hooks \
    && apk del .build-deps gcc libc-dev make

