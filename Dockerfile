ARG BUILDPLATFORM=linux/amd64
ARG API_VERSION=snapshot

FROM node:18.17.1 AS builder

ARG BASE_HREF=/

WORKDIR /app

COPY ./package.json /app
COPY ./package-lock.json /app
RUN npm install

COPY . /app

RUN npm run build -- --base-href=${BASE_HREF}
RUN npm run build-admin -- --base-href=${BASE_HREF}admin/

FROM --platform=$BUILDPLATFORM ghcr.io/b3partners/tailormap-api:${API_VERSION}

COPY --from=builder /app/dist/app static/
