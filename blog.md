---
layout: no_col
---


<div class="container">
	<div class="row">
		<div class="offset3 span6">
			<h1>Blog posts</h1>
			<ul class="posts unstyled">
				{% for post in site.posts %}
    			{% if post.categories contains 'blog' %}
        			<li><span>{{ post.date | date_to_string }}</span>  <span class="date_sep">&raquo;</span>  <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
    			{% endif %}
			{% endfor %}
			</ul>		
		</div>
	</div>
</div>

