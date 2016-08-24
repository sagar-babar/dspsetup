##Puppet modules for Nginx, MongoDB, Redis 

  ####Tested with Linux(Centos 6)

###Dependency

 * [Puppet](https://docs.puppet.com/puppet/) >= 3.6
 * [Puppet-Master](https://docs.puppet.com/puppetserver/latest/services_master_puppetserver.html)
 * [Puppet-Agent](https://docs.puppet.com/puppet/latest/reference/man/agent.html)


## Nginx Module

### Requirement:
* Nginx Load balancer with HA

**Prerequisite:**

* 2 Linux VM's for Nginx 
* 1 or 2 Linux VM for DLS(Data Lock Service) - Where traffic will be routed through Nginx.

**Module dependency**

* Nginx Module
* Role Module

###site.pp

We have simplified use of site.pp file using role moduele to segregate data from it. So, after using role module site.pp looks like:
<pre>
node 'nginx1.example.com' {
include roles::nginxset
}

node 'nginx2.example.com' {
include roles::nginxset
}
</pre>

All modifications to calling nginx as well as all other modules (e.g MongoDB, Redis etc.) will be applied through role module.

Below is the structure of Role module
<pre>

modules -> roles -> manifests ->
nginxset
mongodbset
redisset

</pre>


###nginxset.pp

<pre>

class roles::nginxset {
	class { 'nginx':
			package_ensure => 'present',
 	}

	nginx::resource::upstream { 'dls_api':
  		members => [
    		'dls1.example.com:80',
    		'dls2.example.com:80',
  			],
	}
	
	nginx::resource::vhost { 'api.dls.com':
  					proxy => 'http://dls_api',
	}
}

</pre>

**Description**

We can modify nginxset.pp anytime as per our need.

When we need to modify traffic to different nodes just need to modify below block from nginxset.pp

<pre>

	nginx::resource::upstream { 'dls_api':
  		members => [
    		'dls1.example.com:80',
    		'dls2.example.com:80',
  			],
	}

</pre>

we can change vhost entries by modifying below block 

<pre>

	nginx::resource::vhost { 'api.dls.com':
  					proxy => 'http://dls_api',
	}

</pre>



### Running Nginx Module

**Auotmatic**

By default all defined respective modules will be pulled automatically after every 30 minutes into particular node and apply regarding catlogs in the node.

**Manually**

Applying catlogs for respective node (e.g. nginxnode-1), we need to login into it and then we just need to hit below command using sudo access

<pre>

puppet agent -t

for debug mode:

puppet agent -t --debug

</pre>	



## MongoDB Module

### Requirement:
* MongoDB setup with 3 node cluster.

**Prerequisite:**

* 3 Linux VM's for MongoDB 

**Module dependency**

* MongoDB Module
* Role Module

###site.pp

<pre>

node 'mongo1.example.com' {
include roles::mongodbset
}

node 'mongo2.example.com' {
include roles::mongodbset
}

node 'mongo3.example.com' {
include roles::mongodbset
}

</pre>

###mongodbset.pp

<pre>

class roles::mongodbset {
class {'::mongodb::globals':
  manage_package_repo => true,
}->
class {'::mongodb::server':
ensure => absent,
smallfiles => true,
   bind_ip    => ['0.0.0.0'],
   replset    => 'rsmain',
   replset_config => { 'rsmain' => { ensure  => present, members => ['master:27017', 'agent1:27017', 'agent2:27017']  }  }
 }->
class {'::mongodb::client':
ensure => absent
}
mongodb_database { admin:
  ensure   => present,
  tries    => 10,
  require  => Class['mongodb::server'],
}->
mongodb_user { cloudmi-admin:
  name          => 'cloudmi-admin',
  ensure        => present,
  password_hash => mongodb_password('cloudmi-admin', 'XXXXXXXXXXXXXXXXXXXX'),
  database      => admin,
  roles         => ['readWrite', 'dbAdmin'],
  tries         => 10,
  require       => Class['mongodb::server'],
}
}

</pre>

### Running MongoDB Module

**Auotmatic**

By default all defined respective modules will be pulled automatically after every 30 minutes into particular node and apply regarding catlogs in the node.

**Manually**

Applying catlogs for respective node (e.g. mongo-1), we need to login into it and then we just need to hit below command using sudo access

<pre>

puppet agent -t

for debug mode:

puppet agent -t --debug

</pre# dspsetup
