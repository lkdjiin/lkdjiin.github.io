---
layout: post
title: "Le système de fenêtrage de Vim"
date: 2013-09-07 09:45
comments: true
categories: [débutant, vim]
---

{% level 1 %}

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

``` vim
:sp
```

`sp` est l'abréviation de `split`.

Pour ouvrir une copie de la fenêtre active dans une nouvelle fenêtre
verticale:

``` vim
:vs
```

`vs` est l'abréviation de `vsplit`.

Un peu de mappage
------------------

Pour faciliter les manipulations de fenêtres, j'utilise `w` comme
un Ctrl+w. Ctrl+w étant le préfixe de nombreuses commandes concernants
les fenêtres:

``` vim
noremap w <C-w>
noremap W <C-w><C-w>
```

En mode normal, les touches fléchées me servent à changer de fenêtre.

``` vim
nnoremap <up> <C-w><up>
nnoremap <down> <C-w><down>
nnoremap <left> <C-w><left>
nnoremap <right> <C-w><right>
```

Bouger et fermer
----------------
Pour changer de fenêtre en cycle:

``` vim
ww
```

Pour échanger deux fenêtres:

``` vim
wx
```

Pour fermer la fenêtre active, deux solutions:

``` vim
:q
" ou bien
ZZ
```

Pour fermer toutes les fenêtres sauf la courante:

``` vim
wo
```

Pour basculer la fenêtre active dans un nouvel onglet:

``` vim
wT
```

Dimensions des fenêtres
---------------------

Pour un agencement de fenêtres un peu complexe, il est sûrement plus simple et
rapide d'utiliser la souris. Et oui, il arrive parfois (mais c'est rare, hein)
que le clavier ne soit pas le périphérique le mieux adapté.

Pour donner une taille identique à toutes les fenêtres:

``` vim
w=
```

Pour redimensionner les fenêtres, j'utilise la touche `Control` combinée
avec les flèches:

``` vim
nnoremap <C-up> :resize +2<cr>
nnoremap <C-down> :resize -2<cr>
nnoremap <C-right> :vertical resize +2<cr>
nnoremap <C-left> :vertical resize -2<cr>
```

Ainsi,
Ctrl + flèche vers le haut va augmenter la hauteur de la fenêtre active.
Ctrl + flèche vers le bas va diminuer la hauteur de la fenêtre active.
Ctrl + flèche vers la droite va augmenter la largeur de la fenêtre active.
Ctrl + flèche vers la gauche va diminuer la largeur de la fenêtre active.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
