#!/usr/bin/env bash

REPO_NAME="gigalixir-buildpack-releases"
source "$(dirname "${BASH_SOURCE[0]}")/test_framework.sh"

buildpack_dir=$(cd $(dirname $0)/.. && pwd)
build_pack_dir=${ROOT_DIR}

# create directories for test
assets_dir=${TEST_DIR}/assets_dir
build_dir=${TEST_DIR}/build_dir
cache_dir=${TEST_DIR}/cache_dir
mkdir -p ${assets_dir} ${build_dir} ${cache_dir}
