class roles::nginxset {
class { 'nginx':
	package_ensure => 'present',
 } 

nginx::resource::upstream { 'dls_api':
  members => [
    'master.example.com:7000',
    'agent2.example.com:7000',
  ],
}
nginx::resource::vhost { 'api.dls.com':
  proxy => 'http://dls_api',
} 

}
