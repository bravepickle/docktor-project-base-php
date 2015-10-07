class app::nginx {

    class { ::nginx: }

    file { '_nginx_vhost':
        path   => '/etc/nginx/sites-enabled/default-vhost.conf',
        ensure => present,
        content => template('app/nginx-vhost.conf.erb'),
        notify => Service['nginx'],
    }
}
