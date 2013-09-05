# == Class: testcabal_project::slave
#
class testcabal_project::slave (
  $bare = false,
  $certname = $::fqdn,
  $ssh_key = '',
  $sysadmins = [],
  $python3 = false,
  $include_pypy = false
) {
  include testcabal_project
  include openstack_project::tmpcleanup
  include testcabal_project::automatic_upgrades
  class { 'testcabal_project::server':
    iptables_public_tcp_ports => [],
    certname                  => $certname,
    sysadmins                 => $sysadmins,
  }
  class { 'jenkins::slave':
    bare         => $bare,
    ssh_key      => $ssh_key,
    python3      => $python3,
    include_pypy => $include_pypy,
  }
  class { 'salt':
    salt_master => 'ci-puppetmaster.testing-cabal.org',
  }
  include jenkins::cgroups
  include ulimit
  ulimit::conf { 'limit_jenkins_procs':
    limit_domain => 'jenkins',
    limit_type   => 'hard',
    limit_item   => 'nproc',
    limit_value  => '256'
  }
}
