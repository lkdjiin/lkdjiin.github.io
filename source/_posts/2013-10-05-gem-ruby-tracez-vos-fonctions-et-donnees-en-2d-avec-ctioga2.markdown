---
layout: post
title: "Gem Ruby: Tracez vos fonctions et données en 2D avec ctioga2"
date: 2013-10-05 14:43
comments: true
categories: [gem, ruby, app, mathématique]
---

Je cherchais un programme simple à prendre en main pour tracer des
ensembles de données depuis un fichier et des fonctions mathématiques
et je suis tombé sur la gem [ctioga2](http://ctioga2.rubyforge.org/index.html).

{% img /images/ctioga2.png %}

Voici une introduction rapide à ce programme de traçage.

<!-- more -->

Installation
------------

Il faut d'abord installer les outils nécessaires à la génération de document
pdf. Sur Linux c'est texlive, pour les autres OS voyez la
[page d'installation](http://ctioga2.rubyforge.org/install.html) de ctioga2.
Ensuite on installe la gem comme d'habitude:

    gem install ctioga2

Le fichier de données
---------------------

Un commentaire commence par un `#`. La première colonne est la coordonnée `x` et
la seconde colonne est la coordonnée `y`. Difficile de faire plus simple.
Un exemple:

    # Fichier data.dat
    # x y
    0 -0.9
    1 -0.4
    2 -0.1
    3 0.1
    4 0.4
    5 0.9

Les scripts
-----------

Voici un script minimal pour générer un fichier pdf:

    # Fichier test.ct2
    xpdf
    plot data.dat
    title 'Test'

Ce script va générer un fichier au format pdf à partir de notre fichier
de données, avec le titre `Test`. On le lance ainsi:

    ctioga2 -f test.ct2

**Note** j'ai trouvé que seuls les caractères ascii fonctionnaient pour le
titre.

Si notre fichier de données possèdent plusieurs colonnes, on peut tracer
plusieurs courbes ainsi:

    # Fichier test.ct2
    xpdf
    plot data.dat
    plot data.dat@1:3
    title 'Test'

Par défaut les `x` proviennent de la 1ère colonne et les `y` de la seconde.
La ligne `plot data.dat@1:3` trace une seconde courbe avec les `y` venant
de la 3ème colonne.

On peut aussi fournir des expressions Ruby:

    plot data2.dat@'$2:$3**2'

Ici la seconde colonne est utilisée pour les `x` et les `y` proviennent de
la troisième colonne, dont les données sont élevées à la puissance 2.

Plein d'autres choses sont possibles, comme produire du format png ou
svg, spécifier la portée des coordonnées x et y, utiliser le programme
en ligne de commande, etc.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

