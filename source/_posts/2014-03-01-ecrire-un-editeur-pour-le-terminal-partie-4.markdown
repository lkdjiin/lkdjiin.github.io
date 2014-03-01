---
layout: post
title: "Écrire un éditeur pour le terminal - partie 4"
date: 2014-03-01 17:47
comments: true
categories: [ruby, curses, ncurses, intermédiaire, terminal]
---

{% level 2 %}

Aujourd'hui on voit comment écrire un message centré horizontalement et
verticalement, comment lire une chaîne de caractères, et comment être
tranquille avec les caractères non ASCII.

<!-- more -->

Voici un programme qui montre tout ça:

``` ruby
require 'curses'
include Curses

message = "Enter a string: "

begin
  init_screen
  setpos(lines / 2, (cols - message.size) / 2)
  addstr(message)
  str = getstr
  setpos(lines - 2, 0)
  addstr(sprintf("You entered: %s", str))
  getch
ensure
  close_screen
end
```

Quelques brèves explications maintenant:

Tout d'abord, on affiche un message centré ainsi:

``` ruby
  setpos(lines / 2, (cols - message.size) / 2)
  addstr(message)
```

Pour lire une chaîne de caractères, on utilise `getstr`:

``` ruby
  str = getstr
```

Puis on affiche ce qu'on vient de lire sur l'avant-dernière ligne du
terminal:

``` ruby
  setpos(lines - 2, 0)
  addstr(sprintf("You entered: %s", str))
```

Le [sprintf](http://www.ruby-doc.org/core-2.1.1/Kernel.html#method-i-sprintf),
qui vous rappelera des choses si vous avez fait du C, est ce que j'ai
trouvé de mieux pour ne pas avoir de soucis avec les caractères
non ASCII.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

