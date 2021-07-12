---
layout: post
title: "Écrire un éditeur pour le terminal - partie 6"
date: 2014-03-03 21:10
legacy: true
tags: [ruby, curses, ncurses, intermédiaire, terminal]
---



Après avoir vu
[comment centrer du texte](/blog/2014/03/01/ecrire-un-editeur-pour-le-terminal-partie-4/)
et
[comment faire du fenêtrage](/blog/2014/03/02/ecrire-un-editeur-pour-le-terminal-partie-5/),
on peut réunir les deux pour afficher un fichier, et le nom de ce fichier
centré sur la première ligne du terminal.

<!-- more -->

{% highlight ruby %}
#!/usr/bin/env ruby

require 'curses'
include Curses


def display_filename
  setpos(0, (cols - ARGV[0].size) / 2)
  addstr(ARGV[0])
end

def display_file
  setpos(2, 0)
  File.open(ARGV[0]).each {|line| addstr(line) }
end

begin
  init_screen
  display_filename
  display_file
  refresh
  getch
ensure
  close_screen
end
{% endhighlight %}

Et voilà.



À demain.



