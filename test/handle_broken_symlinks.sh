#!/usr/bin/env bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $SCRIPT_DIR/.test_support.sh

# include source file
source $SCRIPT_DIR/../lib/build.sh

# TESTS
######################
suite "delete_broken_symlinks"

  test_dir=$(mktemp -d)

  test "leaves good symlink"
    touch "$test_dir/real_file"
    ln -s "$test_dir/real_file" "$test_dir/symlink"

    delete_broken_symlinks "${test_dir}"

    [ -e "$test_dir/symlink" ]

  test "deletes broken symlink"
    rm "$test_dir/real_file"

    delete_broken_symlinks "${test_dir}"

    [ ! -e "$test_dir/symlink" ]



PASSED_ALL_TESTS=true
