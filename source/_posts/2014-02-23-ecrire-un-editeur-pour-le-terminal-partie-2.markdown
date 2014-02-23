---
layout: post
title: "Écrire un éditeur pour le terminal - partie 2"
date: 2014-02-23 16:33
comments: true
categories: [ruby, curses, ncurses, intermédiaire, terminal]
---

{% level 2 %}

Comme j'ai eu un peu trop de problêmes à faire tourner *ncurses* sur
plusieurs machines, j'ai décidé de repasser à *curses*.

<!-- more -->

Voici donc le programme de [la dernière fois](/blog/2014/02/22/ecrire-un-editeur-pour-le-terminal-partie-1/), réécrit pour *curses*:

``` ruby redvim.rb
#!/usr/bin/env ruby

require 'curses'
include Curses

file = File.open ARGV[0]

begin
  init_screen
  file.each {|line| addstr(line) }
  refresh
  getch
ensure
  close_screen
end
```

Un problème avec Unicode ?
--------

Il se peut que vous ayez des problèmes pour afficher correctement les
caractères unicode. À tous les coups, c'est parce que la gem *curses*
à été compilée sans les headers indispensables.
Installez donc ces headers: libncurses5.dev et libncurses5w.dev, ensuite
vous avez deux solutions:

1. Si vous utilisez Ruby 2.1, désinstallez *curses* et réinstallez la:
   `gem uninstall curses && gem install curses`.
2. Si vous utilisez Ruby 2.0 ou inférieur, *curses* fait partie de la
   bibliothèque standard, c'est donc Ruby qu'il faudra recompiler.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}


