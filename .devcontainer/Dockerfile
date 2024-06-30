#
# Dev Container Dockerfile
#

From debian:bookworm-slim AS ci-devcontainer-rpidev

COPY .github/docker /.github/docker

COPY .github/citools/ /.github/citools/

RUN sh .github/docker/layer-00.00-base-dependencies.sh ci-devcontainer-rpidev && : 20240629-000

RUN bash .github/docker/layer-00.01-base-env_setup.sh ci-devcontainer-rpidev && : 20240629-000

RUN bash .github/docker/layer-00.05-additional_deps.sh ci-devcontainer-rpidev && : 20240629-000

RUN bash .github/docker/layer-00.10-base-daggerio.sh ci-devcontainer-rpidev && : 20240629-000

RUN bash .github/docker/layer-00.50-base-docker.sh ci-devcontainer-rpidev && : 20240629-000

RUN bash .github/docker/layer-02.00-git.sh ci-devcontainer-rpidev && : 20240629-000

RUN bash .github/docker/layer-09.00-devcontainer-nodejs.sh ci-devcontainer-rpidev && : 20240629-000

RUN bash .github/docker/layer-10.00-devcontainer-gcc_clang_llvm.sh ci-devcontainer-rpidev && : 20240629-000

RUN bash .github/docker/layer-15.00-devcontainer-rust.sh ci-devcontainer-rpidev && : 20240629-000

RUN bash .github/docker/layer-16.00-devcontainer-go.sh ci-devcontainer-rpidev && : 20240629-000

RUN bash .github/docker/layer-18.00-devcontainer-python.sh ci-devcontainer-rpidev && : 20240629-000

RUN bash .github/docker/layer-25.00-tools-vscode.sh ci-devcontainer-rpidev && : 20240629-000

RUN bash .github/docker/layer-35.00-tools-tailscale.sh ci-devcontainer-rpidev && : 20240629-000

RUN bash .github/docker/layer-22.00-devcontainer-rpidev.sh ci-devcontainer-rpidev && : 20240629-000

RUN bash .github/docker/layer-99.00-summary.sh ci-devcontainer-rpidev && : 20240629-000

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY .github/docker/entrypoint.sh /entrypoint.sh

RUN rm -rvf /.github

SHELL ["bash", "-c"]

# app + args
# Executes `entrypoint.sh` when the Docker container starts up
ENTRYPOINT ["/entrypoint.sh"]

# Extra args
CMD []
