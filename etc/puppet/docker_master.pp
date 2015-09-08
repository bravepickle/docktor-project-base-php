package {'git':
	ensure => present
}

$packages = hiera('extra_packages')

notify {'extra_pkg':
    message => 'successfully setup extra packages'
}

package { $packages:
    before => Notify['extra_pkg'],
	ensure => present
}