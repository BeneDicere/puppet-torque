# Class: torque
#
# This module manages torque
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Do not use this class directly (use either server or client)
#
class torque(
  $server_name    = $::hostname,
  $manage_repo    = false,
  $package_source = 'hu-berlin',
  $torque_home    = '/var/spool/torque'
) {

  class {'torque::repo':
    manage_repo => $manage_repo,
  }

  file { $torque_home:
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { "${torque_home}/server_name":
    ensure  => 'present',
    content => template("${module_name}/server_name.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File[$torque_home]
  }

  if $torque_home != '/etc/torque' {
    file { '/etc/torque':
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    # is creating recursive links
    #file{ '/etc/torque/server_name':
    #  ensure  => link,
    #  replace => false,
    #  target  => "${torque_home}/server_name",
    #  require => [File['/etc/torque'], File["${torque_home}/server_name"]],
    #}

    exec { "create symbolic link":
        command => "/bin/ln -s ${torque_home}/server_name /etc/torque/server_name",
        unless  => '/usr/bin/test -f /etc/torque/server_name',
        creates => '/etc/torque/server_name'
    }

  }

}
