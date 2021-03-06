class app::nginx_php::init (
    $docker = hiera('docker'),
    $app = hiera('application')
) {
    $config = $docker['nginx_php']
    $db = $docker['db']
    $dir = $config['data_dir']

    class { app::nginx_php::config:
        config => $config,
        app => $app,
    }

    # TODO: fix permissions problems with mounting volumes
    docker::run { $config['container_name']:
        image           => $config['image'],
        links => [
            "${db[container_name]}:percona"
        ],
        ports => ["${config[port]}:80"],
        volumes         => [
            "$dir:/usr/share/nginx/html",
        ],
    }

    Class['app::nginx_php::config'] -> Docker::Run[$config['container_name']]
}