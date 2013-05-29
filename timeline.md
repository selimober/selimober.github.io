---
layout: posts
posts_title: Timeline
subtitle: (i.e. what i'm up to lately)
---

<ul class="posts unstyled">
	{% for post in site.posts %}
	{% if post.categories contains 'timeline' %}
		<li>
			<div class="row">
				<div class="span1">
					<span>{{ post.date | date: "%d.%m.%Y" }}</span>
				</div>
				<div class="span6">
					<a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a>
					{% if post.categories contains 'book' %}
						<img src="/assets/img/books-icon.png" alt="book" class="img-book" />
					{% endif %}	
					{% if post.emotion contains 'straigh' %}
						<img src="/assets/img/emoticon_straight_face.png" alt="straight face" class="img-book" />
					{% endif %}
					{% if post.summary %}
						<br/>{{ post.summary }}
					{% endif%}
				</div>
			</div>
		</li>
	{% endif %}
{% endfor %}
</ul>		
