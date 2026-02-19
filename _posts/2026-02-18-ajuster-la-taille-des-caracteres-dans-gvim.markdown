---
layout: post
title: "Ajuster la taille des caractères dans gVim"
date: 2026-02-18 8:00
comments: true
tags: [ vim, gvim ]
---

Ça fait trop longtemps que je n'ai pas consacré un peu de temps à rendre mon
environnement de développement plus confortable.

<!-- more -->

## Le problème

Dans un terminal (du moins celui que j'utilise) on peut zoomer avec
`Ctrl`+`+`, dézoomer avec `Ctrl`+`-`, et revenir à la taille de caractères
initiale avec `Ctrl`+`0` (j'ai modifié ce dernier pour `Ctrl`+`*`).

Avec Vim, donc dans un terminal, ces raccourcis clavier fonctionnent.
Ils fonctionnent aussi dans Firefox.
Mais malheureusement ils ne fonctionnent pas dans gVim, la version GUI de Vim,
qui est celle que j'utilise le plus souvent. Et il n'existe même aucunes solutions natives pour
zoomer et dézoomer. Ce qui n'est vraiment pas confortable.

Je vais donc ajouter ces fonctions à gVim.

## Définir la police de caractères

Il faut savoir que c'est très dépendant du système. Pour moi c'est
Linux et GTK. Si c'est autre chose pour vous, regardez `:help guifont`.

Pour utiliser la police "Monospace Regular" avec la taille 14 il faut définir
l'option `guifont` dans un script ou en mode commande :

{% highlight vim %}
set guifont=Monospace\ Regular\ 14
{% endhighlight %}

C'est évidemment méga ch@!@! d'avoir à utiliser des `\` devant les espaces. C'est
pourquoi je préfère utiliser `let` :

{% highlight vim %}
let &guifont = 'Monospace Regular 14'
{% endhighlight %}

Pourquoi ça marche dans un cas et pas dans un autre ? C'est une subtilité (pour
rester poli) du langage de Vim que je ne comprend pas entièrement. En gros
`guifont` est une option et `set` est fait pour définir des options. Alors que
`let &` assigne la chaîne à une option. Pour moi c'est la même chose, Mais à
l'évidence pas pour Vim ¯\\\_(ツ)\_/¯

## Le fichier .gvimrc

Vim possède son fichier de configuration `.vimrc`, gVim ajoute le fichier `.gvimrc`.
Celui-ci est lu après le `.vimrc`. C'est l'endroit idéal pour modifier tout ce qui
concerne le GUI. Chaque fois que vous voudrez tester des changements il faudra
recharger ce fichier en mode commande avec `:source ~/.gvimrc`.

Je défini d'abord une variable globale pour la taille initiale des caractères.

{% highlight vim %}
let g:font_size = 14
{% endhighlight %}

Une fonction pour zoomer/dézoomer va modifier cette variable et redéfinir
l'option `guifont`.

{% highlight vim %}
function ZoomFont(amount)
  let g:font_size += a:amount
  let &guifont = 'Monospace Regular ' . g:font_size
endfunction
{% endhighlight %}

Vous pouvez la tester en mode commande avec `:call ZoomFont(3)`, `:call ZoomFont(-1)`, etc.

J'ai aussi besoin d'une fonction pour revenir à la taille initiale :

{% highlight vim %}
function ResetFont()
  let g:font_size = 14
  let &guifont = 'Monospace Regular 14'
endfunction
{% endhighlight %}

Maintenant il faut mapper ces deux fonctions sur des touches (ou des combinaisons
de touches) pour zoomer, dézoomer, et revenir à l'origine. J'aurais tellement
voulu utiliser les mêmes combinaisons que le terminal et Firefox, malheureusement
gVim semble incapable de réagir à `Ctrl`+`+`, `Ctrl`+`-`, et `Ctrl`+`*`.
Après avoir testé différentes possibilités mon choix s'est porté sur F7, F8, et F10 :

{% highlight vim %}
nnoremap <F7> :call ZoomFont(2)<cr>
nnoremap <F8> :call ZoomFont(-2)<cr>
nnoremap <F10> :call ResetFont()<cr>
{% endhighlight %}

Voilà, maintenant quand j'ai quelque chose à montrer lors d'un meeting, je n'ai
plus besoin d'ouvrir un vim dans le terminal si une instance graphique est déjà
ouverte.
