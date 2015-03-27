Personal Blog
=============

Self contained vagrant box to simulate github pages environment for local development.

After cloning the project into a folder, `cd` to it, and:

    vagrant up
    vagrant ssh
    cd /vagrant
    bundle exec jekyll serve

You can access the site from [http://localhost:4000](http://localhost:4000)

_PS: first time `vagrant up` is executed, it takes quite a long time to complete. This is normal (767.87 seconds in my case). It compiles and install ruby2.2.0 and bundles all the gems reguired by github-pages_
