---
layout: post
title: "Afficher l'arborescence d'un dossier dans le terminal"
date: 2014-02-17 20:56
comments: true
categories: [terminal, bash, linux, os x, débutant]
---

Pour comprendre l'arborescence des dossiers d'un projet, rien de mieux
que de l'afficher. On peut le faire dans l'explorateur graphique fournit
par l'OS, ou bien dans son éditeur/EDI, ou encore dans le terminal.

<!-- more -->

Je travaille depuis janvier sur OS X et je n'arrive pas à me faire à son
explorateur. Dans Vim, je n'ai pas de plugin pour faire ça, et je n'en veux
pas. Il ne me restait plus qu'à renouer avec une vieille copine, la commande
`tree`.

Installation
---------

`tree` n'est pas installée par défaut, il faut donc passer par le gestionnaire
de paquet.

    apt-get install tree # Debian, Ubuntu, etc

    brew install tree # OS X

Utilisation
----------

Afficher l'arborescence du dossier courant:

    tree

Afficher l'arborescence d'un sous-dossier:

    tree sous/dossier

Options utiles
--------------

Du moins celles que j'utilise couramment.

Pour avoir la couleur:

    tree -C

Pour un affichage graphique plus sympa:

    tree -A

Pour inclure les fichiers et dossiers cachés:

    tree -a

Pour n'afficher que les dossiers:

    tree -d

Pour limiter la profondeur:

    tree -L 2 # N'affiche que les sous-dossiers directs

Alias
-------

Pour finir, voici les alias que j'utilise:

``` bash
alias tree='tree -CA'
alias dirtree='tree -d'
```

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}


