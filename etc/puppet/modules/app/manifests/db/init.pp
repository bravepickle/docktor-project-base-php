class app::db::init (
    $docker = hiera('docker'),
    $app = hiera('application')
) {
    $config = $docker['db']
    $dir = $config['data_dir']

    class { app::db::config:
        config => $config,
        app => $app,
    }

#    docker run --name some-percona -v /my/custom:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=my-secret-pw -d percona:tag

#    docker::image {'db_server':
#        image => 'docktor-ci-manager:5000/percona',
#    }

    # TODO: fix permissions problems with mounting volumes
    docker::run { 'db_server':
        name            => $config['container_name'],
        image           => $config['image'],
        env             => [
            "MYSQL_ROOT_PASSWORD=${config[root_password]}",
            "MYSQL_DATABASE=${config[dbname]}",
            "MYSQL_USER=${config[user]}",
            "MYSQL_PASSWORD=${config[password]}",
        ],
#        volumes_from         => [
#            "$dir/lib:/var/lib/mysql",
##            "$dir/conf.d:/etc/mysql/conf.d",
#        ],
        volumes         => [
            "$dir/lib:/var/lib/mysql",
#            "$dir/conf.d:/etc/mysql/conf.d",
        ],
    }

    Class['app::db::config'] -> Docker::Run['db_server']
}