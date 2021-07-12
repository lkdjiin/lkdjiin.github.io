---
layout: post
title: "Le système de fenêtrage de Vim"
date: 2013-09-07 09:45
legacy: true
tags: [vim]
---



Aujourd'hui je vous présente les combinaisons de touches que j'utilise
au quotidien pour travailler avec les fenêtres dans Vim.

<!-- more -->

Avant d'entrer dans le vif du sujet, je dois vous prévenir que
pour ouvrir un fichier dans une nouvelle fenêtre (ou dans un nouvel onglet)
j'utilise le plugin Ctrlp. Il n'y aura donc pas de commandes relatives
à l'ouverture d'un nouveau fichier.

La base
-------

Pour ouvrir une copie de la fenêtre active dans une nouvelle fenêtre
horizontale:

{% highlight vim %}
:sp
{% endhighlight %}

`sp` est l'abréviation de `split`.

Pour ouvrir une copie de la fenêtre active dans une nouvelle fenêtre
verticale:

{% highlight vim %}
:vs
{% endhighlight %}

`vs` est l'abréviation de `vsplit`.

Un peu de mappage
------------------

Pour faciliter les manipulations de fenêtres, j'utilise `w` comme
un Ctrl+w. Ctrl+w étant le préfixe de nombreuses commandes concernants
les fenêtres:

{% highlight vim %}
noremap w <C-w>
noremap W <C-w><C-w>
{% endhighlight %}

En mode normal, les touches fléchées me servent à changer de fenêtre.

{% highlight vim %}
nnoremap <up> <C-w><up>
nnoremap <down> <C-w><down>
nnoremap <left> <C-w><left>
nnoremap <right> <C-w><right>
{% endhighlight %}

Bouger et fermer
----------------
Pour changer de fenêtre en cycle:

{% highlight vim %}
ww
{% endhighlight %}

Pour échanger deux fenêtres:

{% highlight vim %}
wx
{% endhighlight %}

Pour fermer la fenêtre active, deux solutions:

{% highlight vim %}
:q
" ou bien
ZZ
{% endhighlight %}

Pour fermer toutes les fenêtres sauf la courante:

{% highlight vim %}
wo
{% endhighlight %}

Pour basculer la fenêtre active dans un nouvel onglet:

{% highlight vim %}
wT
{% endhighlight %}

Dimensions des fenêtres
---------------------

Pour un agencement de fenêtres un peu complexe, il est sûrement plus simple et
rapide d'utiliser la souris. Et oui, il arrive parfois (mais c'est rare, hein)
que le clavier ne soit pas le périphérique le mieux adapté.

Pour donner une taille identique à toutes les fenêtres:

{% highlight vim %}
w=
{% endhighlight %}

Pour redimensionner les fenêtres, j'utilise la touche `Control` combinée
avec les flèches:

{% highlight vim %}
nnoremap <C-up> :resize +2<cr>
nnoremap <C-down> :resize -2<cr>
nnoremap <C-right> :vertical resize +2<cr>
nnoremap <C-left> :vertical resize -2<cr>
{% endhighlight %}

Ainsi,
Ctrl + flèche vers le haut va augmenter la hauteur de la fenêtre active.
Ctrl + flèche vers le bas va diminuer la hauteur de la fenêtre active.
Ctrl + flèche vers la droite va augmenter la largeur de la fenêtre active.
Ctrl + flèche vers la gauche va diminuer la largeur de la fenêtre active.





À demain.


