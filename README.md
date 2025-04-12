# Elixir Releases Buildpack

Buildpack for gigalixir app's that use Elixir Core releases.

For mix, see https://github.com/gigalixir/gigalixir-buildpack-mix

For distillery, see https://github.com/gigalixir/gigalixir-buildpack-distillery

To use this, see https://gigalixir.readthedocs.io/en/latest/modify-app/releases.html#specify-buildpacks-optional



## Features

* Easy configuration with `releases_buildpack.config` file 
* Easy configuration with `GIGALIXIR_RELEASES_BUILDPACK_CONFIG` environment variable.
* Support for umbrella app compilation through `app_relative_path` configuration.
* Support for adding files to the release through `.gigalixir/releases/includes.txt` file.



## Configuration

Create a `releases_buildpack.config` file in your app's root dir if you want to override the defaults.
The file's syntax is bash.

Alternatively add your config to `GIGALIXIR_RELEASES_BUILDPACK_CONFIG`.
For example:
```
gigalixir config:set GIGALIXIR_RELEASES_BUILDPACK_CONFIG='app_relative_path="./apps/my_umbrella"'
```

If you don't specify a configuration, then the defaults are loaded from the buildpack's
[`releases_buildpack.config`](/releases_buildpack.config) file.

Configuration options are applied in the following order:
1. [buildpack defaults](/releases_buildpack.config)
2. `distillery_buildpack.config` from your repo (for backwards compatibility)
3. `releases_buildpack.config` from your repo
4. `GIGALIXIR_RELEASES_BUILDPACK_CONFIG` environment variable



## Adding files to the release

To add files to the release, create a `.gigalixir/releases/includes.txt`.
The file follows the `rsync` --include-from syntax.

For example:
```
# include a specific file
/priv/ssl_certificate.pem

# include all files in a directory
/priv/dir/*

# include all files in a directory and its subdirectories
/priv/tree/**
```

Matching files will be available in the `/app` folder at runtime.
Empty directories will be pruned.



## Tests

Tests are available in the [test](test) directory.
To run all tests, use `for tst in test/*; do $tst; done`.
