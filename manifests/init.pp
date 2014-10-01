node default {
  include nodejs

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

  package { "strace": ensure => "latest" }
  package { "sudo":   ensure => "latest" }
}
