---
layout: post
title: "Vim - Comment ouvrir la fenêtre courante dans un nouvel onglet"
date: 2014-03-26 21:09
comments: true
categories: [vim, débutant, truc, astuce]
---

{% level 1 %}

Vous avez un écran bien large ? Vous travaillez régulierement avec 4 ou 5
fenêtres dans le même onglet, voir plus ?
Parfois vous aimeriez bien ouvrir rapidement une de ces fenêtres dans un
nouvel onglet ?

<!-- more -->

Alors ça va peut-être bien être l'article le plus court de l'histoire de ce
blog:

``` vim
:tab sp
```

Et la fenêtre courante s'ouvre dans un nouvel onglet (`sp` est l'abréviation
de `split`).

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

