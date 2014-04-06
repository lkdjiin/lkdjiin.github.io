---
layout: post
title: "Comment réduire les erreurs de frappe dans la console"
date: 2014-04-06 20:52
comments: true
categories: [bash, débutant, alias]
---

{% level 1 %}

Régulièrement j'analyse mon fichier `~/.bash_history`.
Régulièrement ça veut dire 2 ou 3 fois par an. Et je regarde ce qui revient
le plus pour voir si je peux en transformer certaines en alias.
Quel rapport avec les fautes de frappe ?

<!-- more -->

La dernière fois que je l'ai regardé, ce fameux fichier `~/.bash_history`,
j'ai trouvé un nombre non négligeable de lignes qui débutaient par `gti`.
Et oui, j'écris souvent `gti` au lieu de `git` ! On a tous des petits
défauts de ce type, non ?

J'imagine que nombre d'entre vous ont déjà ce genre de choses dans
leur fichier `~/.bashrc` (ou `~/.bash_profile`), mais pour ceux qui n'y
avait pas encore pensé, la solution consiste à faire un alias:

``` bash
alias gti='git'
```

Alors d'accord, le titre de cet article ment un peu ;) Ça ne réduit pas
mes fautes de frappes, mais ça les rend transparentes, c'est déjà très bien.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
