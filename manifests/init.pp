class dotfiles(
  $user = 'romain'
) inherits dotfiles::params {
  include epel
  require nodejs

  Class['epel'] -> Class['nodejs']

  # standard packages
  package { "strace": ensure => "latest" }
  package { "sudo":   ensure => "latest" }
  package { "git":   ensure => "latest" }
  package { $dotfiles::params::vim_pkg:   ensure => "latest" }

  # ensure user is present
  user { $user:
    ensure => present
  } ->

  file { $dotfiles::params::home_dir:
    ensure => 'directory',
  } ->

  # ensure dotfiles are present
  vcsrepo { $dotfiles::params::home_dir:
    ensure   => present,
    provider => git,
    source => 'https://github.com/Filirom1/dotfiles.git',
  } ->

  # ensure vundle is installed
  file { [$dotfiles::params::vim_dir, $dotfiles::params::bundle_dir]:
    ensure => 'directory',
  } ->

  vcsrepo { "$dotfiles::params::vundle_dir":
    ensure   => present,
    provider => git,
    source => 'https://github.com/gmarik/Vundle.git',
  } ->

  exec { 'BundleInstall':
    command => "sudo ${romain} vim +PluginInstall +qall",
    refreshonly => true,
    path => $::path,
  }


  # install jsontool
  case $::osfamily {
    'Archlinux': {
      package { "jsontool": ensure => "latest" }
    }
    default: {
      package { "jsontool": ensure => "latest", provider => 'npm' }
    }
  }

}
