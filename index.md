---
layout: main
title: index
---
<div class="content">
  <h1>Writing</h1>
  <ul class="listing list-unstyled">
  	{% for post in site.posts %}
		{% if post.categories contains 'blog' %}
		<li>
			<span class="post-date">{{ post.date | date: "%B %e, %Y" }}</span>
  		<a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a>
  	</li>
		{% endif %}
  	{% endfor %}
  </ul>
</div>