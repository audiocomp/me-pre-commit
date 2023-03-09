FROM python:3.9-alpine

RUN apk update --no-cache \
    && apk add --no-cache gcc libc-dev make git \
    && pip install --no-cache-dir pre-commit
