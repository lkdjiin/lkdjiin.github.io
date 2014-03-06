---
layout: post
title: "Un éditeur pour le terminal - partie 8"
date: 2014-03-06 20:59
comments: true
categories: [ruby, curses, ncurses, intermédiaire, terminal]
---

{% level 2 %}

Dans l'article d'aujourd'hui, on regarde comment utiliser la couleur.

<!-- more -->

``` ruby
require 'curses'
include Curses

begin
  init_screen
  unless has_colors?
    close_screen
    puts "Your terminal has no colors"
    exit 1
  end
  start_color
  init_pair(1, COLOR_RED, COLOR_BLACK)
  attron(color_pair(1))
  setpos(10, 10)
  addstr("In colors...")
  attroff(color_pair(1))
  refresh
  getch
ensure
  close_screen
end
```

On peut savoir si le terminal est capable d'afficher en couleur grâce à
`has_colors?`:

``` ruby
  unless has_colors?
```

Avant de pouvoir utiliser la couleur, il faut faire appel à `start_color`:

``` ruby
  start_color
```

On crée un «assemblage» de couleurs avec `init_pair`, en lui passant un
identifiant, auquel on pourra se référer plus tard, une couleur de premier
plan et une couleur d'arrière plan:

``` ruby
  init_pair(1, COLOR_RED, COLOR_BLACK)
```

On active un «assemblage» comme ceci:

``` ruby
  attron(color_pair(1))
```

Et on le désactive comme cela:

``` ruby
  attroff(color_pair(1))
```

Voilà.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

