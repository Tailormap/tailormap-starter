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

# Setting up continuous deployment

To add continuous deployment, you need a server with Docker and Traefik configured with `--providers.docker` and a Let's Encrypt certificate
resolver named `letsencrypt`. Generate an SSH keypair and add the public key to the `~/.ssh/authorized_keys` file for an account that has
Docker access. Assign a hostname for the deployments to this server.

You can use different SSH keypairs for different deployments. Just add more public keys to the `authorized_keys` file.

Add the repository variables below in GitHub to enable continuous deployment.

Like the continuous deployment in `tailormap-viewer`, the Tailormap API backend will only be deployed for the `main` branch and pull request
deployments will only serve the static Angular frontend on a different base path which will use the API for the main deployment on the `/api`
path. The deployments will be added to the GitHub environment named 'test'.

- `DEPLOY`: set to `true`
- `DEPLOY_HOSTNAME`: set to hostname for the server
- `DEPLOY_PROJECT_NAME`: Name of your customized project, used for docker image and container name (a-z)
- `ADMIN_HASHED_PASSWORD`: Hashed password of the tm-admin account, created when the Tailormap configuration database is empty (only the
  first deployment unless you remove the volume manually). Generate with Spring CLI: ` docker run --rm rocko/spring-boot-cli-docker spring encodepassword "[your password]"`.
- `DEPLOY_IMAGE_TAG`: Tag for Docker image (without version), for example `ghcr.io/b3partners/tailormap-starter`. The image is built in a GitHub Actions worker and uploaded to the server -- it is not pushed to
  a registry. The version used is `snapshot` for deployments for the main `branch` and `pr-nn` for pull request deployments.

Add the following as GitHub secrets:

- `DEPLOY_DOCKER_HOST`: something like `ssh://github-docker-actions@your.server.com`
- `DEPLOY_DOCKER_HOST_SSH_CERT`: the public part of the SSH key as added to `authorized_keys`, something like `ssh-rsa AAAAB3NzaC1yc2EAA(...)ei3Uv4zj9/8M= user@host`
- `DEPLOY_DOCKER_HOST_SSH_KEY`: the private part of the SSH key, without passphrase, something like:

```
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAA...
...
-----END OPENSSH PRIVATE KEY-----
```
