---
layout: post
title: "La balise hr dans votre console"
date: 2014-05-01 16:46
comments: true
categories: [bash, débutant, application]
---

{% level 1 %}

Aujourd'hui je vais parler d'un programme rigoureusement inutile. Mais
totalement indispensable. J'ai nommé **hr**. Il va vous permettre
d'obtenir la magnifique ligne suivante dans votre console:

    $ hr
    ########################################################################
    $

<!-- more -->

Sans rire, je l'utilise régulièrement pour séparer visuellement les
commandes avec plein de texte en sortie.

Pour l'installer sur Linux:

    curl https://raw.githubusercontent.com/LuRsT/hr/master/hr > ~/bin/hr
    chmod +x ~/bin/hr

Sous OS X:

    brew install hr

Le [projet](https://github.com/LuRsT/hr) est sur Github, et si la version
Bash ne vous branche pas, **hr** existe aussi dans d'autres langages.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

