ARG API_VERSION=snapshot

FROM node:24.12.0 AS builder

ARG BASE_HREF=/
ARG ADD_NG_LIBRARIES
ARG APPEND_NPMRC
ARG ANGULAR_APP

WORKDIR /app

COPY ./package.json /app
COPY ./package-lock.json /app

RUN npm install

COPY . /app

RUN npx tm-add-ng-libraries
RUN npm run build -- --app=${ANGULAR_APP} --base-href=${BASE_HREF} --rename-to-app

FROM ghcr.io/tailormap/tailormap-api:${API_VERSION}

COPY --from=builder /app/dist/app static/
