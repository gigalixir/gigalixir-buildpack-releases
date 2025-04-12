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


  test "no include file exists"
    mkdir -p "${build_dir}/dir1" "${build_dir}/dir2/dir3"
    touch "${build_dir}/file0"
    touch "${build_dir}/dir1/file1"
    touch "${build_dir}/dir2/file2"
    touch "${build_dir}/dir2/dir3/file3"

    copy_static_files "${build_dir}/copy"

    [ ! -d "${build_dir}/copy/dir1" ]
    [ ! -d "${build_dir}/copy/dir2" ]
    [ ! -f "${build_dir}/copy/file0" ]

  test "syncs files in pattern match"
    mkdir -p "${build_dir}/.gigalixir/releases"
    /bin/echo "file0" > "${build_dir}/.gigalixir/releases/includes.txt"

    copy_static_files "${build_dir}/copy" > /dev/null

    [ ! -d "${build_dir}/copy/dir1" ]
    [ ! -d "${build_dir}/copy/dir2" ]
    [ -f "${build_dir}/copy/file0" ]
    rm -rf "${build_dir}/copy"

  test "testing pattern glob"
    /bin/echo "dir2/**" > "${build_dir}/.gigalixir/releases/includes.txt"

    copy_static_files "${build_dir}/copy" > /dev/null

    [ ! -d "${build_dir}/copy/dir1" ]
    [ -f "${build_dir}/copy/dir2/file2" ]
    [ -f "${build_dir}/copy/dir2/dir3/file3" ]
    [ ! -f "${build_dir}/copy/file0" ]
    rm -rf "${build_dir}/copy/dir2"

  test "testing pattern match"
    /bin/echo "dir2/*" > "${build_dir}/.gigalixir/releases/includes.txt"

    copy_static_files "${build_dir}/copy" > /dev/null

    [ ! -d "${build_dir}/copy/dir1" ]
    [ -f "${build_dir}/copy/dir2/file2" ]
    [ ! -d "${build_dir}/copy/dir2/dir3" ]
    [ ! -f "${build_dir}/copy/file0" ]

  test "does not overwrite files"
    /bin/echo "asdf" > "${build_dir}/dir2/file2"

    copy_static_files "${build_dir}/copy" > /dev/null

    grep -q "asdf" "${build_dir}/copy/dir2/file2" && false



PASSED_ALL_TESTS=true
