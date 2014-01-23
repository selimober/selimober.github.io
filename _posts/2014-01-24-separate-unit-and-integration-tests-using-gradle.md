---
layout: blog
category: blog
title: Separating unit and integration tests using Gradle
disqus_identifier: gradle_unit_integration
published: true
---

I prefer keeping unit and integration tests apart. Unit tests are meant to te be run often and fast. On the other hand, integration tests require most of the time some external dependencies, like a database, a web server, an LDAP server etc. Even if you're using a local, lightweight version (like an in-memory database instead of a full fledged Oracle RAC), it's still preferable to be able to run them separately for mainly three reasons:

1. Once integration tests starts to grow, they will eventually start to slow you down. On the long run, this will cause you to skip tests. Which we all know is a terrible thing to do.
1. Inherently to their nature, change rates are very different. While applying TDD, unit tests tend to change faster than integration test. It's good practice [[1]](#unclebob) to keep entities that change together in different packages.
1. Last but not least, there is generally no point in running integration tests if your unit tests are failing. Integration tests should depend on the correctness of unit tests. Considering TDD, your unit tests *should* fail most of the time. Thus, running integration tests together with unit tests will be unnecessary.

I recently switched to Gradle and spent quite sometime to figure out how to do this using Gradle. First, let me show the folder structure:

<img src="/assets/img/20140124/unit_integ.png" />

Unit and integration folders are the roots for their respective tests. The rest is in the `build.gradle` file. The first part:

{% highlight groovy %}
sourceSets {
    integration {
        java {
            srcDir 'src/test/integration'
        }
        compileClasspath += main.output + test.output
        runtimeClasspath += main.output + test.output
    }
    test {
        java {
            srcDir 'src/test/unit'
        }
    }
}
{% endhighlight %}

We need to tell Gradle our two source sets. We do this by creating a new one, `integration` and overriding an existing one `test`. The purpose is to run only unit tests by default. If you want to run your integration tests, you call it explicitly.

{% highlight bash %}
$ gradle integration
{% endhighlight %}

To do that integration task and configurations should be defined:

{% highlight groovy %}
configurations {
    integrationCompile.extendsFrom testCompile
    integrationRuntime.extendsFrom testRuntime
}

task integration(type: Test) {
    testClassesDir = sourceSets.integration.output.classesDir
    classpath = sourceSets.integration.runtimeClasspath
}
{% endhighlight %}

And voilà!

### Bonus material

I'm using Spring and Spring-Test, and employing Spring profiles heavily facilitates my workflow. I have this abstract base class for my integration tests:

{% highlight java %}
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/tx-context.xml"})
@Transactional
@ActiveProfiles("integration")
public abstract class AbstractIntegrationTest {
}
{% endhighlight %}

On `tx-context.xml` there are two profiles for defining the `datasource`. Thus, integration profile uses the embedded in-memory version of `hsqldb`, the `dev` profile use a persistent version of it:

{% highlight xml %}
<beans profile="dev">
    <bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
        <property name="driverClassName" value="org.hsqldb.jdbcDriver"/>
        <property name="url" value="jdbc:hsqldb:file:testdb;hsqldb.lock_file=false;shutdown=true"/>
        <property name="username" value="SA"/>
        <property name="password" value=""/>
    </bean>

    <jdbc:initialize-database>
        <jdbc:script location="classpath:data.sql"/>
    </jdbc:initialize-database>
</beans>

<beans profile="integration">
    <jdbc:embedded-database id="dataSource">
        <jdbc:script location="classpath:data.sql"/>
    </jdbc:embedded-database>
</beans>
{% endhighlight %}

---
<a name="unclebob"></a>[1] The Common Closure Principle in Bob Martin's article, [The Principles of OOD](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod)