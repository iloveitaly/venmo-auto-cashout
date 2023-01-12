FROM python:3.9-alpine3.12

RUN apk add --update \
      curl \
      openssl-dev \
    && rm -rf /var/cache/apk/*

# Install sentry-cli for monitor checkins
RUN curl -sL https://sentry.io/get-cli/ | SENTRY_CLI_VERSION="2.11.0" sh

WORKDIR /app

# Setup PDM
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
RUN pip install pdm
ENV PYTHONPATH=/usr/local/lib/python3.9/site-packages/pdm/pep582

# install python deps
COPY pdm.lock pyproject.toml /app/
RUN pdm install

# Add python source
COPY venmo_auto_cashout /app/venmo_auto_cashout/
RUN pdm install

COPY docker_entrypoint.sh /app/docker_entrypoint.sh

ENTRYPOINT ["/app/docker_entrypoint.sh"]
