---
layout: post
title: "Écrire un éditeur pour le terminal - partie 5"
date: 2014-03-02 20:54
legacy: true
tags: [ruby, curses, ncurses, intermédiaire, terminal]
---



La bibliothèque *curses* sait gérer le fenêtrage. Voici un programme qui
montre comment faire.

<!-- more -->

C'est une traduction en ruby d'un programme C issu d'un tutoriel
sur *ncurses* (dont je ne retrouve plus la référence dans l'immédiat).

{% highlight ruby %}
require 'curses'
include Curses

def create_newwin(height, width, top, left)
  local_win = Window.new(height, width, top, left)
  local_win.box(?|, ?-)
  local_win.refresh
  local_win
end

def destroy_win(w)
  w.clear
  w.refresh
  w.close
end

begin
  init_screen
  cbreak
  stdscr.keypad(true)
  height = 3
  width = 10
  top = (lines - height) / 2
  left = (cols - width) / 2
  addstr("Press F1 to exit")
  refresh
  my_win = create_newwin(height, width, top, left)

  while (ch = getch) != KEY_F1
    case ch
    when KEY_LEFT then left -= 1
    when KEY_RIGHT then left += 1
    when KEY_UP then top -= 1
    when KEY_DOWN then top += 1
    end
    destroy_win(my_win)
    my_win = create_newwin(height, width, top, left)
  end
ensure
  close_screen
end
{% endhighlight %}

En étudiant ce programme avec en parallèle la documentation ruby
de [curses](http://ruby-doc.org/stdlib-2.1.0/libdoc/curses/rdoc/Curses.html),
vous devriez comprendre sans problèmes la gestion des fenêtres.




À demain.



