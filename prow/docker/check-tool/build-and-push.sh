#!/bin/bash
#
# Copyright 2019 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Login to the Artifactory golang directory
KUBECTL=$(command -v kubectl)
DOCKER_USERNAME=$(${KUBECTL} -n default get secret artifactory-cred -o jsonpath='{.data.username}' | base64 --decode)
DOCKER_PASSWORD=$(${KUBECTL} -n default get secret artifactory-cred -o jsonpath='{.data.password}' | base64 --decode)
docker login docker-na-public.artifactory.swg-devops.com -u "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}"

set -eux

IMAGE_REPO=${IMAGE_REPO:-"quay.io/multicloudlab"}
CHECK_TOOL_IMAGE_NAME=${CHECK_TOOL_IMAGE_NAME:-"check-tool"}
VERSION=${VERSION:-"$(date +v%Y%m%d)-$(git describe --tags --always --dirty)"}

CONTAINER_CLI=${CONTAINER_CLI-"docker"}

${CONTAINER_CLI} build -t "${IMAGE_REPO}/${CHECK_TOOL_IMAGE_NAME}:${VERSION}" .
${CONTAINER_CLI} push "${IMAGE_REPO}/${CHECK_TOOL_IMAGE_NAME}:${VERSION}"
