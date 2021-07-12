---
layout: post
title: "Un éditeur pour le terminal - partie 8"
date: 2014-03-06 20:59
legacy: true
tags: [ruby, curses, ncurses, intermédiaire, terminal]
---



Dans l'article d'aujourd'hui, on regarde comment utiliser la couleur.

<!-- more -->

{% highlight ruby %}
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
{% endhighlight %}

On peut savoir si le terminal est capable d'afficher en couleur grâce à
`has_colors?`:

{% highlight ruby %}
  unless has_colors?
{% endhighlight %}

Avant de pouvoir utiliser la couleur, il faut faire appel à `start_color`:

{% highlight ruby %}
  start_color
{% endhighlight %}

On crée un «assemblage» de couleurs avec `init_pair`, en lui passant un
identifiant, auquel on pourra se référer plus tard, une couleur de premier
plan et une couleur d'arrière plan:

{% highlight ruby %}
  init_pair(1, COLOR_RED, COLOR_BLACK)
{% endhighlight %}

On active un «assemblage» comme ceci:

{% highlight ruby %}
  attron(color_pair(1))
{% endhighlight %}

Et on le désactive comme cela:

{% highlight ruby %}
  attroff(color_pair(1))
{% endhighlight %}

Voilà.



À demain.



