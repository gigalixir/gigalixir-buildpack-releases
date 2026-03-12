#!/usr/bin/env bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $SCRIPT_DIR/.test_support.sh

# TESTS
######################
suite "bin/detect"

  test "exits 0 when mix.exs exists"
    touch "${build_dir}/mix.exs"

    ${build_pack_dir}/bin/detect "${build_dir}" > /dev/null
    [ $? -eq 0 ]

  test "outputs 'Core Releases' when mix.exs exists"
    result=$(${build_pack_dir}/bin/detect "${build_dir}")
    [ "$result" == "Core Releases" ]

  test "exits 1 when mix.exs does not exist"
    rm -f "${build_dir}/mix.exs"

    set +e
    ${build_pack_dir}/bin/detect "${build_dir}" > /dev/null 2>&1
    exit_code=$?
    set -e

    [ $exit_code -eq 1 ]



PASSED_ALL_TESTS=true
