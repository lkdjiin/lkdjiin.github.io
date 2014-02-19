---
layout: post
title: "Astuce pour Git - merge et checkout en une commande"
date: 2014-02-19 20:49
comments: true
categories: [git, astuce, intermédiaire, bash]
---

{% level 2 %}

Aujourd'hui, je vous présente un petit script pour Git. Il vous permettra,
en une commande, de merger la branche courante dans `master` et de vous
retrouver sur `master`.

<!-- more -->

Ce script, `merge-me`, est a placer quelquepart dans votre `$PATH`.
N'oubliez pas de lui fournir les droits d'exécution (`chmod +x`).

``` bash merge-me
#!/bin/bash

BRANCH_TO_MERGE=`git rev-parse --abbrev-ref HEAD`
git checkout master
git merge $BRANCH_TO_MERGE
```

Une fois installé, en partant d'une branche `ma-branche`, vous tapez:

    git merge-me

et la branche `ma-branche` sera mergée dans la branche `master`.

N'hésitez pas à vous en servir comme d'un point de départ et à le modifier,
à lui ajouter des fonctionnalités.

Tiens, d'ailleurs ! Vous y ajouteriez quoi ?

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}


