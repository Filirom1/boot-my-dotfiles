class dotfiles::params {
  # os specific packages
  case $::osfamily {
    'Archlinux': {
      $vim_pkg="gvim"
    }
    'redhat': {
      $vim_pkg="vim-enhanced"
    }
    'debian': {
      $vim_pkg="vim-gnome"
    }
    default: {
      fail("${::operatingsystem} not supported.")
    }
  }

  $home_dir="/home/${user}"
  $vim_dir = "${home_dir}/.vim"
  $bundle_dir = "${vim_dir}/bundle"
  $vundle_dir = "${bundle_dir}/Vundle.git"

}
