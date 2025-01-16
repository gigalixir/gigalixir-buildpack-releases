load_config() {
  output_section "Loading config..."

  local builpack_config_file="${build_pack_dir}/releases_buildpack.config"
  local custom_config_file="${build_dir}/releases_buildpack.config"
  local legacy_config_file="${build_dir}/distillery_buildpack.config"
  local dynamic_config_file="${cache_dir}/dynamic_releases_buildpack.config"

  source $builpack_config_file

  if [ -f $legacy_config_file ]; then
    source $legacy_config_file
  fi

  if [ -f $custom_config_file ]; then
    source $custom_config_file
  fi

  if [ ! -z "$GIGALIXIR_RELEASES_BUILDPACK_CONFIG" ]; then
    echo "$GIGALIXIR_RELEASES_BUILDPACK_CONFIG" > $dynamic_config_file
    source $dynamic_config_file
  elif [ -f $dynamic_config_file ]; then
    rm $dynamic_config_file
  fi

  output_line "* app relative path $app_relative_path"
}

# copied from HashNuke/HashNuke/heroku-buildpack-elixir
export_env_vars() {
  whitelist_regex=${2:-''}
  blacklist_regex=${3:-'^(PATH|GIT_DIR|CPATH|CPPATH|LD_PRELOAD|LIBRARY_PATH)$'}
  if [ -d "$env_path" ]; then
    output_section "Will export the following config vars:"
    for e in $(ls $env_path); do
      echo "$e" | grep -E "$whitelist_regex" | grep -vE "$blacklist_regex" &&
      export "$e=$(cat $env_path/$e)"
      :
    done
  fi
}

export_mix_env() {
  if [ -z "$MIX_ENV" ]; then
    if [ -d $env_path ] && [ -f $env_path/MIX_ENV ]; then
      export MIX_ENV=$(cat $env_path/MIX_ENV)
    else
      export MIX_ENV=${1:-prod}
    fi
  fi

  output_line "* MIX_ENV=${MIX_ENV}"
}

distillery_mix_release_command() {
  set +o errexit    # do not exit if there is an error
  mix help distillery.release >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "distillery.release"
  else
    echo "release"
  fi
  set -o errexit    # always exit on error
}

output_line() {
  local spacing="      "
  echo "${spacing} $1"
}

output_section() {
  local indentation="----->"
  echo "${indentation} $1"
}

delete_broken_symlinks() {
  find "$1" -xtype l -delete > /dev/null
}

copy_static_files() {
  local dst_dir="$1/"
  local includes_path="${build_dir}/.gigalixir/releases/includes.txt"

  if [ -f "${includes_path}" ]; then
    output_line ".gigalixir/releases/includes.txt file found"
    output_section "Copying files to include in the release"

    rsync -av \
      --include='*/' --include-from="${includes_path}" --exclude='*' \
      --prune-empty-dirs --ignore-existing \
      "${build_dir}/" "${dst_dir}"
  fi
}
