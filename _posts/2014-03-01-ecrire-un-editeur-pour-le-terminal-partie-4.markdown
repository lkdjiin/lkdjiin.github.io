---
layout: post
title: "Écrire un éditeur pour le terminal - partie 4"
date: 2014-03-01 17:47
legacy: true
tags: [ruby, curses, ncurses, intermédiaire, terminal]
---



Aujourd'hui on voit comment écrire un message centré horizontalement et
verticalement, comment lire une chaîne de caractères, et comment être
tranquille avec les caractères non ASCII.

<!-- more -->

Voici un programme qui montre tout ça:

{% highlight ruby %}
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
{% endhighlight %}

Quelques brèves explications maintenant:

Tout d'abord, on affiche un message centré ainsi:

{% highlight ruby %}
  setpos(lines / 2, (cols - message.size) / 2)
  addstr(message)
{% endhighlight %}

Pour lire une chaîne de caractères, on utilise `getstr`:

{% highlight ruby %}
  str = getstr
{% endhighlight %}

Puis on affiche ce qu'on vient de lire sur l'avant-dernière ligne du
terminal:

{% highlight ruby %}
  setpos(lines - 2, 0)
  addstr(sprintf("You entered: %s", str))
{% endhighlight %}

Le [sprintf](http://www.ruby-doc.org/core-2.1.1/Kernel.html#method-i-sprintf),
qui vous rappelera des choses si vous avez fait du C, est ce que j'ai
trouvé de mieux pour ne pas avoir de soucis avec les caractères
non ASCII.



À demain.



