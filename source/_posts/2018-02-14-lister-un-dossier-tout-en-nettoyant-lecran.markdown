---
layout: post
title: "Lister un dossier tout en nettoyant l'écran"
date: 2018-02-14 10:28
comments: true
categories: [fish, bash, shell, alias]
---

Deux ou trois fois dans l'année j'analyse mon usage du clavier pour tenter
d'augmenter mon confort quotidien. Lisez&nbsp;: Je regarde de près ce que je
tape pour faire en sorte de taper toujours moins.

J'ai remarqué récemment que j'aimais de plus en plus avoir un écran vide avant
d'entreprendre une série de commande. Pour effacer l'écran, on utilise la commande
`clear` ou son raccourci `Ctrl+L`. Et depuis quelques temps je me suis habitué
à systématiquement vider l'écran avant de lister le contenu d'un répertoire.
Autrement dit je répète très souvent la séquence de touche suivante&nbsp;:

<center><b>Ctrl + l + l + s + Enter</b></center>

Soit 5 touches.

Donc, beaucoup trop.

<!-- more -->

## Alias S

Un petit alias sera la solution pour prendre soin de mes poignets fragiles ;)
Je vais utiliser la lettre `s` parce que sa touche tombe particulièrement bien
sous mes doigts.

<center><b>s + Enter</b></center>

Soit 2 touches.

Donc, je suis content :)

## Bash

Avec Bash, que j'utilise essentiellement sur serveurs distants, voici comment
procéder&nbsp;:

```bash
alias s='clear;ls' # List directory on a clean screen
```

Je place mes alias Bash dans un fichier `~/.bash_aliases` que j'inclus depuis
le fichier `~/.bashrc` comme ceci&nbsp;:

```bash
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
```

## Fish

Avec Fish, que j'utilise sur mes machines perso, c'est un peu différent. Fish
n'a pas de commande `alias`, il suffit d'écrire une fonction au bon endroit.

```
# Fichier ~/.config/fish/functions/s.fish
function s --description 'List directory on a clean, cleared screen'
  	clear
    ls
end
```

## Conclusion

Je ne sais pas si je vais beaucoup me servir de cette commande `s`.
J'ai toujours eu du mal à m'habituer aux commandes d'une seule lettre, je sais
pas pourquoi. On verra bien…

Si vous avez des astuces dans le même genre, faites moi en part dans un
commentaire, ça pourrait servir ;)

À bientôt.

{% connexe %}
