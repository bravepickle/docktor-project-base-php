class app::compose::config (
    $config,
    $docker
) {
    $dir = $config['data_dir']

    exec { '_docker_compose_dir':
        command => "mkdir -p $dir",
        path => '/bin',
        creates => $dir
    }

    file { '_docker_compose':
        path   => "$dir/docker-compose.yml",
        ensure => present,
        content => template('app/docker-compose.yml.erb'),
    }

    Exec['_docker_compose_dir'] -> File['_docker_compose']
}