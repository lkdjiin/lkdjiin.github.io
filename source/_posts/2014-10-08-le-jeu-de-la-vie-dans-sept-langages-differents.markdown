---
layout: post
title: "Le jeu de la vie dans sept langages différents"
date: 2014-10-08 12:30
comments: true
categories: [défi, ruby, opal, tdd, javascript, racket, logo, julia, haskell, rust]
---

{% level 2 %}

Je vais écrire le [jeu de la vie](http://en.wikipedia.org/wiki/Conway%27s_Game_of_Life) dans 7 langages, et
en utilisant le TDD (sauf pour l'affichage).
Ça va me permettre de réviser certains langages et d'en apprendre de nouveaux
d'une manière amusante. Après tout, quoi de plus *fun* qu'un jeu pour zéro
joueur.

L'algorithme
------------

L'idée directrice, c'est de faire au plus simple.
L'algorithme général sera le suivant :

1. obtenir une première génération au hasard
2. afficher la génération
3. calculer la nouvelle génération et retour au point 2.

Discutons un peu chacun des trois points.

<!-- more -->

### Obtenir une première génération au hasard

Cette génération sera stockée dans un tableau (une liste). Suivant le
langage, j'utiliserais un tableau à 1 ou 2 dimensions.

### Afficher la génération

Il s'agit d'afficher à l'écran le tableau calculé précédement. Chaque élément
du tableau représente une cellule du jeu de la vie, et une cellule sera
représentée à l'écran par un pixel. Alors un pixel pour une cellule, ça risque
d'être assez moche sur la plupart des dispositifs, mais c'est le plus simple.
J'améliorerais peut-être cet affichage plus tard.

### Calculer la nouvelle génération

Là encore, j'essaye d'aller au plus simple. On va calculer la
nouvelle génération dans un second tableau. Une fois ce calcul effectué, ce
second tableau remplacera le premier.

Pour calculer le nouvel état d'une cellule, on devra observer la cellule et
ces 8 voisins. Autrement dit on observe une fenêtre de 9 cellules et on veut
connaitre le nouvel état de la cellule centrale. Il y a 3 cas possibles:

1. Si la somme des cellules vivantes est 3, alors la nouvelle cellule sera
   vivante.
2. Si la somme des cellules vivantes est 4, alors la nouvelle cellule conserve
   son ancien état.
3. Dans tous les autres cas, la nouvelle cellule est morte.

Il faut encore parler du cas des cellules qui se trouvent sur les bords du
*plateau de jeu*. Normalement, le jeu de la vie est infini. Mais l'infini, c'est
pas simple. Dans une première itération, le *plateau de jeu* aura des
dimensions finies et les cellules qui se trouvent sur les bords se verront
ajoutées arbitrairement des voisins morts.

Une seconde itération pourrait implémenter une espèce de [tore](http://en.wikipedia.org/wiki/Torus) pour avoir une surface
de jeu sans bordures.


Les langages ciblés
-------------------

Je vais écrire le jeu de la vie dans 7 langages différents:

- ruby
- javascript
- racket
- logo
- julia
- haskell
- rust

### Pourquoi ces langages ?

**Ruby**

Ça peut paraitre bizarre. Après tout j'écris en Ruby toute la journée, c'est
mon métier. Pourquoi vouloir en faire encore pendant mon temps libre ?
En fait, ce qui m'intéresse vraiment ici, c'est [Opal.rb](http://opalrb.org/). Peut-être aussi
que j'en ferais une seconde version avec [Gosu](http://www.libgosu.org/).

**Javascript**

Après des années passées à tenter d'éviter d'écrire la moindre ligne de
Javascript, je m'intéresse de nouveau à ce langage. Après tout, c'est un
incontournable du Web et il commence à me plaire. Et puis j'ai trop tardé à
faire du TDD avec Javascript, je crois que [Jasmine](http://jasmine.github.io/) est devenu très bon.

**Racket**

Je crois que tout développeur devrait étudier un *Lisp like*. Lisp t'oblige à
penser autrement et du coup tu trouves des solutions différentes à des
problèmes de programmation de tout les jours.

**Logo**

Le [Logo](http://fr.wikipedia.org/wiki/Logo_%28langage%29), c'est ma [madeleine de Proust](http://fr.wikipedia.org/wiki/Madeleine_%28cuisine%29#La_madeleine_de_Proust) ! Voilà. Encore un *Lisp like*,
mais différent (on l'appelait Lisp sans parenthèses). J'espère que je trouverais
encore des ressources pour celui-ci.


**Julia**

Je pense que les langages fonctionnels ont un grand avenir. Ils résolvent au
moins deux soucis. En ce concentrant sur la transformation des données plutôt
que sur l'état de ces données, ils facilitent les tests et l'utilisation des
multi-coeurs.

**Haskell**

Encore un langage fonctionnel, et celui-ci me fait un peu peur. Mais je me dis
que je devrais y goûter.

**Rust**

Je voulais un langage système dans cette liste, ce sera [Rust](http://www.rust-lang.org/).

Fréquence de publication
------------------------

Je ne m'avancerais pas sur une fréquence de publication. J'imagine qu'il y
aura 3 ou 4 articles par langage. Et suivant le temps dont je disposerais, ça
pourrat-être aussi bien un article par mois ou trois articles par semaine.

Allez, la prochaine fois on commence avec Ruby/Opal.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

{% connexe %}
