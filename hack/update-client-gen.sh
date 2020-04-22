#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
export GOPATH=$(go env GOPATH)
SCRIPT_ROOT=$(dirname ${BASH_SOURCE})/..
echo ${SCRIPT_ROOT}
CODEGEN_PKG=${CODEGEN_PKG:-$(cd ${SCRIPT_ROOT}; ls -d -1 ./code-gen-vendor/k8s.io/code-generator 2>/dev/null || echo ../../../k8s.io/code-generator)}

# generate the code with:
# --output-base    because this script should also be able to run inside the vendor dir of
#                  k8s.io/kubernetes. The output-base is needed for the generators to output into the vendor dir
#                  instead of the $GOPATH directly. For normal projects this can be dropped.
${CODEGEN_PKG}/generate-groups.sh "client,informer,lister" \
  github.com/oam-dev/oam-go-sdk/pkg/client github.com/oam-dev/oam-go-sdk/apis \
  core.oam.dev:v1alpha1 \
  --output-base "$(dirname ${BASH_SOURCE})/../../../.." \
  --go-header-file ${SCRIPT_ROOT}/hack/boilerplate.go.txt