class app::compose::init (
    $docker = hiera('docker'),
    $app = hiera('application'),
) {
    $config = $docker['compose']

    if $config['enabled'] == true {
        class { app::compose::config:
            config => $config,
            docker => $docker,
        }
    }
}