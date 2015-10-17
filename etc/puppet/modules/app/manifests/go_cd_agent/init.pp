class app::go_cd_agent::init (
    $docker,
    $app
) {
    $config = $docker['go_cd']['agent']
    $dir = $config['data_dir']

    class { app::go_cd_agent::config:
        config => $config,
    }

    docker::run { $config['container_name']:
        image           => 'gocd/gocd-agent',
        env             => [
            "GO_SERVER=${docker[go_cd][server][host]}",
            "AGENT_KEY=${docker[go_cd][agent_key]}"
        ],
        volumes         => [
            "$dir/agent/lib:/var/lib/go-agent",
            "$dir/agent/log:/var/log/go-agent",
        ],
    }

    Class['app::go_cd_agent::config'] -> Docker::Run[$config['container_name']]
}