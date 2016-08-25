class roles::mongodbpriset {
class {'::mongodb::globals':
  manage_package_repo => true,
}->
class {'::mongodb::client':
ensure => present
 }->
class {'::mongodb::server':
ensure => present,
smallfiles => true,
   bind_ip    => ['0.0.0.0'],
   replset    => 'rsmain',
   replset_members => ['agent1.example.com:27017', 'agent2.example.com:27017', 'agent3.example.com:27017'],
 # replset_config => { 'rsmain' => { ensure  => absent, members => ['agent1.example.com:27017', 'agent2.example.com:27017', 'agent3.example.com:27017']  }  }
 }->
mongodb_database { admin:
  ensure   => present,
  tries    => 10,
  require  => Class['mongodb::server'],
}->
mongodb_user { cloudmi-admin:
  name          => 'cloudmi-admin',
  ensure        => present,
  password_hash => mongodb_password('cloudmi-admin', 'cMiCloudMiAdmin'),
  database      => admin,
  roles         => ['readWrite', 'dbAdmin'],
  tries         => 10,
  require       => Class['mongodb::server'],
}
}
