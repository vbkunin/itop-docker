#!/usr/bin/env sh

DOCKER_BUILDKIT=1 docker build \
  --tag vbkunin/itop:"${IMAGE_TAG:?}" \
  --platform="${PLATFORM:-linux/amd64}" \
  --target="${BUILD_TARGET:?}" \
  --build-arg ITOP_DOWNLOAD_URL="${ITOP_DOWNLOAD_URL:?}" \
  -f Dockerfile .