---
layout: post
title: "Les sous-ensembles dans R"
date: 2015-04-07 19:12
legacy: true
tags: [R, débutant, sous ensemble, vecteur]
---



J'apprends [le langage R](http://www.r-project.org/) ! C'est cool d'apprendre de nouvelles choses.
C'est encore plus cool de les partager ;) Comme je suis vraiment tout neuf avec
R, c'est mon premier article sur ce langage. Et comme il faut bien commencer
quelque part, je vais vous parler de certains moyens d'obtenir des
sous-ensembles d'un vecteur (un vecteur c'est à peu près comme une liste).

{% img center /images/subset.png %}

<!-- more -->

On lance le REPL&nbsp;:

    $ R

On va créer un ensemble de notes (*grades*).  Le symbole `<-` est l'opérateur
d'affectation. La fonction `c()`, elle, permet de fabriquer un vecteur, avec
ici 10 notes allant de 1 à 5. `c()` assure la concaténation&nbsp;:

    > grades <- c(1, 2, 3, 2, 3, 2, 1, 4, 5, 2)

On peut vérifier ce qu'il y a dans `grades`. Le `[1]` indique qu'il s'agit d'un
vecteur dont on commence l'affichage par le 1er élément. R indexe en commençant
par 1, et non pas comme souvent par zéro&nbsp;:

    > grades
     [1] 1 2 3 2 3 2 1 4 5 2
 
Pour être sûr de comprendre cette histoire de vecteur et d'index, créons et
affichons un vecteur de 40 éléments à l'aide de la syntaxe `début:fin`&nbsp;:

    > 1:40
     [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
    [26] 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40

Alors ces sous-ensembles ? Et bien commençons par une indexation classique, avec
`[]`, pour retrouver un seul élément (en fait un vecteur d'un seul élément)&nbsp;:

    > grades[1]
    [1] 1

On peut aussi retrouver un *range*, par exemple du 6ème au 8ème élément&nbsp;:

    > grades[6:8]
    [1] 2 1 4

Pour retrouver seulement les notes au dessus de 2 on met la condition entre les
crochets&nbsp;:

    > grades[grades > 2]
    [1] 3 3 4 5

Il est intéressant de voir ce qu'on obtient avec `grades > 2`&nbsp;:

    > grades > 2
     [1] FALSE FALSE  TRUE FALSE  TRUE FALSE FALSE  TRUE  TRUE FALSE

On obtient un vecteur de valeurs booléennes ! *TRUE* si la note est supérieure
à 2, *FALSE* dans le cas contraire.

Rangeons ce vecteur de booléens dans une variable `mask` et servons nous de
cette nouvelle variable pour obtenir le sous-ensemble des notes supérieures
à 2&nbsp;:

    > mask <- grades > 2
    > grades[mask]
    [1] 3 3 4 5

Pour finir, utilisons directement un vecteur de booléens pour récupérer les
éléments n° 4, 5, 6, 9 et 10 (*F* et *T* sont des raccourcis pour *FALSE* et
*TRUE*)&nbsp;:

    > grades[c(F, F, F, T, T, T, F, F, T, T)]
    [1] 2 3 2 5 2

Voilà, mon premier article sur R est terminé, je vais certainement en écrire
plein d'autres dans un futur proche. J'espère que ce sujet vous intéresse ;)

    > q()


