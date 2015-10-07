$packages = hiera('extra_packages')
$app = hiera('application')
$docker = hiera('docker')

package { $packages:
    ensure => present
}

host { 'go_cd_server':
    name => $docker['go_cd']['server']['host'],
    ip   => $docker['go_cd']['server']['ip'],
    comment => 'Managed by Puppet'
}

class { app:
}

class {'locales':
    default_locale  => 'en_US.UTF-8',
    locales => ['en_US.UTF-8 UTF-8', 'ru_UA.UTF-8 UTF-8'],
}

class { 'timezone':
    timezone => 'UTC',
}
