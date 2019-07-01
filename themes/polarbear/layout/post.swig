{% extends "_layout.swig" %}
{% import '_macro/post.swig' as post_template %}

{% block title %} {{ page.title }} - {{ config.title }} {% endblock %}

{% block content %}
    {% include "_plugins/adsense.swig" %}
    <div id="primary">
        {{ post_template.render(page) }}
    </div>
{% endblock %}
