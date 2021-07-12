---
layout: post
title: "Installation du plugin Airline pour Vim - partie 4"
date: 2014-01-28 20:42
legacy: true
tags: [vim]
---



Après [avoir installé](/blog/2014/01/25/installation-du-plugin-airline-pour-vim-partie-1/) le plugin Airline pour Vim,
après [avoir configuré le thème](/blog/2014/01/26/installation-du-plugin-airline-pour-vim-partie-2/),
puis [personnalisé quelques sections](/blog/2014/01/27/installation-du-plugin-airline-pour-vim-partie-3/),
vous pensiez en avoir fini. Mais il se peut que la branche git
n'apparaisse pas dans votre barre de statut ?
Comment faire pour que Airline affiche le nom de la branche git ?

<!-- more -->

En fait, il ne peut pas. Enfin pas vraiment. Airline ne fait pas tout.
Par contre il intègre très bien d'autres plugins. Et notamment
l'excellent vim-fugitive de Tim Pope. Donc, pour que Airline affiche
votre branche git, il vous suffit d'installer vim-fugitive. Par
exemple, avec Pathogen:

    git clone git://github.com/tpope/vim-fugitive.git ~/.vim/bundle/vim-fugitive

Et voilà.



À demain.


