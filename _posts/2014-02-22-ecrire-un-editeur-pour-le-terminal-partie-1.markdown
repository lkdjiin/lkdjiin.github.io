---
layout: post
title: "Écrire un éditeur pour le terminal - partie 1"
date: 2014-02-22 15:14
legacy: true
tags: [ruby, ncurses, intermédiaire, terminal]
---



Après avoir parler quelque peu de ncurses, on passe à la première étape
de l'écriture d'un éditeur qui ressemblerait à Vim: afficher le contenu
d'un fichier.

<!-- more -->

Le progamme est très proche de ce qu'on avait obtenu
[la dernière fois](/blog/2014/02/16/curses-et-ncurses-en-ruby/),
et pour cause, la seule différence étant l'ouverture/affichage du
fichier passé en argument:

{% highlight ruby %}
#!/usr/bin/env ruby

require 'ffi-ncurses'
include FFI::NCurses

file = File.open ARGV[0]

begin
  initscr
  file.each {|line| printw line }
  refresh
  getch
ensure
  endwin
end
{% endhighlight %}

N'oubliez pas de donner les droits d'exécution à ce programme:

    chmod +x redvim.rb

Et lancez-le ainsi pour qu'il s'affiche lui-même:

    ./redvim.rb redvim.rb

Si vous essayez de lui faire afficher un fichier trop long pour tenir
dans le terminal, il va se passer des choses bizarres. On corrigera
ça plus tard. Pour l'instant notre programme affiche un fichier, c'est
déjà le début de la gloire ;)



À demain.




