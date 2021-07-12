---
layout: post
title: "Écrire un éditeur pour le terminal - partie 3"
date: 2014-02-24 20:59
legacy: true
tags: [ruby, curses, ncurses, intermédiaire, terminal]
---



Comment connaitre le nombre de lignes et de colonnes du terminal ?
Voici la réponse…

<!-- more -->

Le programme suivant utilise les méthodes `cols` et `lines` de la
bibliothèque `Curses` pour avoir ces informations:

{% highlight ruby %}
require 'curses'
include Curses

begin
  init_screen
  addstr("#{cols} x #{lines}")
  getch
ensure
  close_screen
end
{% endhighlight %}

Redimensionnez votre terminal et relancez le programme pour être sûr
que ça fonctionne ;)

Ces informations nous seront bien utiles pour l'écriture d'un éditeur…




À demain.


