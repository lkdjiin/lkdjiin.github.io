---
layout: post
title: "De Linux (Debian) vers OS X : Coloriser la commande ls"
date: 2014-01-23 20:44
comments: true
categories: [linux, debian, os x, débutant]
---

{% level 1 %}


Aujourd'hui : Comment faire pour que la commande `ls` affiche sa sortie
en couleur dans un terminal.

<!-- more -->

Comment coloriser la sortie de la commande ls 
----------------------------------------------------

Sous Linux, qui utilise normalement la commande `ls` du **Gnu**, c'est l'option
`--color` qui permet d'obtenir la sortie en couleurs. Ce qui donne
typiquement ce genre d'alias:

``` bash
alias ls='ls --color=auto'
```

Sous OS X, qui utilise **la version Bsd** de la commande `ls`, il s'agit
de l'option `-G`, ce qui donnera plutôt:

``` bash
alias ls='ls -G'
```

[Astuce précédente](/blog/2014/01/22/de-linux-debian-vers-os-x-le-fichier-de-configuration-de-bash/)

