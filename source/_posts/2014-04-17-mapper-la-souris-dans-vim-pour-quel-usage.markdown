---
layout: post
title: "Mapper la souris dans Vim : pour quel usage ?"
date: 2014-04-17 21:10
comments: true
categories: [vim, intermédiaire]
---

{% level 2 %}

Suite à [un tweet de @VimLinks](https://twitter.com/VimLinks/status/456746951283720192)
j'ai (re)découvert aujourd'hui qu'on pouvait très bien mapper la souris dans
Vim.

<!-- more -->

Par exemple avec les mappings suivant:

``` vim
nmap <LeftMouse> gg
nmap <RightMouse> G
```

Le bouton gauche de la souris nous place au tout début du buffer, alors que le
bouton droit nous place à la fin.

J'y ai pensé un peu dans la journée mais je n'ai pas trouvé
un truc intéressant à faire faire à ma souris :(

Est-ce que vous auriez une idée ?

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

