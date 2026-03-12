#!/usr/bin/env bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $SCRIPT_DIR/.test_support.sh

# include source file
source $SCRIPT_DIR/../lib/build.sh

# override functions
output_line() {
  /bin/true
}
output_section() {
  /bin/true
}

# TESTS
######################
suite "export_mix_env()"

  test "reads MIX_ENV from env file"
    unset MIX_ENV
    env_path="${TEST_DIR}/env_mix1"
    mkdir -p "$env_path"
    echo "staging" > "$env_path/MIX_ENV"

    export_mix_env

    [ "$MIX_ENV" == "staging" ]

  test "defaults to prod when no file exists"
    unset MIX_ENV
    env_path="${TEST_DIR}/env_mix2"

    export_mix_env

    [ "$MIX_ENV" == "prod" ]

  test "does not override existing MIX_ENV"
    export MIX_ENV="custom"
    env_path="${TEST_DIR}/env_mix3"
    mkdir -p "$env_path"
    echo "staging" > "$env_path/MIX_ENV"

    export_mix_env

    [ "$MIX_ENV" == "custom" ]

  test "accepts default parameter"
    unset MIX_ENV
    env_path="${TEST_DIR}/env_mix4"

    export_mix_env "dev"

    [ "$MIX_ENV" == "dev" ]



PASSED_ALL_TESTS=true
