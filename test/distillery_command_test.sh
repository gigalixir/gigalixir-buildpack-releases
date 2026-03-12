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
suite "distillery_mix_release_command()"

  test "returns 'release' when distillery is not available"
    # mix help distillery.release will fail in test env
    result=$(distillery_mix_release_command)

    [ "$result" == "release" ]



PASSED_ALL_TESTS=true
