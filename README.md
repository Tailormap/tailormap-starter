# Tailormap Starter project

This is a starter project to extend the Tailormap viewer with extra functionality. Fork this repository to get started! Remember to [keep your fork in sync](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork).

See [tailormap-viewer](https://github.com/B3Partners/tailormap-viewer/) for details.

See [GETTING_STARTED](docs/GETTING_STARTED.md) to find an example for adding a component to Tailormap.

## Development

See the documentation of [tailormap-viewer](https://github.com/B3Partners/tailormap-viewer/) for how to run a development server, use a Tailormap API backend, etc.

## Building a Docker image

Choose a container name for your customized Tailormap and the API version you want to use. If you use `snapshot` or `latest` (tags that get
newer images) you'll want to `docker pull` that image first:

Build your Docker image as follows:

```
docker pull ghcr.io/b3partners/tailormap-api:snapshot
docker build --build-arg API_VERSION=snapshot -t my-organisation/tailormap-my-custom-version:snapshot .
```

You may want to use other values for `API_VERSION` to use a specific Tailormap API version and the image tag. Make sure the Tailormap API
version matches the NPM packages you use in this Angular app.

You can run your customized Tailormap container separately or using the Docker (Compose) configuration in tailormap-viewer. For Docker
Compose, specify your custom image and tag in the `TAILORMAP_IMAGE` and `VERSION` variables in an environment file (see the README of
tailormap-viewer and its `.env.template` for details).
