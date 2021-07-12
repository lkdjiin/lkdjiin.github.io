---
layout: post
title: "Écrire un éditeur pour le terminal - partie 7"
date: 2014-03-04 21:04
legacy: true
tags: [ruby, curses, ncurses, intermédiaire, terminal]
---



Notre futur éditeur aura un certain nombre de fenêtre (au sens de
*curses*) et pour les gérer, on sera bien inspiré d'utiliser un peu
de POO.
Voici donc une réécriture du programme vu
[ici](/blog/2014/03/02/ecrire-un-editeur-pour-le-terminal-partie-5/).

<!-- more -->

{% highlight ruby %}
#!/usr/bin/env ruby

require 'curses'
include Curses

class StatusWindow
  def initialize(filename)
    @filename = filename
    @win = Window.new(1, cols, 0, 0)
  end

  def display
    @win.setpos(0, (@win.maxx - @filename.size) / 2)
    @win.addstr(@filename)
    @win.refresh
  end

  def close
    @win.close
  end
end

class FileWindow
  def initialize(filename)
    @filename = filename
    @win = Window.new(lines - 2, cols, 2, 0)
  end

  def display
    @win.setpos(0, 0)
    File.open(@filename).each {|line| @win.addstr(line) }
    @win.refresh
  end

  def close
    @win.close
  end
end

begin
  init_screen
  refresh
  status_window = StatusWindow.new(ARGV[0])
  file_window = FileWindow.new(ARGV[0])
  status_window.display
  file_window.display
  getch
  status_window.close
  file_window.close
ensure
  close_screen
end
{% endhighlight %}

Le code est plus conséquent, c'est vrai, mais la structure sera plus
claire, surtout quand on coupera le code en plusieurs fichiers, et
qu'on utilisera un peu, ou plutôt beaucoup, d'héritage.

Le détail à retenir, curieusement, est celui-ci:

{% highlight ruby %}
begin
  init_screen
  refresh
{% endhighlight %}

Il faut rafraichir l'écran juste après l'initialisation de *curses*, sinon
aucune fenêtre ne s'affichera…



À demain.



