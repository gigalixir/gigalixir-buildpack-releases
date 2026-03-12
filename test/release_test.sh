#!/usr/bin/env bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $SCRIPT_DIR/.test_support.sh

# TESTS
######################
suite "bin/release"

  test "outputs valid YAML structure"
    export GIGALIXIR_APP_NAME="my_app"
    result=$(bash ${build_pack_dir}/bin/release)

    echo "$result" | grep -q "^---$"
    echo "$result" | grep -q "addons:"
    echo "$result" | grep -q "default_process_types:"

  test "includes app name in web command"
    export GIGALIXIR_APP_NAME="my_app"
    result=$(bash ${build_pack_dir}/bin/release)

    echo "$result" | grep -q "/app/bin/my_app start"

  test "uses GIGALIXIR_APP_NAME variable"
    export GIGALIXIR_APP_NAME="other_app"
    result=$(bash ${build_pack_dir}/bin/release)

    echo "$result" | grep -q "/app/bin/other_app start"

  test "addons is empty array"
    export GIGALIXIR_APP_NAME="my_app"
    result=$(bash ${build_pack_dir}/bin/release)

    echo "$result" | grep -q "\[\]"



PASSED_ALL_TESTS=true
