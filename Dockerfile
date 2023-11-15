ARG BUILDPLATFORM=linux/amd64
ARG API_VERSION=snapshot

FROM node:18.17.1 AS builder

ARG BASE_HREF=/

WORKDIR /app

COPY ./package.json /app
COPY ./package-lock.json /app
RUN npm install

COPY . /app

RUN npm run build-localized -- --base-href=${BASE_HREF}

FROM --platform=$BUILDPLATFORM ghcr.io/b3partners/tailormap-api:${API_VERSION}

ARG LABEL_AUTHORS
ARG LABEL_DESCRIPTION
ARG LABEL_VENDOR
ARG LABEL_TITLE="Tailormap (customized)"
ARG LABEL_LICENSES="YOUR-LICENSE-HERE"

LABEL org.opencontainers.image.authors="${LABEL_AUTHORS}" \
      org.opencontainers.image.description="${LABEL_DESCRIPTION}" \
      org.opencontainers.image.vendor="${LABEL_VENDOR}" \
      org.opencontainers.image.title="${LABEL_TITLE}" \
      org.opencontainers.image.url="https://github.com/B3Partners/tailormap-viewer/" \
      org.opencontainers.image.source="https://github.com/B3Partners/tailormap-viewer/" \
      org.opencontainers.image.documentation="https://github.com/B3Partners/tailormap-viewer/" \
      org.opencontainers.image.licenses="${LABEL_LICENSES}" \
      org.opencontainers.image.version="$VERSION" \
      org.opencontainers.image.base.name="b3partners/tailormap-api:$API_VERSION" \
      tailormap-api.version=$API_VERSION

COPY --from=builder /app/dist/app static/
