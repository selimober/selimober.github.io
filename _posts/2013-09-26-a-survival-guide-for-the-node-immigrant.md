---
layout: blog
category: blog
title: A survival guide for the Node immigrant
disqus_identifier: newcomer-guide-node
published: true
---

A while ago, I started looking into Node and shortly after, I became dazed by the plethora of frameworks surrounding it. I had been apart of Javascript development for a few years now and although I was well educated on the language, I hit a wall starting Node. Not because the framework was hard. On the contrary. It was very easy and flexible, a kind of flexibility that leaves you aspire for structure. I've experimented with different approaches, directory layouts, tools and I've tried to put them down here to help a newcomer to Node and Javascript development.

This article will not teach you Node or any other Javascript techniques. I believe a very specific kind of reader will most benefit from it. One who has a decent knowledge about programming in general, who read the basic concepts and tutorials about Node, and who is ready to try her first project, bigger than Hello World! I won't go into specific implementation details, or inner workings of some specific component. I aim to give an overall view of how a modern development environment using Node might be. Just keep in mind that these are the very first impressions of me on a vast land, and everything is subject to change :)

### The project

My experimental project to start Node was a Twitter clone in Redis. I was experimenting with Redis, and reading [antirez' article](http://redis.io/topics/twitter-clone) gave me the idea to the same but using Node.

A working implementation of the project can be seen [here](http://retwisn.selimober.com) and you can browse/clone the project from [github](https://github.com/selimober/retwisn).

<span class="disclaimer">[A note for the interested: Not long after I started this, I realized I had made two mistakes: Coffeescript and AngularJS. Not that they weren't any good. But I should have resisted my curiosity and keep new concepts to a minimum. I've struggled with unnecessary setup and bug hunting steps for Coffeescript, which I've blogged [here](http://selimober.com/blog/2013/09/09/obscure-errors-in-node-and-coffeescript/). For Angular, I was quite enthusiastic about trying it but it wasn't necessary for this project and I ended doing some weird things with it. It is a big and vast framework and better left alone if you're in the phase of learning other things.]</span>

### Table of Contents

* [Moving parts](#moving)
* [Folder structure](#folder)
* [Architecture & Dependencies](#arch)
* [Routes](#routes)
* [Mocha, the test runner](#mocha)
* [Grunt](#grunt)
* [Change a file](#change)
* [Deployment (and source control)](#deploy)
* [Conclusion and further exploration](#conclusion)

### <a id="moving"></a>Moving parts

Forget Node for a second. Just think of the parts you need to consider while building a dynamic website. The first logical separation is probably the server side and the frontend. Then you will have tests, for both sides, which will preferably run on every time you make a change to a file. You will have a development environment (local servers, etc) and from time to time you would deploy to production. Your production and development environment will have different settings. So you will want your code to adapt to these environments without intervention. And you would obviously automate these things as much as possible.

In the following sections, I will go on these parts and try to build a stable development environment where it's possible to focus only to the problems in hand instead of struggling (like I did) with infrastructure machinery.

### <a id="folder"></a>Folder structure

A high level view of my project folders is as follows:

    [retwisn]
    ├── [node_modules]
    ├── [src]
    │   ├── [app]
    │   │   ├── [common]
    │   │   ├── [home]
    │   │   ├── [post]
    │   │   ├── [user]
    │   │   ├── [views]
    │   │   └── app.coffee
    │   └── [web]
    │       ├── [css]
    │       └── [scripts]
    ├── [test]
    ├── [vendor]
    ├── [target]
    ├── [dist]
    ├── Gruntfile.coffee
    └── package.json

Coming from Java world, I started this project with the more common structure of model, view, controller and service folders. In this approach you divide your files per type. Your controllers go to the controller folder, your services go to the service folder, etc.

But what does this separation convey to the reader of your code? Maybe she would understand that I'm using a MVC pattern but so what? Instead of this, I've chosen a separation by feature. If we look to the `app` folder, we see components separated by what they are responsible from, not by how. The only exception is `views` folder where I had to put all my views, forming an organization per type, not feature. This was dictated by the view engine mechanism of the Express framework. There might be ways to overcome this but I didn't look further.

<span class="disclaimer">(If you would like to listen more about per type or per feature organization of modules, I recommend a very good talk by Uncle Bob: [Architecture, The Lost Years](http://www.youtube.com/watch?v=WpkDN78P884))</span>

Since I'm developing a Twitter clone, two most important entities of the domain is users and posts. Let's look inside the `post` folder to further elaborate:

    ├[post]
    ├── post-api.coffee
    ├── post-controller.coffee
    └── post-service.coffee

We have all the components for posting grouped here. Filenames tell clearly what they are. I decided not to use model entities for `User` or `Post`, since they were very simple, but if I would, this folder would have also contain a `post-model.coffee` file.

`common` folder contains other configuration files and common modules. One important member of this folder is `routes.coffee` which we will explore in the next section.

`web` folder is the container for static files. All your scripts, images, stylesheets and templates go here. It's where your frontend lives.

We'll see more about the `target` and `dist` on following sections but for now, `target` is automatically kept in sync with your `src` folder. It's where you run your local server. `dist` is the folder you build your project for deployment. In my case, I push to a remote repo for Heroku. Scripts in this folder should be compiled, minified, concatenated and whatever else you need to do for the latest version of your application to live in production.

### <a id="arch"></a>Architecture & Dependencies

A very simple architecture of this project is like this:

     -----       ------------------------------------------------       -------
    | Web | --> | App --> Middlewares --> Controller --> Service | --> | Redis |
     -----       ------------------------------------------------       -------

A request coming from web is accepted by the http server of Express and passes through different middlewares. One of them is the Router middleware. Router, by examining the request decides which controller should handle it and passes the request to the controller.

Controller, being in general a thin layer, asks from Service layer to do its business related jobs. In our sample application, this means reading from and writing to Redis. Once Redis answers, this goes all the way back. Everything in this scenario is in fact asynchronous. I won't go into the details about the asynchronous nature of Node. Every article you'll find on Node will probably start by explaining asynchronous callbacks and the Event Loop in Node.

On the other hand, you can see the diagram as a dependency hierarchy. Every component in the middle is dependent on the right one. Most importantly, Controller needs a Service to do its job, and Service needs Redis.

For testing purposes, it's extremely important that those dependencies shouldn't be hard coded. The basic rule is you are never to see `new` in your code. There are many techniques to break these dependency chains. I employed *constructor injection*. I have one single factory called `provider.coffee`. It's responsible of creating a Redis client, and services. The single other place where object creation happens is in the `routes.coffee`. It's where the request path / controller mapping happens.

`provider` is environment aware, so while running on localhost it looks for the Redis server with default settings, on the other hand, if in production, it gets the connection information from environment settings.

<span class="disclaimer">(For further reading on Dependency Injection, you can start with [Martin Fowler's article](http://martinfowler.com/articles/injection.html))</span>

### <a id="routes"></a>Routes

Let's see a small part of `routes.coffee` file:

{% highlight coffeescript %}
# USER
userController = new UserController provider.getUserService()
app.post  '/signup', userController.createUser
app.post  '/api/:followingUsername/follows/:followedUsername', userController.follow

userAPI = new UserAPI provider.getUserService()
app.post  '/api/isFollowing', userAPI.isFollowing
app.get   '/api/:username/followedBy', userAPI.followers
{% endhighlight %}

In any but extremely small projects, you'll have many routes to handle. Putting them in the main `app.coffee` becomes quickly a bit cumbersome. This is a handy way to separate route definitions to its own file, by passing the `app` reference to the exported function. This is also where you create your controllers, by passing services (asked from provider) to their constructors.

### <a id="mocha"></a>Mocha, the test runner

[Mocha](http://visionmedia.github.io/mocha/) is the test runner I've used for my tests. I'll only give some tips that I've found useful:

* consider `mocha.opts`  file, and especially `--require` option. It saves you from passing arguments and requiring frequently used frameworks, like Sinon.js. Here is mine:

{% highlight bash %}
--compilers coffee:coffee-script
--recursive
--reporter spec
--require sinon
--require should
{% endhighlight %}

* `done`, a callback for your asynchronous tests, accepts also an error. You can pass it directly to your async method, instead of calling it and asserting separately.

### <a id="grunt"></a>Grunt

Well, if I had to chose the single most important part of any Node project (or maybe any project at all), I would probably vote for the build system. This is more important than you might think in the first place, because:

* Extreme flexibility of Javascript requires instantaneous feedback about your progress. Or else you'll transgress. Lint, tests and other compile steps executed every time you change a file helps you in this prospect.
* If you use Coffeescript or other compilation steps with your styling or templates, it's better to leave your source tree clean, and use a separate folder (`target` in my case) for running your local server.
* Having an easy way of running the same steps every time you release helps more than you think, minimizing human errors.

I'll explain briefly my development workflow. While in development, I run grunt with default settings and let it run. Here is what it does for me:

- For the first run:
  * It cleans the target folder.
  * For every `.coffee` file in my source folder it runs `coffeelint` to check for errors and consistency problems.
  * It runs all unit tests, under `test` folder.
  * It compiles all `.coffee` files in `src` folder into the `target` folder with `sourceMaps`.
  * It copies every file from `vendor` folder into `target\web` and also every file in `src` (including `.coffee`, more on this later) to `target`.
  * It runs `watch` and `nodemon` tasks *in parallel*. Again, I'll cover the detail later on.
- Then, when I make an individual changes to a file:
  * `watch` kicks-in and executes the above steps again, but only for the changed file.
  * `liveReload` option of `watch` and `nodemon` reflect this change to your running server and to the browser.

I have another `dist` task which prepares the deployment package. No source maps, no coffee files, concatenated and minified files, etc. (Btw, I don't concatenate and minify my files in the example project, but I would, if this was a real project, and this would be the task to do it)

In conclusion, for any project which takes more then a day, I recommend a build system. And as far as I know, Grunt is the standard.

### <a id="change"></a>Change a file

What happens when you change a file depends on where and what type of file you change. Let's see for different types:

<dl>
  <dt>- <code>.coffee</code> files in <code>app</code> folder:</dt>
  <dd>This files are your application source files and if you change one, you would normally restart Node to see its effects. This is covered by both <code>watch</code> and <code>nodemon</code> tasks in my workflow. When <code>watch</code> detects a change in a <code>.coffee</code> file in <code>app</code> folder, it executes the necessary steps and copy the <code>coffee</code> , <code>map</code> and the resulting <code>js</code> to my <code>target</code> folder. <code>nodemon</code> watching this folder, restarts node.</dd>
  <br/>

  <dt>- <code>.coffee</code> files in <code>web</code> folder</dt>
  <dd>This files do not require a restart of the node server. But they require all the steps executed by <code>watch</code> task, and they end up copied in <code>target/web</code> . While optional, <code>liveReload</code> takes care of reflecting the changes to the browser without a reload of the page.</dd>
  <br/>

  <dt>- <code>.jade</code> files in <code>app</code> folder</dt>
  <dd>Being template files, they do not require restarting. We only copy them to target folder. It's not something that can be sent to the browser, thus <code>liveReload</code> do a refresh on the page.</dd>
  <br/>

  <dt>- other files in <code>web</code> folder</dt>
  <dd><code>watch</code> copies them to the <code>target</code> folder, and <code>liveReload</code> sends them to the browser causing an immediate change. (No refresh needed)</dd>
</dl>


### <a id="deploy"></a>Deployment (and source control)

I chose Heroku for hosting, so part of the deployment steps are somewhat specific to it.

#### The three `dist`s

I have a **branch**, a **folder** and a **task**, all called `dist`. This might be confusing explaining but comes handy when using them.

The `dist` folder is generated by my grunt's `dist` task. This folder is ignored by git in the **master branch**. I also ignore the root `/node_modules` folder. When I want to deploy to Heroku, I checkout the **dist branch**, and run `grunt dist`. This task creates the `dist` folder, and copies the `/node_modules` folder inside. Note that the `node_modules` in `dist` folder is not ignored. Then, I push the folder to the remote Heroku repo using `git subtree`:

    git subtree push --prefix dist heroku master

Subtree allows you to push only a part of your repository. There are two tricks to keep in mind, in **dist branch**, only the root `/node_modules` is ignored, the one inside `dist` folder is pushed along with the folder. This prevents a long `npm install` executed by Heroku every time you deploy your app. The second is the `dist` folder should be ignored in master branch. It shouldn't be part of your source code.


### <a id="conclusion"></a>Conclusion and further exploration

As I tried to stress in the beginning, this guide represents my opinions on how to structure a Node application. But since I just began the adventure, those opinions will probably change along the road. The project accompanying the post is by no means a finished product. While doing it, I stumbled on many other interesting stuff. I will most probably use them in my next project. So I suggest you to take a look to:

* [Yeoman](http://yeoman.io/):
<br/>
Its motto is "Modern Workflows for Modern Webapps". By directly copying from their site: "Our workflow is comprised of three tools for improving your productivity and satisfaction when building a web app: yo (the scaffolding tool), grunt (the build tool) and bower (for package management)."

* [Travis](https://travis-ci.org/):
<br/>
Nothing specific to Node or Javascript development. A Free Hosted continuous integration platform

* [Q](http://documentup.com/kriskowal/q/):
<br/>
Introduces `promises`, among others, a way to flatten the pyramid of async callbacks.

* [Winston](https://github.com/flatiron/winston):
<br/>
A multi-transport async logging library for node.js

Your feedback and suggestions is more than welcomed, so don't hesitate to drop a line.