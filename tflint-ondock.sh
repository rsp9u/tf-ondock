#!/bin/sh
NAMEBASE="tflint-ondock"
NAME="${NAMEBASE}-$(whoami)"
IMAGE="wata727/tflint"
if [ $(docker ps --filter=name=${NAME} | wc -l) -lt 2 ]; then
  docker run -tid --rm --name ${NAME} -v /tmp:/tmp --entrypoint /bin/sh ${IMAGE} > /dev/null 2>&1
fi
docker exec -i ${NAME} /usr/local/bin/tflint $@
