#!/bin/bash

ENVFILE=$1
shift

cat base.cfg
. base.cfg
cat $ENVFILE
. $ENVFILE

EXTRA=

# TODO: add support for uploading built binaries to S3
# test -n "$AWS_ACCESS_KEY_ID" && EXTRA="$EXTRA --env AWS_ACCESS_KEY_ID"
# test -n "$AWS_SECRET_ACCESS_KEY" && EXTRA="$EXTRA --env AWS_SECRET_ACCESS_KEY"
# test -d $HOME/.aws && EXTRA="$EXTRA -v $HOME/.aws:/builder/.aws"

COMMAND=${ENVFILE%%.cfg}
COMMAND=${COMMAND##*/}

set -x
docker run \
    -it --rm \
    -v $(pwd):/builder \
    --env COMMAND=$COMMAND \
    --env HOME=/builder \
    --env GOPATH=/builder/go \
    --env ARCHS \
    --env GOGET \
    --env FINAL_UID=$(id -u) \
    --env FINAL_GID=$(id -g) \
    $EXTRA \
    golang:$GO_IMAGE_TAG /builder/build.sh
