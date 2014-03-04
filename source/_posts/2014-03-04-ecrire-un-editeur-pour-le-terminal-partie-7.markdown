---
layout: post
title: "Écrire un éditeur pour le terminal - partie 7"
date: 2014-03-04 21:04
comments: true
categories: 
---

{% level 2 %}

Notre futur éditeur aura un certain nombre de fenêtre (au sens de
*curses*) et pour les gérer, on sera bien inspiré d'utiliser un peu
de POO.
Voici donc une réécriture du programme vu
[ici](/blog/2014/03/02/ecrire-un-editeur-pour-le-terminal-partie-5/).

<!-- more -->

``` ruby
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
```

Le code est plus conséquent, c'est vrai, mais la structure sera plus
claire, surtout quand on coupera le code en plusieurs fichiers, et
qu'on utilisera un peu, ou plutôt beaucoup, d'héritage.

Le détail à retenir, curieusement, est celui-ci:

``` ruby
begin
  init_screen
  refresh
```

Il faut rafraichir l'écran juste après l'initialisation de *curses*, sinon
aucune fenêtre ne s'affichera…

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

