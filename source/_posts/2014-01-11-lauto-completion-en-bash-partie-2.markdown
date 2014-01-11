---
layout: post
title: "L'auto-complétion programmable en Bash - partie 2"
date: 2014-01-11 20:33
comments: true
categories: [bash, intermédiaire, unix, auto complétion]
---

{% level 2 %}

Cet article est la suite de:
[L'auto complétion programmable en bash: partie 1](http://lkdjiin.github.io/blog/2014/01/10/lauto-completion-programmable-en-bash-partie-1/).

Une première piste
--------------

En parcourant rapidement la page de man de bash, je tombe sur une commande
pleine de promesse: la commande `compgen`.

<!-- more -->

Voici un extrait de la documentation:

**compgen** [*option*] [*word*]   
Generate possible completion matches for word according to the options, which
may be any option accepted by the **complete** builtin with the exception of -p
and -r, and write the matches to the standard output. When using the -F or -C
options, the various shell variables set by the **programmable completion**
*[...]*

J'ai donc une commande `compgen`, qui semble fournir les différentes
possibilités de complétions pour un mot. J'ai aussi une commande `complete`,
dont le nom sonne vraiment bien. Et on me confirme que bash peut faire de 
la `programmable completion`, même si je sais pas encore trop de quoi on
parle ici… Je vais devoir fouiller un peu les options de `complete` pour
apprendre comment fonctionne `compgen`. Ah, les joies du man Unix !

Mon voyage dans le monde de l'auto-complétion débute avec une page de man.
Y a plus sexy, mais bon, il faut bien commencer quelque part ;)

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

