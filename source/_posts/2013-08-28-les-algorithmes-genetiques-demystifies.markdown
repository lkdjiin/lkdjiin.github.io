---
layout: post
title: "Les algorithmes génétiques démystifiés"
date: 2013-08-28 09:49
comments: true
categories: [algorithme génétique, intermédiaire]
---

{% level 2 %}

**démystifié**:
{% blockquote %}
Enlever le caractère mystérieux.
{% endblockquote %}

Un algorithme génétique c'est quoi ? Comment ça marche ? À quoi ça sert ?
Si vous vous posez une de ces questions, cette 
nouvelle série d'articles peut vous
intéresser.

<!-- more -->

Une définition simple
---------------------
Tout d'abord, un algorithme génétique est un *algorithme*. Autrement dit
c'est une suite d'instructions, ou encore une recette, pour résoudre un
problème. C'est peut-être bidon pour certains d'entre vous, mais ça va mieux
en le disant.

Ensuite, pourquoi génétique ? Et bien parce que pour résoudre un problème,
cette catégorie d'algorithmes s'inspire de la biologie, de la génétique,
et notamment du mécanisme de la séléction naturelle et/ou artificielle.

La démarche
-----------
Pour faire court:

1. On crée une population au hasard. Chaque individu représente une solution
   possible au problème posé.
2. On évalue chaque individu (solution) de la population. En clair, on leur
   donne une note.
3. On selectionne certains individus parmi les plus adaptés.
4. Les individus (solutions) sélectionnés se reproduisent pour donner
   naissance à la nouvelle génération, qui est globalement plus adaptée.
5. On recommence au point 2 jusqu'à ce qu'on trouve la solution du
   problème.

Les domaines d'application
--------------------------
Tous, ou presque. Trouver le meilleur profil pour une hélice de bateau ou
une aile d'avion, apprendre à marcher à un robot, adapter le comportement
d'un personnage dans un jeu vidéo, maximiser l'exploitation du volume
d'un hangar, etc. Comme chaque nouvelle génération produit globalement
une meilleure solution, les algorithmes génétiques peuvent être très
intéressants lorsqu'on veut obtenir une *bonne* solution rapidement (et
pas forcement la *meilleure* solution).

Dans mes prochains articles, je parlerais plus en détails de ces
algorithmes et je montrerais notamment comment les coder.

À demain.

{% connexe %}
