#!/bin/sh
contains_hyphen() {
  for arg in $@; do
	if [ "$arg" = "-" ]; then return 0; fi
  done
  return 1
}

NAMEBASE="tf-ondock"
NAME="${NAMEBASE}-$(whoami)"
IMAGE="hashicorp/terraform:light"

if [ $(docker ps --filter=name=${NAME} | wc -l) -lt 2 ]; then
  docker run -tid --rm --name ${NAME} -v /tmp:/tmp --entrypoint /bin/sh ${IMAGE} > /dev/null 2>&1
fi
user=$(id -u):$(id -g)
if contains_hyphen $@; then
  docker exec -i -u ${user} ${NAME} $(basename $0) $@
else
  cat | docker exec -i -u ${user} ${NAME} $(basename $0) $@
fi
