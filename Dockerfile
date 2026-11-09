ARG API_VERSION=snapshot

FROM node:24.22.2 AS builder

ARG BASE_HREF=/
ARG ADD_NG_LIBRARIES
ARG APPEND_NPMRC
ARG ANGULAR_APP

WORKDIR /app

COPY ./package.json /app
COPY ./package-lock.json /app

RUN npm install --no-audit --no-fund

COPY . /app

RUN npx tm-add-ng-libraries
RUN npm run build -- --app=${ANGULAR_APP} --base-href=${BASE_HREF} --rename-to-app
# Empty directory for the log files, see below
RUN mkdir /logs

FROM ghcr.io/tailormap/tailormap-api:${API_VERSION}

COPY --from=builder /app/dist/app /home/cnb/static/
# Directory for the log files owned by the cnb user the application runs as, so a volume mounted on it is writable. A
# volume mounted on a directory which does not exist in the image is owned by root. See docker-compose.logs.yml in
# tailormap-viewer
COPY --from=builder --chown=cnb:cnb /logs /home/cnb/logs
