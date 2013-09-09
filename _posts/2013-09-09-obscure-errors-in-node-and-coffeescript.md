---
layout: blog
category: blog
title: How not to hunt down bugs in Node.js and CoffeeScript
disqus_identifier: hunt-bugs-in-node
---

I have a node application where the structure is as follows:

    app.coffee -> routes -> controller -> service -> redis

Somewhere in my service layer, I had a bug like this:

{% highlight coffeescript %}
if err?
    callback err
else if uid?
    user =
        uid: uid
        username: username
        callback null, user  # <- indentation is wrong
else
    callback null, null
{% endhighlight %}

See that callback call on line 7? It's indented one tab more than it should.
And here is what I receive when I run my app:

    > coffee app.coffee
    app.coffee:15:24: error: unexpected TERMINATOR
    routes app
                           ^

The mentioned lines on `app.coffee` are like this:

    app.use app.router

    routes = require './conf/routes'
    routes app

It took me quite a long time and a lot of will power to find the cause. Again, the real bug is located 3 layer below the app.coffee, in service layer. But there is nothing on the error message mentioning the whereabouts, only that there is an `unexpected TERMINATOR` on `app.coffee` file.

So, what to do when you encounter such an error and you have no idea where to start from? Well, not what I did in the first place of course. I tried to hunt the location of the error by commenting out portions of code starting from app.coffee to way down on required modules. This is a very bad and probably an unfruitful exercise.

First of all, It's not by luck that I had introduced the bug when I deviated from TDD. For a while, I hadn't figured out how to manage to test these asynchronous I/O calls through layers and I wanted just to go on, so I started to run my app with `coffee app.coffee` and see what happens. If I had been doing TDD, I would have spotted the bug just when and where I introduced it.

The main problem here is `require` is a runtime mechanism. So even that my original bug was a syntax error, and you would expect coffee to catch and report it on the correct location, it doesn't do so.
It tells that the error is in `app.coffee`:

    > coffee app.coffee
    app.coffee:15:24: error: unexpected TERMINATOR
    routes app
                           ^
While in fact it's in a file indirectly `require`d from `app.coffee`. I don't know yet why it can't point to the correct file.

On the other hand, I employed [CoffeeLint](http://www.coffeelint.org/) in my [Gruntfile](http://gruntjs.com/). This is very helpful for both catching bugs and for style enforcements. Here is my CoffeeLint configuration in the Gruntfile:

{% highlight coffeescript %}
coffeelint:
  app: my_files.concat(my_test_files)
  options:
    max_line_length:
      value: 120
    no_empty_param_list:
      value: true
      level: 'error'
    no_implicit_braces:
      value: true
      level: 'error'
{% endhighlight %}

I haven't made my mind yet about the implicit parenthesis in CoffeeScript. While this seems quite elegant:

{% highlight coffeescript %}
it 'should reject user creation if a user with same username already registered', (done) ->
{% endhighlight %}

The fact that you have to put parenthesis to call a method without arguments introduces inconsistency in coding style. Plus you can not chain methods without parenthesis:

{% highlight coffeescript %}
myObj.foo       # this is a reference to foo method
myObj.foo()     # this is a call
myObj.foo arg1  # but this is a call also

# you have to put parenthesis for this to work:
res.writeHead(200).end 'Hello World!'

# which is the same thing as
res.writeHead(200).end('Hello World!')
{% endhighlight %}

As I said, I'm not favoring one to another, I'm still in the evaluation period (but a bit biased into parenthesis). The important part is that, if you're new to the syntax, you have to trust into your build system and have some built-in checks (such as CoffeeLint) before running your application.