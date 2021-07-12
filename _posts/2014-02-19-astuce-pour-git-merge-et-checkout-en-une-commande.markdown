---
layout: post
title: "Astuce pour Git - merge et checkout en une commande"
date: 2014-02-19 20:49
legacy: true
tags: [git, astuce, intermédiaire, bash]
---



Aujourd'hui, je vous présente un petit script pour Git. Il vous permettra,
en une commande, de merger la branche courante dans `master` et de vous
retrouver sur `master`.

<!-- more -->

Ce script, `merge-me`, est a placer quelquepart dans votre `$PATH`.
N'oubliez pas de lui fournir les droits d'exécution (`chmod +x`).

{% highlight bash %}
#!/bin/bash

BRANCH_TO_MERGE=`git rev-parse --abbrev-ref HEAD`
git checkout master
git merge $BRANCH_TO_MERGE
{% endhighlight %}

Une fois installé, en partant d'une branche `ma-branche`, vous tapez:

    git merge-me

et la branche `ma-branche` sera mergée dans la branche `master`.

N'hésitez pas à vous en servir comme d'un point de départ et à le modifier,
à lui ajouter des fonctionnalités.

Tiens, d'ailleurs ! Vous y ajouteriez quoi ?



À demain.




