---
layout: post
title: "Affichage de toutes les tâches rake"
date: 2014-06-25 20:54
comments: true
categories: [débutant, ruby, rake, astuce]
---

{% level 1 %}

Hier je parlais des switchs `-T` et `-D` de l'executable `rake` pour
obtenir la liste des tâches, respectivement tronquées ou détaillées.

Aujourd'hui, pour ceux qui aurait la flemme de lire la sortie de
`rake --help`, c'est comment les obtenir **toutes**, car il y en a souvent
plus que l'on croit ;)

<!-- more -->

En effet, les switchs `-T` et `-D` n'affichent que les tâches possédant
une description. Et quand on débarque sur un projet Rails, ou Ruby, il
n'est pas rare qu'une petite armée de développeurs soient passés avant
vous en ajoutant plusieurs tâches bien utiles, mais sans description.

Pour en avoir la liste sans avoir à lire les nombreux fichiers `*.rake`,
il vous suffit d'utiliser le switch `--all`:

    $ rake --all -T

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
