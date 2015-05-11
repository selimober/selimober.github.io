Personal Blog
=============

Self contained vagrant box to simulate github pages environment for local development.

After cloning the project into a folder, `cd` to it, and:

    vagrant up
    vagrant ssh
    cd /vagrant
    bundle exec jekyll serve --watch --force_polling

You can access the site from [http://localhost:4000](http://localhost:4000)

_PS: first time `vagrant up` is executed, it takes quite a long time to complete. This is normal (767.87 seconds in my case). It compiles and install ruby2.2.0 and bundles all the gems reguired by github-pages_

_PS II: --force_polling is related to an issue described here: [Jekyll regeneration doesn't work inside Vagrant](http://stackoverflow.com/questions/19822319/jekyll-regeneration-doesnt-work-inside-vagrant)_

_PS III: Beware the problem of corrupted static files (js, css, ..). This is because of bug with virtualbox on shared folders: [I add a line of text to my CSS file, garbage comes through the browser](http://stackoverflow.com/questions/21422426/i-add-a-line-of-text-to-my-css-file-garbage-comes-through-the-browser) My only solution is to delete the file and recreate it._
