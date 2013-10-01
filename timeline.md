---
layout: main
posts_title: Doing
subtitle: (i.e. what i'm up to lately)
---
<div class="content">
	<h1>Doing</h1>
	<ul class="listing list-unstyled">
		{% for post in site.posts %}
		{% if post.categories contains 'timeline' %}
			<li>
		  		<a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a> <br/>
					<span class="post-date">{{ post.date | date: "%B %e, %Y" }}</span>
	  			<span class="post-summary">{{ post.summary }}</span>
	  	</li>
		{% endif %}
	{% endfor %}
	</ul>
</div>
