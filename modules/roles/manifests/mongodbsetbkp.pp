class roles::mongodbset {
#class { '::mongodb::server':
#    replset    => 'rsmain'
#  }
#  mongodb_replset{'rsmain':
#      members => ['master:27017', 'agent1:27017', 'agent2:27017' ],
#  }->
class {'::mongodb::globals':
  manage_package_repo => true,
}->
class {'::mongodb::server':
#smallfiles => true, 
   bind_ip    => ['0.0.0.0'],
    replset    => 'rsmain',
 #master  => true
   #replset        => 'rsmain',
   replset_members => ['master.example.com:27017', 'agent1.example.com:27017', 'agent2.example.com:27017'],
# replset_config => { 'rsmain' => { ensure  => present, members => ['master.example.com:27017', 'agent1.example.com:27017', 'agent2.example.com:27017']  }  }
 }->
class {'::mongodb::client': }
#mongodb_database { admin:
 # ensure   => present,
#  tries    => 10,
 # require  => Class['mongodb::server'],
#}->
#mongodb_user { cloudmi-admin:
  #name          => 'cloudmi-admin',
 # ensure        => present,
 # password_hash => mongodb_password('cloudmi-admin', 'cMiCloudMiAdmin'),
 # database      => admin,
 # roles         => ['readWrite', 'dbAdmin'],
 # tries         => 10,
#  require       => Class['mongodb::server'],
#}
#mongodb_replset { rsmain:
#  ensure  => present,
# members => ['master.example.com:27017', 'agent1.example.com:27017', 'agent2.example.com:27017']
#}
}
