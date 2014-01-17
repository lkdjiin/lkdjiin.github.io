---
layout: post
title: "Raccourcis clavier pour le terminal"
date: 2014-01-17 21:06
comments: true
categories: [terminal, linux, os x, raccourcis, débutant]
---

{% level 1 %}

Aujourd'hui je parle des raccourcis clavier du terminal. Pas tous, il y
en a des tonnes, seulement ceux que j'utilise régulièrement.

<!-- more -->

Linux et OS X
-------------

Les raccourcis qui suivent fonctionnent aussi bien sous Linux et
OS X:

    Crtl-a   Aller en début de ligne
    Crtl-e   Aller en fin de ligne
    Crtl-k   Supprimer du curseur à la fin de la ligne
    Crtl-u   Supprimer avant le curseur
    Crtl-w   Supprimer le mot avant le curseur
    Crtl-t   Échanger les 2 caractères avant le curseur
    Esc-t    Échanger les 2 mots avant le curseur

Pour voir la liste de tous les mappings:

``` bash
bind -P
```

Linux seulement
---------------

    Shift-Ctrl-c  Copier le texte sélectionné
    Shift-Ctrl-v  Coller le texte

OS X seulement
--------------

    Meta-c        Copier le texte sélectionné
    Meta-v        Coller le texte

En bonus, voici un truc très pratique sous OS X, qu'un collègue
([@julienXX](https://twitter.com/julienXX)) m'a
montré la semaine dernière: Un triple clic sur une ligne la sélectionne en
entier, avec le caractère de fin de ligne mais sans le prompt. On peut ensuite
faire un copier/coller avec `Shift-Meta-v`, ce qui lance la commande
directement.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
