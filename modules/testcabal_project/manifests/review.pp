# == Class: testcabal_project::review

# Current thinking on Gerrit tuning parameters:

# database.poolLimit:
# This limit must be several units higher than the total number of
# httpd and sshd threads as some request processing code paths may need
# multiple connections.
# database.poolLimit = 1 + max(sshd.threads,sshd.batchThreads)
#   + sshd.streamThreads + sshd.commandStartThreads
#   + httpd.acceptorThreads + httpd.maxThreads
# http://groups.google.com/group/repo-discuss/msg/4c2809310cd27255
# or "2x sshd.threads"
# http://groups.google.com/group/repo-discuss/msg/269024c966e05d6a

# container.heaplimit:
# core.packedgit*
# http://groups.google.com/group/repo-discuss/msg/269024c966e05d6a

# sshd.threads:
# http:
#  //groups.google.com/group/repo-discuss/browse_thread/thread/b91491c185295a71

# httpd.maxWait:
# 12:07 <@spearce> httpd.maxwait defaults to 5 minutes and is how long gerrit
#                  waits for an idle sshd.thread before aboring the http request
# 12:08 <@spearce> ironically
# 12:08 <@spearce> ProjectQosFilter passes this value as minutes
# 12:08 <@spearce> to a method that accepts milliseconds
# 12:09 <@spearce> so. you get 5 milliseconds before aborting
# thus, set it to 5000minutes until the bug is fixed.
class testcabal_project::review (
  $github_oauth_token = '',
  $github_project_username = '',
  $github_project_password = '',
  $mysql_password = '',
  $mysql_root_password = '',
  $email_private_key = '',
  $gerritbot_password = '',
  $ssl_cert_file_contents = '',
  $ssl_key_file_contents = '',
  $ssl_chain_file_contents = '',
  $ssh_dsa_key_contents = '',
  $ssh_dsa_pubkey_contents = '',
  $ssh_rsa_key_contents = '',
  $ssh_rsa_pubkey_contents='',
  $ssh_project_rsa_key_contents='',
  $ssh_project_rsa_pubkey_contents='',
  $lp_sync_key='', # If left empty puppet will not create file.
  $lp_sync_pubkey='', # If left empty puppet will not create file.
  $lp_sync_consumer_key='',
  $lp_sync_token='',
  $lp_sync_secret='',
  $contactstore_appsec='',
  $contactstore_pubkey='',
  $sysadmins = [],
  $swift_username = '',
  $swift_password = ''
) {
  class { 'testcabal_project::gerrit':
    ssl_cert_file                   =>
      '/etc/ssl/certs/review.testing-cabal.org.pem',
    ssl_key_file                    =>
      '/etc/ssl/private/review.testing-cabal.org.key',
    ssl_chain_file                  => '',
    ssl_cert_file_contents          => $ssl_cert_file_contents,
    ssl_key_file_contents           => $ssl_key_file_contents,
    ssl_chain_file_contents         => $ssl_chain_file_contents,
    ssh_dsa_key_contents            => $ssh_dsa_key_contents,
    ssh_dsa_pubkey_contents         => $ssh_dsa_pubkey_contents,
    ssh_rsa_key_contents            => $ssh_rsa_key_contents,
    ssh_rsa_pubkey_contents         => $ssh_rsa_pubkey_contents,
    ssh_project_rsa_key_contents    => $ssh_project_rsa_key_contents,
    ssh_project_rsa_pubkey_contents => $ssh_project_rsa_pubkey_contents,
    email                           => 'review@testing-cabal.org',
      # 1 + 100 + 9 + 2 + 2 + 25 = 139(rounded up)
    database_poollimit              => '150',
    container_heaplimit             => '8g',
    core_packedgitopenfiles         => '4096',
    core_packedgitlimit             => '400m',
    core_packedgitwindowsize        => '16k',
    sshd_threads                    => '100',
    httpd_maxwait                   => '5000min',
    war                             =>
      'http://tarballs.openstack.org/ci/gerrit-2.4.4-14-gab7f4c1.war',
    contactstore                    => false,
    contactstore_appsec             => $contactstore_appsec,
    contactstore_pubkey             => $contactstore_pubkey,
    contactstore_url                =>
      'http://www.openstack.org/verify/member/',
    script_user                     => 'launchpadsync',
    script_key_file                 => '/home/gerrit2/.ssh/launchpadsync_rsa',
    script_logging_conf             => '/home/gerrit2/.sync_logging.conf',
    projects_file                   =>
      'testcabal_project/review.projects.yaml.erb',
    github_username                 => 'rbtcollins',
    github_oauth_token              => $github_oauth_token,
    github_project_username         => $github_project_username,
    github_project_password         => $github_project_password,
    mysql_password                  => $mysql_password,
    mysql_root_password             => $mysql_root_password,
    trivial_rebase_role_id          =>
    'trivial-rebase@review.testing-cabal.org',
    email_private_key               => $email_private_key,
    sysadmins                       => $sysadmins,
    swift_username                  => $swift_username,
    swift_password                  => $swift_password,
    replication                     => [
      {
        name                 => 'github',
        url                  => 'git@github.com:',
        authGroup            => 'Anonymous Users',
        replicatePermissions => false,
        mirror               => true,
      },
      {
        name                 => 'local',
        url                  => 'file:///var/lib/git/',
        replicationDelay     => '0',
        threads              => '4',
        mirror               => true,
      },
    ],
  }

  include gerrit::remotes

  file { '/var/log/gerrit_user_sync':
    ensure  => directory,
    owner   => 'root',
    group   => 'gerrit2',
    mode    => '0775',
    require => User['gerrit2'],
  }
  file { '/home/gerrit2/.sync_logging.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'gerrit2',
    mode    => '0644',
    source  =>
      'puppet:///modules/openstack_project/gerrit/launchpad_sync_logging.conf',
    require => User['gerrit2'],
  }
  file { '/home/gerrit2/.ssh':
    ensure  => directory,
    owner   => 'gerrit2',
    group   => 'gerrit2',
    mode    => '0700',
    require => User['gerrit2'],
  }
  if $lp_sync_key != '' {
    file { '/home/gerrit2/.ssh/launchpadsync_rsa':
      ensure  => present,
      owner   => 'gerrit2',
      group   => 'gerrit2',
      mode    => '0600',
      content => $lp_sync_key,
      replace => true,
      require => User['gerrit2'],
    }
  }
  if $lp_sync_pubkey != '' {
    file { '/home/gerrit2/.ssh/launchpadsync_rsa.pub':
      ensure  => present,
      owner   => 'gerrit2',
      group   => 'gerrit2',
      mode    => '0644',
      content => $lp_sync_pubkey,
      replace => true,
      require => User['gerrit2'],
    }
  }
  file { '/home/gerrit2/.launchpadlib':
    ensure  => directory,
    owner   => 'gerrit2',
    group   => 'gerrit2',
    mode    => '0775',
    require => User['gerrit2'],
  }
  file { '/home/gerrit2/.launchpadlib/creds':
    ensure  => present,
    owner   => 'gerrit2',
    group   => 'gerrit2',
    mode    => '0600',
    content => template('openstack_project/gerrit_lp_creds.erb'),
    replace => true,
    require => User['gerrit2'],
  }
}
