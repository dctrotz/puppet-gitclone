# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#

include gitclone

gitclone::repo { 'gitclone' :
    source         => 'https://github.com/justinjl6/puppet-base.git',
    destination    => '/tmp/justinjl-gitclone_test',
    owner          => 'nobody',
    group          => 'nogroup',
    depth          => 1,
    branch         => 'master',
    update         => 'never',
}

warning ( 'You may want to delete /tmp/justinjl-gitclone_test after test completes' )

