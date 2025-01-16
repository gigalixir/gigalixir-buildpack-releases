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
suite "copy_static_files()"


  test "does not exist"
    copy_static_files "nonexistent" "${build_dir}/static"

    [ ! -d "${build_dir}/static" ]

  test "recursive copy"
    mkdir -p "${build_dir}/.gigalixir/static/dir1"
    touch "${build_dir}/.gigalixir/static/dir1/file2"
    touch "${build_dir}/.gigalixir/static/file1"

    copy_static_files "${build_dir}/.gigalixir/static" "${build_dir}/copy"

    [ -d "${build_dir}/copy" ]
    [ -d "${build_dir}/copy/dir1" ]
    [ -f "${build_dir}/copy/dir1/file2" ]
    [ -f "${build_dir}/copy/file1" ]



PASSED_ALL_TESTS=true
