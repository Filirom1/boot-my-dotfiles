node default {
  include nodejs
  $user='romain'

  # standard packages
  package { "strace": ensure => "latest" }
  package { "sudo":   ensure => "latest" }
  package { "git":   ensure => "latest" }

  # os specific packages
  case $::osfamily {
     'Archlinux': {
       package { "gvim": ensure => "latest" }
     }
     'redhat': {
       package { "vim-enhanced": ensure => "latest" }
     }
     'debian': {
       package { "vim-gnome": ensure => "latest" }
     }
     default: {
       fail("${::operatingsystem} not supported.")
     }
  }

  # ensure user is present
  user { "${user}":
    ensure => present,
    managehome => true,
  }

  # ensure dotfiles are present
  $home_dir="/home/${user}"
  vcsrepo { "${home_dir}/":
    ensure   => present,
    provider => git,
    source => 'https://github.com/Filirom1/dotfiles.vim',
  }

  # ensure vundle is installed
  $vim_dir = "${home_dir}/.vim"
  $bundle_dir = "${vim_dir}/bundle"
  $vundle_dir = "${bundle_dir}/Vundle.vim"
  file { [$vim_dir, $bundle_dir]:
    ensure => 'directory',
  } ->
  vcsrepo { "$vundle_dir":
    ensure   => present,
    provider => git,
    source => 'https://github.com/gmarik/Vundle.vim',
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
