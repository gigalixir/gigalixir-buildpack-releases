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
suite "export_env_vars()"

  test "exports all vars from env directory"
    env_path="${TEST_DIR}/env_vars"
    mkdir -p "$env_path"
    echo "hello" > "$env_path/MY_VAR"
    echo "world" > "$env_path/OTHER_VAR"

    unset MY_VAR OTHER_VAR
    export_env_vars

    [ "$MY_VAR" == "hello" ]
    [ "$OTHER_VAR" == "world" ]

  test "respects blacklist regex"
    env_path="${TEST_DIR}/env_vars2"
    mkdir -p "$env_path"
    echo "/custom/path" > "$env_path/PATH"
    echo "someval" > "$env_path/SAFE_VAR"

    unset SAFE_VAR
    old_path="$PATH"
    export_env_vars

    [ "$PATH" == "$old_path" ]
    [ "$SAFE_VAR" == "someval" ]

  test "respects whitelist regex"
    env_path="${TEST_DIR}/env_vars3"
    mkdir -p "$env_path"
    echo "yes" > "$env_path/ALLOWED_VAR"
    echo "no" > "$env_path/BLOCKED_VAR"

    unset ALLOWED_VAR BLOCKED_VAR
    export_env_vars "" "^ALLOWED"

    [ "$ALLOWED_VAR" == "yes" ]
    [ -z "$BLOCKED_VAR" ]

  test "handles empty env directory"
    env_path="${TEST_DIR}/env_empty"
    mkdir -p "$env_path"

    export_env_vars

  test "handles missing env directory"
    env_path="${TEST_DIR}/nonexistent_env_dir"

    export_env_vars



PASSED_ALL_TESTS=true
