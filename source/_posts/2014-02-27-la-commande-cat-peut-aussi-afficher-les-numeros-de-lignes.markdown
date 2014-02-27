---
layout: post
title: "La commande cat peut aussi afficher les numéros de lignes"
date: 2014-02-27 20:48
comments: true
categories: [débutant, linux, terminal, cat]
---

{% level 1 %}

Je crois bien que je n'avais jamais regardé la documentation de la commande
unix `cat` jusqu'à il y a quelques jours. Je viens donc tout juste
d'apprendre qu'on pouvait afficher les numéros de lignes.

<!-- more -->

Afficher un fichier avec `cat`:

``` bash
$ cat exemple
Je suis
un fichier
exemple.
```

Afficher avec les numéros de ligne:

``` bash
$ cat -n exemple
     1	Je suis
     2	un fichier
     3	exemple.
```

Voilà, ça peut servir de temps en temps…

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

