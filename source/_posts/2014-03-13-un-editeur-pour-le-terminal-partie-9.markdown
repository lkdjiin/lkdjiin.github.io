---
layout: post
title: "Un éditeur pour le terminal - partie 9"
date: 2014-03-13 21:04
comments: true
categories: [ruby, curses, ncurses, intermédiaire, terminal]
---

{% level 2 %}

Dans le programme d'aujourd'hui, on s'occupe de déplacer le curseur.

<!-- more -->

``` ruby
require 'curses'
include Curses

begin
  init_screen
  cbreak
  noecho
  stdscr.keypad(true)
  x = 0
  y = 0

  while (ch = getch) != KEY_F1
    case ch
    when KEY_LEFT then x -= 1
    when KEY_RIGHT then x += 1
    when KEY_UP then y -= 1
    when KEY_DOWN then y += 1
    end
    setpos(y, x)
    refresh
  end
ensure
  close_screen
end
```

Les détails:

Pour éviter que les caractères s'affiche sur le terminal:

``` ruby
  noecho
```

Pour rappel, le code suivant permet d'activer le pavé numérique, les
flèches, etc.

``` ruby
  stdscr.keypad(true)
```

Positionner le curseur est aussi simple que ce qui suit. Comme toujours,
attention, c'est y d'abord et x ensuite:

``` ruby
    setpos(y, x)
```

Par contre, si vous jouer un peu avec ce programme, on voit que les
sauts de lignes ne sont pas gérer automatiquement (quand j'arrive à la
fin de la ligne et que j'appuie sur flèche droite, on ne passe pas à
la ligne suivante par exemple). Ce sera à nous de le gérer…

Si on veut utiliser HJKL (comme dans Vim) pour se déplacer, on peut
remplacer le contenu du `case` par:

``` ruby
    when ?h then x -= 1
    when ?l then x += 1
    when ?k then y -= 1
    when ?j then y += 1
```

Voilà.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

