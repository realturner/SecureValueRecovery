#!/bin/bash
SCRIPT="$0"

usage() {
  echo "Usage: $1 <env.sh> <tagName>"
  echo "  Issue local docker to build image tagged by <tagName> and push to remote"
}

env="$1"
tag="$2"

if [ ! -f "$env" -o -z "$tag" ] ; then
  usage "$0"
  exit 1
fi

source "$1"
ENV_DIR="$( cd -P "$( dirname "$env" )" && pwd )"
pushd "$ENV_DIR" || exit 1

docker build -t "$IMAGE_NAME:$tag" . \
  && docker tag "$IMAGE_NAME:$tag" "$REPO_HOST/$IMAGE_NAME:$tag" \
  && docker push "$REPO_HOST/$IMAGE_NAME:$tag" \
  && docker tag "$IMAGE_NAME:$tag" "$REPO_HOST/$IMAGE_NAME:latest" \
  && docker push "$REPO_HOST/$IMAGE_NAME:latest"

stat=$?

popd

if [ $stat == 0 ] ; then
  echo "==============================="
  echo "Build Success: "
  echo "  URI:   $REPO_HOST/$IMAGE_NAME:$tag"
  echo "  Tag:   $tag"
  echo "  Image: $IMAGE_NAME:$tag"
fi

exit $stat
