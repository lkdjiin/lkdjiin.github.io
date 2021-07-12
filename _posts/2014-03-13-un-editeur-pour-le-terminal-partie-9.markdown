---
layout: post
title: "Un éditeur pour le terminal - partie 9"
date: 2014-03-13 21:04
legacy: true
tags: [ruby, curses, ncurses, intermédiaire, terminal]
---



Dans le programme d'aujourd'hui, on s'occupe de déplacer le curseur.

<!-- more -->

{% highlight ruby %}
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
{% endhighlight %}

Les détails:

Pour éviter que les caractères s'affiche sur le terminal:

{% highlight ruby %}
  noecho
{% endhighlight %}

Pour rappel, le code suivant permet d'activer le pavé numérique, les
flèches, etc.

{% highlight ruby %}
  stdscr.keypad(true)
{% endhighlight %}

Positionner le curseur est aussi simple que ce qui suit. Comme toujours,
attention, c'est y d'abord et x ensuite:

{% highlight ruby %}
    setpos(y, x)
{% endhighlight %}

Par contre, si vous jouer un peu avec ce programme, on voit que les
sauts de lignes ne sont pas gérer automatiquement (quand j'arrive à la
fin de la ligne et que j'appuie sur flèche droite, on ne passe pas à
la ligne suivante par exemple). Ce sera à nous de le gérer…

Si on veut utiliser HJKL (comme dans Vim) pour se déplacer, on peut
remplacer le contenu du `case` par:

{% highlight ruby %}
    when ?h then x -= 1
    when ?l then x += 1
    when ?k then y -= 1
    when ?j then y += 1
{% endhighlight %}

Voilà.



À demain.



