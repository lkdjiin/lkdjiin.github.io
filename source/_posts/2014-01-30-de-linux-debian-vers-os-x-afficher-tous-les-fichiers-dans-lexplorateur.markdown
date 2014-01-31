---
layout: post
title: "De Linux (Debian) vers OS X - Afficher tous les fichiers dans l'explorateur"
date: 2014-01-30 20:42
comments: true
categories: [linux, debian, os x, débutant]
---

{% level 1 %}


Aujourd'hui : Comment afficher tous les fichiers dans le Finder
(l'explorateur d'OS X).

<!-- more -->

Afficher tous les fichiers dans l'explorateur
----------------------------------------------------

Par défaut, l'explorateur d'OS X ne montre pas les fichiers et
dossiers cachés (ceux qui commencent par un point) et d'autres
(je ne sais pas trop lesquels).

Dans Linux, un `Ctrl h` dans l'explorateur affiche/masque ces fameux
fichiers et dossiers cachés. Sous OS X, c'est moins pratique, il
faut saisir ceci dans un terminal:

``` bash
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
```

Il faudra ensuite tuer toutes les instances de Finder pour que les
changements soient pris en compte:

``` bash
killall Finder
```

[Astuce suivante](/blog/2014/01/31/de-linux-debian-vers-os-x-naviguer-dans-lexplorateur/)    
[Astuce précédente](/blog/2014/01/24/de-linux-debian-vers-os-x-raccourcis-claviers-de-firefox/)

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

