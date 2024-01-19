#!/usr/bin/env sh

# Example:
#  BUILD_TARGET=base
#  IMAGE_TAG=3.1.0-base
#  ITOP_DOWNLOAD_URL=https://sourceforge.net/projects/itop/files/itop/3.1.1-1/iTop-3.1.1-1-12561.zip/download
#
# Create and use a new builder instance (if needed):
#  docker buildx create --name container --driver docker-container --bootstrap --use

docker buildx build \
  --tag vbkunin/itop:"${IMAGE_TAG:?}" \
  --platform="linux/arm64,linux/amd64" \
  --push \
  --target="${BUILD_TARGET:?}" \
  --build-arg ITOP_DOWNLOAD_URL="${ITOP_DOWNLOAD_URL:?}" \
  -f Dockerfile .