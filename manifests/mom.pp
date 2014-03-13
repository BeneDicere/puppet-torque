class torque::mom(
  $torque_server  = $torque::torque_server,
  $restricted     = [],
  $ideal_load_adj = 0.2,
  $max_load_adj   = 1.2,
  $options        = {
                      logevent => 255,
                    },
  $usecp          = [],
  $mom_prologue_file = undef,
  $mom_epilogue_file = undef,
) {

  # job execution engine for Torque batch system
  package { 'torque-mom':
    ensure => $mom_ensure,
  }

  file { '/etc/torque/mom':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/var/lib/torque/mom_priv':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/etc/torque/mom/config':
    ensure  => 'present',
    content => template('torque/pbs_config.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => [File['/etc/torque/mom'], Package['torque-mom']],
  }

  file { '/etc/torque/server_name':
    ensure  => 'present',
    content => template("torque/server_name.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['torque-mom'],
  }

  if ( $mom_prologue_file )  {
    file { '/var/lib/torque/mom_priv/prologue':
      ensure  => 'present',
      source  => $mom_prologue_file,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => [File['/var/lib/torque/mom_priv'], Package['torque-mom']],
    }
  }

  if ( $mom_epilogue_file )  {
    file { '/var/lib/torque/mom_priv/epilogue':
      ensure  => 'present',
      source  => $mom_epilogue_file,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => [File['/var/lib/torque/mom_priv'],Package['torque-mom']],
    }
  }
}