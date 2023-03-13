FROM python:3.9-alpine

COPY requirements.txt .
COPY .pre-commit-config.yaml .
COPY me_csv-0.1.0-py3-none-any.whl .

RUN apk update --no-cache
RUN apk add --no-cache --virtual .build-deps gcc libc-dev make \
    && apk add --no-cache git \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir me_csv-0.1.0-py3-none-any.whl \
    && git init . \
    && pre-commit autoupdate \
    && pre-commit install-hooks \
    && apk del .build-deps gcc libc-dev make
