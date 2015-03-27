exec { "set local":
  command => "echo 'LC_ALL=\"en_US.UTF-8\"' >> /etc/environment",
  path => "/bin"
} ->

# Update apt before installing any packages

exec { "apt-update":
  command => "/usr/bin/apt-get update",
} ->

package { "build-essential": ensure => "latest" } ->
package { "libreadline6-dev": ensure => "latest" } ->
package { "libssl-dev": ensure => "latest" } ->
package { "nodejs": ensure => "latest" } ->

vcsrepo { "/home/vagrant/dotfiles":
    ensure => present,
    provider => git,
    source => "https://github.com/selimober/dotfiles.git",
    user => 'vagrant'
} ->

vcsrepo { "/home/vagrant/.vim/bundle/Vundle.vim":
    ensure => present,
    provider => git,
    source => "https://github.com/gmarik/Vundle.vim.git",
    user => 'vagrant'
} ->

exec { "dotfiles":
  command => "/bin/cp -r /home/vagrant/dotfiles/vim/. /home/vagrant",
  user => 'vagrant'
} ->

exec { "vim plugins":
  environment => ["HOME=/home/vagrant"],
  command => "/usr/bin/vim +PluginInstall +qall",
  user => 'vagrant'
} -> 

class { 'rbenv':
    require => Exec['vim plugins']
}

rbenv::plugin { 'sstephenson/ruby-build': 
} ->

rbenv::build { '2.2.0': 
    global => true,
    env => ['RUBY_CONFIGURE_OPTS=--with-readline-dir="/usr/lib/x86_64-linux-gnu/libreadline.so"']
} ->

exec { "install github-pages":
  command => "/usr/local/rbenv/shims/bundle install",
  user => 'vagrant',
  cwd => '/vagrant'
}



