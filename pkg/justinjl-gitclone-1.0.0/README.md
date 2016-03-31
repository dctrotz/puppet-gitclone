# gitclone

## Overview

Puppet module to clone git repositoroes.

## Module Description

A simple module to clone git repositoroes. Useful when you need to install
software from git rather than apt/yum.

Can also periodically update (git pull) repositories at scheduled intervals.

## Setup

### What gitclone affects

* Installs git via system package manager.
* Optionally clones and updates git repositories when gitclone::repo type is
  called.

### Setup Requirements **OPTIONAL**

### Beginning with gitclone

The module can be included with default values:
```
include '::gitclone'
gitclone::repo { 'hellogitworld' :
    source      => 'https://github.com/githubtraining/hellogitworld.git',
    destination => '/tmp/hellogitworld',
    owner       => 'nobody',
    group       => 'nogroup',
}
```

## Usage

### Classes

The module can be included with default values as in the above example,  or
explicitly defined to override with custom parameters. The parameters and 
their defaults are listed below.
```
Class { '::gitclone' :
    package_manage  => true,
    package_name    => 'git',
    package_ensure  => 'present',
```
}

#### Parameters within `gitclone`:
* `package_manage`: Optional. Whether to install git package. Defaults to true.
  Setting to false will just assume git is installed.
* `package_name`: Optional. Name of git package to install. Defaults to 'git'.
* `package_ensure`: Optional. Ensure value to pass to Puppet's Package type.
  Value must be one of 'present','installed','latest','held'.
  Defaults to 'present'.

### Types

The gitclone::repo type is used to define the repository to clone/update.
```
gitclone::repo { 'hellogitworld' :
    source      => 'https://github.com/githubtraining/hellogitworld.git',
    destination => '/tmp/hellogitworld',
    owner       => 'nobody',
    group       => 'nogroup',
    depth       => 'all',
    branch      => 'master',
    update      => 'never',
}
```

#### Parameters within `gitclone::repo`:
* `source`: Required. URI of git repository to clone.
* `destination`: Required. Local directory to clone repository to.
* `owner`: Required. Username/UID to chown to after git clone/pull.
* `group`: Required. Group/GID to chown to after git clone/pull.
* `depth`: Optional. Only clone last x revistions. Defaults to 'all'.
* `branch`: Optional. Branch to checkout after clone.
* `update`: Optional. Update cloned repo via git pull every never, hourly,
   daily, weekly, monthly

## Reference

### Public classes

* `gitclone`: The main class to include this module.

### Private classes

* `gitclone::package`: Class to install git package.

### Types

* `gitclone::repo`: Type to clone/update a git repository.

## Limitations

This module has been made for (osfamily) Debian and RedHat (and their derivatives), however it should work fine on any 'nix so long as git is installed or installable.

## Development

Appreciate any suggestions on feature or code changes. Let me know if you want to contribute or collaborate.

