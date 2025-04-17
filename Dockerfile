FROM python:3.13-alpine3.21 AS builder
LABEL maintainer="Steve Brown https://github.com/audiocomp"

# Update base image and install dependencies
RUN apk update && apk upgrade --no-cache -v && apk add --no-cache -v gcc libc-dev make git libcap

# Update PIP and install required packages
COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip && pip install --no-cache-dir -r /tmp/requirements.txt

# Grant the application the capability to bind to privileged ports
RUN setcap 'cap_net_bind_service=+ep' /usr/local/bin/python3.13

# Copy files
RUN mkdir /app
COPY .pre-commit-config.yaml /app


# Final stage
FROM python:3.13-alpine3.21
LABEL maintainer="Steve Brown https://github.com/audiocomp"

# Update base image
RUN apk update && apk upgrade --no-cache -v && apk add --no-cache -v git
RUN pip install --upgrade pip && pip install --no-cache-dir pre-commit

# Create a non-root user and group
RUN addgroup -g 1501 -S appgroup && adduser -u 1501 -D -S appuser -G appgroup
ENV PATH="$PATH:/home/appuser/.local/bin"

# Copy Python packages from builder stage
COPY --from=builder /app /app
COPY --from=builder /usr/local/lib/python3.13/site-packages /usr/local/lib/python3.13/site-packages

# Change ownership of the application files
RUN chown -R appuser:appgroup /app

# Switch to the non-root user
USER appuser
WORKDIR /app
RUN cd /app \
    && git init . \
    && pre-commit autoupdate \
    && pre-commit install-hooks
