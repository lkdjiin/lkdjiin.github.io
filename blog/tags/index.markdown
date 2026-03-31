---
layout: default
title: Tags
permalink: /blog/tags/
---

<div class="home">
  <h1 class="page-heading">Tags</h1>

  <ul class="tag-list">
    {%- for tag in site.tags -%}
      <li>
        <a href="{{ tag[0] | tag_url }}">{{ tag[0] }}</a>
        <span class="post-meta">({{ tag[1].size }})</span>
      </li>
    {%- endfor -%}
  </ul>
</div>
