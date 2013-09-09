---
layout: blog
category: blog
title: Multiple Dispatching -and why you should care as a Java developer
---

I recently came across Multiple Dispatching concept on our local developer [meetup](http://www.meetup.com/Istanbul-Hackers/). When I started to investigate it further, I couldn't help but get overwhelmed by the number of articles, studies and papers about the subject. So I decided to explain it as simple as possible.

Most of us are familiar with the overriding mechanism which is an important part of Polymorphism. So if `A extends B`, it shouldn't surprise you when 


First of all, a small test:

{% highlight java %}
public class DynamicDispatch {
    public void dispatch (A a) {
        System.out.println("dispatch(A a) called");
        a.print();
    }
    public void dispatch (B b) {
        System.out.println("dispatch(B b) called");
        b.print();
    }

    public static void main(String[] args) {
        DynamicDispatch ds = new DynamicDispatch();
        A b = new B();
        ds.dispatch(b);
    }
}

class A { public void print() {System.out.println("I'm A");} }

class B extends A { public void print() {System.out.println("I'm B");} }
{% endhighlight %}

What would you expect as a result of the `main()` method? If your (wrong) answer is:
    dispatch(B b) called
    I'm B
then welcome to -the lack of, Multi Dispatching in Java.

