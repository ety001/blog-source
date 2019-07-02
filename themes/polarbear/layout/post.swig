{% extends "_layout.swig" %}
{% import '_macro/post.swig' as post_template %}

{% block title %} {{ page.title }} - {{ config.title }} {% endblock %}

{% block content %}
    <div id="primary">
        {% include "_plugins/adsense.swig" %}
        {{ post_template.render(page) }}
    </div>
{% endblock %}
