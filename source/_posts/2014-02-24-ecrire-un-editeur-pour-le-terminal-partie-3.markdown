---
layout: post
title: "Écrire un éditeur pour le terminal - partie 3"
date: 2014-02-24 20:59
comments: true
categories: [ruby, curses, ncurses, intermédiaire, terminal]
---

{% level 2 %}

Comment connaitre le nombre de lignes et de colonnes du terminal ?
Voici la réponse…

<!-- more -->

Le programme suivant utilise les méthodes `cols` et `lines` de la
bibliothèque `Curses` pour avoir ces informations:

``` ruby
require 'curses'
include Curses

begin
  init_screen
  addstr("#{cols} x #{lines}")
  getch
ensure
  close_screen
end
```

Redimensionnez votre terminal et relancez le programme pour être sûr
que ça fonctionne ;)

Ces informations nous seront bien utiles pour l'écriture d'un éditeur…


<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
