package { 'git':
    ensure => present
}

$packages = hiera('extra_packages')
$ci_manager = hiera('ci_manager')

notify { 'extra_pkg':
    message => 'successfully setup extra packages'
}

package { $packages:
    before => Notify['extra_pkg'],
    ensure => present
}

host { 'ci_manager':
    name => $ci_manager['host'],
    ip   => $ci_manager['ip'],
    comment => 'Managed by Puppet'
}