# == Class: gitclone
#
# Simple module to clone git repositoroes. Useful when you need to install
# software from git rather than apt/yum.
#
# Can also periodically update (git pull) repositories at scheduled intervals.
#
# === Parameters
#
# The following optional parameters are supported.
#
# [package_name]
#   Name of git package to install from apt/yum repositories.
#   Default value: 'git'
#
# [package_ensure]
#   Ensure value to pass to Puppet's Package type.
#   Default value: 'present'
# 
# === Examples
#
#  class { '::gitclone':
#    package_name   => 'git',
#    package_ensure => 'latest',
#  }
#
# === Authors
#
# Justin Lambe - https://github.com/justinjl6/
#
# === Copyright
#
# Copyright 2016 Justin Lambe
#
class gitclone (
    $package_manage = true,
    $package_name   = 'git',
    $package_ensure = 'present',
) {

    anchor { 'gitclone_begin' : } ->
    class { '::gitclone::package' :  } ->
    anchor { 'gitclone_end' : }

}
