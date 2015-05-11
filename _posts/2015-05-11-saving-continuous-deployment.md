---
layout: blog
category: blog
title: Saving Continuous Deployment
disqus_identifier: saving_continuous_deployment
published: true
---

Recently I found a picture I took 3 years ago. And fond memories of that forced me into writing this post. 

Below is my close friend and colleague, also the solution architect of the long term project we've been working on. It's Saturday, Maybe Sunday. We are in the middle of a _"real Continuous Deployment"_. More on that later. You can see the concentration and determination on my colleague, needed by any _"continuous deployer"_. Again more on that later.

<img class="full_width" src="/assets/img/20150511/mighty_continuous_deployer.jpg" />

Today, more than ever, we witness the convoluted and abused usage of the term Continuous Deployment. Just like _agile_ means whatever the person saying it thinks it means, Continuous Deployment morphed into a weird thing I'm not familiar with.

__Let me define how I understand Continuous Deployment:__

"Continuous Deployment is the process of following manual, prescribed steps in order to make a software system available to its intended users. It's typically a team effort of heroic scale, take long hours, preferably days where it can not be trusted to automation. It gets the name from the fact that the team is in the continuous state of deploying, thus Continuous Deployment. Sleep deprivation is one of the key requirements of the process. _Continuous Deployer_ is basically the one who deploy".

In this practice, the longer the steps to be taken, the better. If you refer to the picture above, every line you see on the glass wall is a task that needs to be completed __manually__. On that instance, we started the deployment Friday morning and finished at Sunday evening, just as planned. We deployed continuously, relentlessly, ferociously close to 60 hours. Now this is what I understand of a good ol' continuous deployment. Not these days' single click deploys.

I see many advantages of the practice I'm describing. In order to convey these easily, I've prepared my own manifesto of Continuous Deployment. 

So, __we value__:

1. __Creativity over consistency__

	Continuous Deployment these days allows you to deploy consistently the same way over and over again. Everyone knows doing same thing over and over is boring and god forbid, kills innovation.

	During the deployment I mentioned, we encountered a bug in one of the given jars. We didn't have the source code but decompiling jars and reading the code was the way to go. We saw the bug and the fix was very easy. The problem, because of the dependencies, it was impossible to compile the fix into the same jar. Now if I hadn't been sleep deprived, and it wasn't 3 am in the morning, downloading a bytecode editor, reading Java bytecode tutorials and editing the class file in bytecode would never occur to me. In continuous deployment creative solutions such as these are common.

2. __Stability over uncertainty__

	Just look one more time to the picture above. What is the feeling you get when you see the huge plan over the wall? Is it not something like "These folks put a huge amount of effort into planning this release, they certainly know what they are doing!"? Since this is not something you can prepare overnight and execute with one click, It gives you the assurance that whatever you've released it's there to stay. Like at least for 6 months. Now ain't it comforting?

3. __Panic zone over comfort zone__

	Everyone knows that you cannot grow in comfort zone. There are numerous scientific papers around it. I've used the scientific paper card so you must believe me. Panic zone is where individual growth happens. And in Continuous Deployment the way I described, you're always in the panic zone.

4. __Restricted environments over the freedom of running the application in any environment__

	Applications, specifically enterprise applications should be running in safe, controlled and hard to replicate environments. This has obviously the advantage of job security over those who run and maintain these systems. Today's Continuous Deployment zealots brag about the ability to run whole applications in a laptop through numerous virtualization or containerization solutions. That's nonsense. You should never run an enterprise application on a hardware that costs less then 5k$.

Now, I must admit my company and my colleagues are the first ones to blame. Martin Fowler himself committed to [this sin](http://www.martinfowler.com/bliki/ContinuousDelivery.html). We let the term become polluted and degenerate to what it means today. Rest assured though, I'm fighting internally for that we should stop this blasphemy and to publish my definition of Continuous Deployment on the next [Technology Radar](http://www.thoughtworks.com/radar). Some colleagues hint that this might cost my carrier but I'm determined to do what is right. 

I'll keep you updated about my progress. Till then, don't let your manual skills dominated by automation.