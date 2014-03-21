---
layout: post
title: "Redis - Comment supprimer un ensemble de clés"
date: 2014-03-21 21:44
comments: true
categories: [redis, intermédiaire, base de données, bash]
---

{% level 2 %}

Tiens, mon premier article sur Redis ! Normal, c'est une technologie que
j'ai découvert il y a peu…

<!-- more -->

Pour supprimer une clé dans Redis, on se connecte et on utilise la commande
`del`:

    $ redis-cli
    > del "nom:de:la:clef"

Mais quand on a des dizaines/centaines de clés, bof… Bien souvent (toujours
même ça vaut mieux) le nom des clés suit un motif. Par exemple:

    "motif:foo"
    "motif:bar"
    "motif:baz"
    etc...

Dans ce cas on peut utiliser Bash pour s'en sortir rapidement:

``` bash
redis-cli keys "*motif*" | xargs redis-cli del
```

Et voilà, au revoir toutes les clés.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}


