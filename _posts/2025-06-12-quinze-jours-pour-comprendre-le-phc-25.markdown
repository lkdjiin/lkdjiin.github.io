---
layout: post
title: "15 jours pour comprendre le PHC-25"
date: 2025-06-12 8:00
comments: true
tags: [ retro, phc25 ]
---

Le PHC-25 est un micro-ordinateur 8 bits du début des années 1980 qui
m'était totalement inconnu.
Je viens de le découvrir suite à [l'organisation d'une game jam](https://www.youtube.com/watch?v=B97-ilAeYUk)
pour cet ordi par les
«Retro Programmers United for Obscure Systems» (oui ça existe pour de vrai :D ).

D'après ce que j'ai compris, le principal problème de cet ordinateur est la documentation : spartiate et éronnée. Je me donne 15 jours pour voir si je peux écrire un jeu modeste.

<!-- more -->

## Installation de l'émulateur

Il existe deux émulateurs, un pour [MAME](https://www.mamedev.org/) et l'autre
pour Windows. Je suis sur Linux, mais je n'ai pas envie d'installer MAME sur
l'ordi où je code. J'opte donc pour l'émulateur Windows, que j'utiliserai à
l'aide de `wine`.

Je récupère l'émulateur sur www.phc25.com. Il semble exister une version plus
récente [ici](https://github.com/hitchhikr/phc25) mais je ne l'ai pas essayé.

Je place l'executable et la rom dans `~/.wine/drive_c/Program\ Files\ \(x86\)/phc25/`
et je peux maintenant lancer l'émulateur avec la commande `wine ./phc25.exe`.

## Hello world

On se quitte avec un classique _hello world_ :

{% highlight basic %}
10 print "Bonjour"
{% endhighlight %}

{% img center /images/phc25-1-1.png %}

## Réferences

- [Site dédié au PHC-25](http://www.phc25.com/index.htm)
- [La vidéo qui m'a fait découvrir le PHC-25](https://www.youtube.com/watch?v=B97-ilAeYUk)

{% include serie_phc25.md %}
