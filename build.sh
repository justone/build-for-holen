#!/bin/bash

go get -v github.com/mitchellh/gox
export PATH=$PATH:$GOPATH/bin

go get -v $GOGET
cd $GOPATH/src/$GOGET

set -x
gox -output="${COMMAND}_{{.OS}}_{{.Arch}}" -osarch="$ARCHS"
set +x

OUTPUT=/builder/output

CMD_OUTPUT="${OUTPUT}/${COMMAND}/$(date +%Y-%m-%d-%H%M)"
mkdir -p $CMD_OUTPUT
cp ${COMMAND}* $CMD_OUTPUT

cd $CMD_OUTPUT
sha256sum * > sha256sum.sums

cd /builder
rm -rf go

chown -R $FINAL_UID:$FINAL_GID $OUTPUT
