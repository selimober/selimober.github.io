---
layout: posts
posts_title: Blog posts
---

<ul class="posts unstyled">
	{% for post in site.posts %}
		{% if post.categories contains 'blog' %}
			<li><span class="post_date">{{ post.date | date_to_string }}</span>  <span class="date_sep">&raquo;</span>  <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
		{% endif %}
	{% endfor %}
</ul>		


