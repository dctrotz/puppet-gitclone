# == Class: gitclone::package
#
# Class within gitclone module to handle installation of the git package from 
# systems local package source (apt/yum).
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
#  class { '::gitclone::package':
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
# Copyright 2016 Justin Lambe.
#
class gitclone::package (
    $package_manage = $::gitclone::package_manage,
    $package_name   = $::gitclone::package_name,
    $package_ensure = $::gitclone::package_ensure,
) {

    # Validating package_ensure value as git must be present
    case $package_ensure {

        # Valid values
        'present':      { }
        'installed':    { }
        'latest':       { }
        'held':         { }

        # 
        default:    {
            notify { "Git is required, however \$package_ensure = ${::gitclone::package_ensure}" : }
            warning ( "Git is required, however \$package_ensure = ${::gitclone::package_ensure}" )
        }

    }

    if ( $package_manage == true ) {
        unless defined ( Package[$package_name] ) {
            package { $package_name :
                ensure  => $package_ensure,
            }
        }
    }

}
