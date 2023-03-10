FROM python:3.9-alpine

COPY requirements.txt /tmp/requirements.txt

RUN apk update --no-cache \
    && apk add --no-cache gcc libc-dev make git \
    && pip install --no-cache-dir -r /tmp/requirements.txt
