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
suite "load_config"


  test "default config"
    app_relative_path="none"
    load_config
    [ "." == "$app_relative_path" ]

  test "loads legacy config"
    echo 'app_relative_path="legacy"' > $build_dir/distillery_buildpack.config

    load_config
    [ "legacy" == "$app_relative_path" ]

  test "loads explicit config"
    echo 'app_relative_path="primary"' > $build_dir/releases_buildpack.config

    load_config
    [ "primary" == "$app_relative_path" ]

  test "loads envvar config"
    GIGALIXIR_RELEASES_BUILDPACK_CONFIG='app_relative_path="envvar"'

    load_config
    [ "envvar" == "$app_relative_path" ]



PASSED_ALL_TESTS=true
