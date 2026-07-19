#!/usr/bin/env make
SHELL=/bin/bash

DOCKER=podman

NO_NETWORK=
NETWORK=$$([ -n "${NO_NETWORK}" ] && echo "none" || echo "host")

HOST_PATH_TO_PROJECT=$${HOST_PATH_TO_PROJECT?Please provide HOST_PATH_TO_PROJECT}
CONTAINER_PATH_TO_MOUNT_PROJECT=${HOST_PATH_TO_PROJECT}

CODEX_IMAGE=codex_arch
CODEX_CONTAINER=codex_arch
UUID=$(shell id -u)
GUID=$(shell id -g)
UNAME=$(shell whoami)

ARCH_BASE_IMAGE=techgk/arch:latest

WITH_USERNS=$$(eval [ "podman" == "${DOCKER}" ] && echo "--userns=keep-id")

MAKERC=.makerc
include ${CURDIR}/${MAKERC}

list:
	@ $(MAKE) -pRrq -f Makefile : 2>/dev/null \
		| grep -e "^[^[:blank:]]*:$$\|#.*recipe to execute" \
		| grep -B 1 "recipe to execute" \
		| grep -e "^[^#]*:$$" \
		| sed -e "s/\(.*\):/\1/g" \
		| sort

build:
	@ ${DOCKER} build \
		--net=pasta:-4 \
		--build-arg USER_ID=${UUID} \
		--build-arg GROUP_ID=${GUID} \
		--build-arg USER_NAME=${UNAME} \
		--build-arg ARCH_BASE_IMAGE=${ARCH_BASE_IMAGE} \
		-t ${CODEX_IMAGE} .;

run:
	@ ${DOCKER} run --rm -it \
		--shm-size 2g \
		--network ${NETWORK} \
		--name "${CODEX_CONTAINER}" \
		${WITH_USERNS} \
		--security-opt label=type:container_runtime_t \
		-v "${CURDIR}"/docker_files/home/.cache:/home/${UNAME}/.cache \
		-v "${CURDIR}"/docker_files/home/.config:/home/${UNAME}/.config \
		-v "${CURDIR}"/docker_files/home/.codex:/home/${UNAME}/.codex \
		-v "${HOST_PATH_TO_PROJECT}":"${CONTAINER_PATH_TO_MOUNT_PROJECT}" \
		--workdir "${CONTAINER_PATH_TO_MOUNT_PROJECT}" \
		${CODEX_IMAGE}

logs:
	@ ${DOCKER} logs -f "${CODEX_CONTAINER}"

bash:
	@ ${DOCKER} exec -it "${CODEX_CONTAINER}" /bin/bash
