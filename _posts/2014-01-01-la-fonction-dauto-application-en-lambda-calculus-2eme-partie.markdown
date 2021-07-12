---
layout: post
title: "La fonction d'auto-application en Lambda Calculus 2ème partie"
date: 2014-01-01 17:43
legacy: true
tags: [λ calculus]
---



Hier on a vu [la fonction d'auto-application](http://lkdjiin.github.io/blog/2013/12/31/la-fonction-dauto-application-en-lambda-calculus/) appliquée à divers arguments.
Aujourd'hui on regarde ce qu'il se passe lorsqu'elle est appliquée à
elle-même.

<!-- more -->

(λs.(s s) λs.(s s))
-------------------

Que ce passe-t-il quand on applique la fonction d'auto-application sur
elle-même ? Regardons cela:

    (λs.(s s) λs.(s s))

Le premier `s` de cette application est la variable liée. Je le met entre
chevrons doubles pour être sûr de bien me faire comprendre:

    (λ<<s>>.(s s) λs.(s s))

Ensuite nous avons le corps de la fonction:

    (λs.<<(s s)>> λs.(s s))

Vient ensuite l'argument de l'application:

    (λs.(s s) <<λs.(s s)>>)

Pour évaluer cette application, on utilise le même mécanisme que
précédement: on remplace chaques occurences de la variable liée par
l'argument, dans le corps de la fonction, et on renvoie ce corps.
Ce qui nous donne donc:

    (λs.(s s) λs.(s s))

Nous avons obtenu exactement la même application que celle de départ !
L'évaluation n'étant pas terminée, on doit continuer et on voit qu'on
entre dans une *boucle infinie*: l'évaluation ne se termine jamais.



Bonne année 2014 et à demain !



