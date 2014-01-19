---
layout: post
title: "Compiler votre Vim sous Linux"
date: 2014-01-19 12:32
comments: true
categories: [intermédiaire, vim, linux, compilation]
---

{% level 2 %}

Aujourd'hui on voit comment compiler la dernière version de
Vim sur Linux (Debian, mais Ubuntu devrait marcher aussi).

<!-- more -->

Pourquoi vouloir faire ça ?
---------------------------

Tout d'abord, pourquoi voudrais-t-on compiler Vim alors que Debian nous
le fournit dans les paquets ? Je vois plusieurs raisons:

1. Parce qu'on peut le faire. Mais je sens que cet argument n'est pas
   fait pour vous convaincre.
2. Parce que c'est fun. Idem, pas convaincant, hein ?
3. Parce qu'on peut vouloir profiter d'une des dernières fonctionnalités
   ajoutées, ou du dernier bugfix.
4. Parce que Debian est parfois à la ramasse lorsqu'il s'agit de nous
   fournir des versions suffisament récentes de certains logiciels.
   J'ai par exemple une machine qui est toujours en Debian 6 et que je
   ne peux pas upgrader, Vim y est *coincé* en version 7.2.

On y va
-------

Assurez vous d'abord d'avoir toutes les dépendances:

    $ sudo apt-get build-dep vim

Ensuite, on va télécharger les sources depuis GitHub:

    $ git clone https://github.com/b4winckler/vim.git

Puis peut-être aller chercher une release particulière:

    $ cd vim
    $ git checkout tags/v-7-4-155

Ensuite on va dans les sources:

    $ cd src

On nettoie (ça fait pas de mal):

    $ make distclean

On configure avec la plupart des features disponibles, notamment une
interface graphique et le support de perl, python et ruby:

    $ ./configure --with-features=huge --enable-gui=gnome2
      --with-compiledby=lkdjiin --enable-perlinterp  --enable-pythoninterp
      --enable-rubyinterp

Il reste à compiler:

    $ make

Et enfin à installer notre nouveau Vim:

    $ sudo make install

Et voilà:

{% img /images/vim-7-4-155.png %}

Désinstaller la version que vous avez compilé
---------------------------------------------

Si, pour une raison ou une autre, vous vouliez désinstaller
votre nouveau Vim, il faut d'abord trouver où il est installé.
Pour cela, lancez la commande suivante dans Vim:

``` vim
:echo $VIMRUNTIME
```

Dans mon cas, cela donne: `/usr/local/share/vim/vim74`.

Rendez-vous ensuite dans les sources que vous avez téléchargées,
par exemple:

    $ cd ~/tmp/vim/src

Puis:

    $ make VIMRUNTIME=/usr/local/share/vim/vim74
    $ sudo make uninstall

Et voilà.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
