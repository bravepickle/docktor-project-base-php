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
        ports => ["${config[port]}:3306"],
        volumes         => [
            "$dir/lib:/var/lib/mysql",
            "$dir/conf.d:/etc/mysql/conf.d",
        ],
    }

    Class['app::db::config'] -> Docker::Run['db_server']
}