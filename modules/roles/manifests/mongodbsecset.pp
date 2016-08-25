class roles::mongodbsecset {
class {'::mongodb::globals':
  manage_package_repo => true,
}->
class {'::mongodb::server':
bind_ip    => ['0.0.0.0'],
smallfiles => true,
replset    => 'rsmain',
 }->
class {'::mongodb::client':
}
}
