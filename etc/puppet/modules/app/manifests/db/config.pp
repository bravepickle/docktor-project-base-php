class app::db::config (
    $config,
    $app,
) {
    $dir = $config['data_dir']

    exec { 'db_lib_dir':
        command => "mkdir -p $dir/lib",
        path => '/bin',
        creates => "$dir/lib",
    }

    file { 'db_lib_dir':
        path => "$dir/lib",
        ensure => directory,
        owner => $config['fs_user'],
        group => $config['fs_group_id'],
        mode => 775,
    }


    exec { 'db_conf_dir':
        command => "mkdir -p $dir/conf.d",
        path => '/bin',
        creates => "$dir/conf.d",
    }

    file { 'db_conf_dir':
        path => "$dir/conf.d",
        ensure => directory,
        owner => $config['fs_user'],
        group => $config['fs_group_id'],
        mode => 775,
    }

    exec { 'db_bin_dir':
        command => "mkdir -p $dir/conf.d",
        path => '/bin',
        creates => "$dir/conf.d",
    }

    file { 'db_bin_dir':
        path => "$dir/bin",
        ensure => directory,
        owner => $config['fs_user'],
        group => $config['fs_group_id'],
        mode => 775,
    }

    user { 'db':
        name => $config['fs_user'],
        ensure => present,
        uid => $config['fs_user_id'],
#        gid => $config['fs_group_id'],
        groups => $app['fs_user'],
        comment => 'User that should own volumes for DB server in Docker containers. Handled by Puppet',
    }

    group { 'db':
        name => $config['fs_group'],
        ensure => present,
        gid => $config['fs_group_id'],
    }

    Group['db'] -> User['db'] -> Exec['db_lib_dir'] -> File['db_lib_dir']
    Group['db'] -> User['db'] -> Exec['db_bin_dir'] -> File['db_bin_dir']
}