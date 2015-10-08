class app::db::config (
    $config
) {
    $dir = $config['data_dir']

    exec { "mkdir -p $dir/lib":
        path => '/bin',
        creates => "$dir/lib"
    }

    exec { "mkdir -p $dir/conf.d":
        path => '/bin',
        creates => "$dir/conf.d"
    }
}