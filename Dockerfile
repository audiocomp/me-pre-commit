FROM python:3.9-alpine

COPY requirements.txt .
COPY .pre-commit-config.yaml .

RUN apk update --no-cache
RUN apk add --no-cache --virtual .build-deps gcc libc-dev make \
    && apk add --no-cache git \
    && pip install --no-cache-dir -r requirements.txt \
    && git init . \
    && pre-commit autoupdate \
    && pre-commit install-hooks \
    && apk del .build-deps gcc libc-dev make
