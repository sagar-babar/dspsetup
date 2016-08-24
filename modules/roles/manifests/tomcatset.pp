class roles::tomcatset {
tomcat::install { '/usr/share/tomcat7':
	  source_url => 'http://mirror.fibergrid.in/apache/tomcat/tomcat-7/v7.0.70/bin/apache-tomcat-7.0.70.tar.gz',
}

tomcat::instance { 'default':
	  catalina_home => '/usr/share/tomcat7',
  	  user          => 'root',
          group         => 'root',
}->
file {'/usr/share/tomcat7/webapps':
	ensure => absent,
	force => true
}->
file {'/logs/tomcat':
	ensure => directory,
	force => true
}->
file { 'log-sym-link':
	path => '/usr/share/tomcat7/logs',
     	ensure => 'link',
     	target => '/logs/tomcat',
}  
}
