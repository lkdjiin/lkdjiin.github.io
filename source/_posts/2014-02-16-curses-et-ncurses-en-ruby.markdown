---
layout: post
title: "Curses et ncurses en Ruby"
date: 2014-02-16 14:29
comments: true
categories: [ruby, intermédiaire, terminal, curses, ncurses]
---

{% level 2 %}

Tiens, j'ai envie d'écrire en Ruby un embryon d'éditeur pour le terminal, qui
serait fortement inspiré de Vim. Juste histoire de voir comment ça marche.
La première étape sera d'utiliser la bibliothèque curses (ou ncurses) à
partir de Ruby.

<!-- more -->

Curses
-------

La bibliothèque *curses* permet de gérer toutes les interactions
clavier et souris avec un terminal. Jusqu'à la version 2.1 de Ruby, elle
faisait partie de la bibliothèque standard. Donc, si vous utilisez
Ruby 2.1, n'oubliez pas de faire:

    gem install curses

Si vous utilisez Ruby 2.0 où inférieur, vous possédez déjà la bibliothèque
*curses*.

Voici donc un *hello world*:

``` ruby
require 'curses'

include Curses

begin
  init_screen
  setpos(0, 0)
  addstr('Hello, world!')
  refresh
  getch
ensure
  close_screen
end
```

On remarque tout d'abord la paire:

    init_screen
    close_screen

Il faut toujours appeler `close_screen` à la fin de votre programme, pour
remettre le terminal dans l'état où il se trouvait avant le lancement de
votre programme.

Pour positionner le curseur, on utilise:

    setpos(0, 0)

Attention, le premier nombre est le numéro de la ligne, et le second est le
numéro de la colonne. Et lignes et colonnes se comptent à partir de 0…

Pour écrire une chaîne de caractère à la position du curseur:

    addstr('Hello, world!')
    refresh

Curses n'écrit directement dans le terminal, mais dans un buffer en mémoire,
c'est pourquoi il faut appeler `refresh` pour voir les changements.

Ensuite, on attends l'appui sur une touche du clavier avec:

    getch

Ncurses
--------

Il existe aussi la bibliothèque *ncurses*, un peu plus puissante. Il existe
plusieurs wrappers pour Ruby. J'utilise personnelement [ffi-ncurses](https://github.com/seanohalpin/ffi-ncurses).

Le même programme que le précédent, mais pour ncurses:

``` ruby
require 'ffi-ncurses'

include FFI::NCurses

begin
  initscr
  printw "Hello World !!!"
  refresh
  getch
ensure
  endwin
end
```

Les deux programmes se ressemblent beaucoup. Et pour cause, *ncurses* fait
la même chose que *curses*, avec des extensions en plus.

Choisir entre curses et ncurses
-------------------------------

L'une et l'autre ont leurs avantages et leurs inconvénients. *curses* à
l'avantage d'avoir été distribuée en standard avec Ruby jusqu'à la version
2.0 incluse, et est donc très bien intégrée. Je pense qu'on doit pouvoir
l'utiliser facilement, même sur Windows. *ncurses* est plus puissante mais
requiert plus de dépendances, et il n'est pas toujours évident de trouver
un wrapper qui fonctionne avec une version récente de Ruby, même sur Linux.

Si je devais écrire un programme grand public, j'utiliserais *curses*, mais
comme il s'agit juste d'un programme exemple pour ce blog, je vais me faire
plaisir et utiliser *ncurses*…

La prochaine fois on commencera à écrire l'éditeur.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}


