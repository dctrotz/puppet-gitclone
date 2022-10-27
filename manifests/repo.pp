# == Defined Type: gitclone::repo
#
# Type to define git repository to clone/update.
#
# === Parameters
#
# The following parameters are required:
#
# [source]
#   Repository to clone from. Any git supported URI should work.
#   E.G.: https://github.com/justinjl6/puppet-gitclone/.git
#
# [destination]
#   Local directory to clone to. Must be empty (or doesn't yet exist) for
#   initial clone to work.
#   E.G.: /etc/puppet/modules/gitclone
#
# [owner]
#   Username or UID to chown destination to after git clone/pull.
#
# [group]
#   Group or GID to change destination to after git clone/pull.
#
#
# The following parameters are optional:
#
# [depth]
#   Clone last x revisions. Valid values are integers or 'all'.
#   Default value: 'all'
#
# [branch]
#   Git branch to checkout after clone.
#   Default value: 'master'
#
# [update]
#   Interval to periodically update cloned repository via git pull.
#   Valid values are 'hourly','daily','weekly','monthly','never'
#   Default value: 'never'
#
# === Examples
#
#  gitclone::repo { 'gitclone' :
#    source         => 'https://github.com/justinjl6/puppet-gitclone/.git',
#    destination    => '/etc/puppet/modules/gitclone',
#    owner          => 'puppet',
#    group          => 'puppet',
#    depth          => 1,
#    branch         => 'master',
#    update         => 'weekly',
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
define gitclone::repo (
    $source,
    $destination,
    $owner,
    $group,
    $depth  = 'all',
    $branch = 'master',
    $update = 'never',
) {

    ############################################################
    # Generate git arguments

    $git_args = '--quiet'
    if ( $depth != 'all' ) { $depth_arg = "--depth=${depth}" }


    ############################################################
    # Define Update schedule

    case $update {
        'hourly','daily','weekly','monthly':    {
            schedule { "gitclone::repository update - ${title}" :
                period  => $update,
            }
        }
        'never',false:  {
            schedule { "gitclone::repository update - ${title}" :
                period  => 'never',
            }
        }
        default:    {
            $error = "Invalid update interval (${update})."
            fail ( $error )
        }
    }

            
    ############################################################
    # Validate destination path and start running commands

    if is_absolute_path( $destination ) {

        # Create parent directories
        $dirname = dirname($destination)
        exec { "gitclone::repository mkdir-parents - ${title}" :
            command => "mkdir -p ${dirname}",
            path    => '/usr/bin:/bin',
            creates => $dirname,
        }

        # perform git clone
        exec { "gitclone::repository git-clone - ${title}" :
            command => "git clone ${git_args} ${depth_arg} --branch ${branch} ${source} ${destination}",
            path    => '/usr/bin:/bin',
            creates => "${destination}/.git",
            notify  => Exec["gitclone::repository chown - ${title}"],
        }

        # perform git pull as per update schedule
        exec { "gitclone::repository git-pull - ${title}" :
            command  => "git pull ${git_args}",
            path     => '/usr/bin:/bin',
            cwd      => $destination,
            onlyif   => "test -d ${destination}/.git",
            schedule => "gitclone::repository update - ${title}",
            notify   => Exec["gitclone::repository chown - ${title}"],
        }

        # chown cloned/updated repository
        exec { "gitclone::repository chown - ${title}" :
            command     => "chown -R ${owner}:${group} ${destination}",
            path        => '/usr/bin:/bin',
            refreshonly => true,
        }

    } else {
        $error = "Invalid destination (${destination}). Must be absolute path."
        fail ( $error )
    }


    ############################################################

}

################################################################################
################################################################################
