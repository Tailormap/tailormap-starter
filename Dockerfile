ARG BUILDPLATFORM=linux/amd64
ARG API_VERSION=snapshot

FROM node:22.13.0 AS builder

ARG BASE_HREF=/
ARG ADD_NG_LIBRARIES
ARG APPEND_NPMRC
ARG ANGULAR_APP

WORKDIR /app

COPY ./package.json /app
COPY ./package-lock.json /app
COPY .npmrc /app
RUN npm install

COPY . /app

RUN npx tm-add-ng-libraries
RUN npm run build -- --app=${ANGULAR_APP} --base-href=${BASE_HREF} --rename-to-app

FROM --platform=$BUILDPLATFORM ghcr.io/tailormap/tailormap-api:${API_VERSION}

COPY --from=builder /app/dist/app static/
