# Boot my dotfiles

```
distro=centos_7_x

curl -s -L "https://raw.githubusercontent.com/Filirom1/puppet-bootstrap/master/$distro.sh" | sh
puppet module install puppetlabs/vcsrepo
puppet module install puppetlabs/nodejs

curl -s -L "https://github.com/Filirom1/boot-my-dotfiles/archive/master.tar.gz" | tar zx
puppet apply boot-my-dotfiles-master/manifests/init.pp 
```
