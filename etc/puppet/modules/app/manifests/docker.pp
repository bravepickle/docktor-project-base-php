class app::docker {
    $docker = hiera('docker')
    $app = hiera('application')

    $bin_dir = $app['bin_dir']
    $certs_dir = $app['certs_dir']
    $certs_conf_dir_target = "/etc/docker/certs.d/${docker[registry][host]}:${docker[registry][port]}"

    class { '::docker':
        socket_bind => "unix://${docker[socket]}",
    }

    exec { 'docker_certs_d':
        command => "/bin/mkdir -p '$certs_conf_dir_target'",
        creates => "$certs_conf_dir_target",
    }

    file { "registry_crt_conf_file":
        ensure  => file,
        source  => "$certs_dir/domain.crt",
        path    => "$certs_conf_dir_target/domain.crt",
    }

    Exec['docker_certs_d'] -> File['registry_crt_conf_file'] ~> Service['docker']

#    class { app::go_cd_agent::init:
#        docker => $docker,
#        app => $app,
#    }

    if $docker['registry']['insecure'] == true {
        file_line {'docker_registry_insecure':
            path => '/etc/default/docker',
            match => 'DOCKER_OPTS=',
            line => "DOCKER_OPTS=\"--insecure-registry ${docker[registry][host]}:${docker[registry][port]}\\",
        }
        # set order to overide defaults for docker run setup
        File["/etc/default/docker"] -> File_line['docker_registry_insecure'] ~> Service['docker']
        # overriding template for insecure TLS protocol registry handling
#        File <| title == "/etc/default/docker" |> {
#            content => template('app/etc/default/docker.erb'),
#        }
    }


    # TODO: setup sonar
#    class { app::sonar::init:
#        docker => $docker,
#        app => $app,
#    }
}
