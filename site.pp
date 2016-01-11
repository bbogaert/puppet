group { 'web':
  ensure => 'present',
  gid    => '1002',
}
user { 'bbogaert':
  ensure           => 'present',
  home             => '/home/bbogaert',
  password         => '!',
  password_max_age => '99999',
  password_min_age => '0',
  uid              => '1001',
  comment       => 'Byron Bogaert',
  groups        => 'web',
}
node default {
	include git
	class { 'helloworld': }
	class { 'helloworld::motd': }
	class { 'ntp':
	servers => ['0.north-america.pool.ntp.org','1.north-america.pool.ntp.org','2.north-america.pool.ntp.org','3.north-america.pool.ntp.org']
	}
	class { 'sudo': }
	sudo::conf { 'web':
		content	=> "web ALL=(ALL) NOPASSWD: ALL",
	}
	class { 'privileges': }
	sudo::conf { 'bbogaert':
		priority => 60,
		content	=> "bbogaert ALL=(ALL) NOPASSWD: ALL",
	}
}
node 'elmerfudd' {
	class {'samba::server':
		workgroup	=> 'wikimedia',
		server_string	=> 'server',
		security	=> 'user',
		log_level	=> 3,
		}
	samba::server::share {'Burners':
		comment	=> 'Burning Man',
		path	=> '/home/burners',
		guest_ok	=> true,
		guest_account	=> "guest",
		browsable	=> true,
		create_mask	=> 0755,

		}		
	}		
node 'icinga2' {
	class { 'icingaweb2':
		install_method => 'package',
		}
}
