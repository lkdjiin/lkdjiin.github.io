---
layout: post
title: "Les algorithmes génétiques démystifiés 13"
date: 2013-09-13 07:45
legacy: true
tags: [algorithme génétique, ruby]
---



Aujourd'hui on analyse ce qui arrive lorsqu'on joue avec les deux
variables dont on dispose pour l'instant : la taille de la population
et le taux de mutation.

<!-- more -->

Une définition de la performance
--------------------------------
Comment mesurer les performances d'un algorithme génétique ? Le nombre de
générations nécessaires pour trouver la solution vient tout de suite à
l'esprit. C'est toujours une mesure intéressante mais la plus importante
mesure reste évident **le temps** écoulé avant de trouver la solution.

Les mesures que je propose ici n'ont rien de très *scientifique*. Pour
chaque mesure j'ai fait tourner l'algorithme génétique développé dans les
[derniers articles](http://lkdjiin.github.io/blog/2013/09/08/les-algorithmes-genetiques-demystifies-8-le-paradoxe-du-singe-savant/) (le paradoxe du singe savant) 5 fois de suite.
C'est malgré tout suffisant pour dégager les tendances.

Performances suivant la taille de la population
-----------------------------------------------
Tout d'abord voyons ce qu'il se passe quand on augmente la taille de la
population.

    ======================================
    | population | génération | secondes |
    ======================================
    |        150 |       3277 |       32 |
    |------------------------------------|
    |        500 |        363 |       12 |
    |------------------------------------|
    |      1.000 |         81 |        5 |
    |------------------------------------|
    |     10.000 |         50 |       33 |
    |------------------------------------|

Ça ne devrait pas vous surprendre : plus la population augmente plus la
solution est trouvée en un minimum de générations. C'est presque la même
chose avec le temps, sauf que passé un certain point, il remonte en flêche.
C'est essentiellement du aux structures de données utilisées pour
construire le *mating pool*, évaluer les individus, etc. Et ça pose la
question de trouver un langage informatique adapté aux algorithmes
génétiques, langage qui soit un bon compromis entre facilité
d'écriture/lecture et performances brutes.

Performances suivant le taux de mutation
----------------------------------------

Voyons maintenant l'influence du taux de mutation.

    ======================================
    | taux de    | génération | secondes |
    | mutation * |            |          |
    ======================================
    |       0.02 |        293 |       20 |
    |------------------------------------|
    |       0.01 |         81 |        5 |
    |------------------------------------|
    |      0.005 |         75 |        5 |
    |------------------------------------|
    |      0.001 |         73 |        5 |
    |------------------------------------|
    |     0.0001 |         65 |        4 |
    |------------------------------------|
    |          0 |         ** |       ** |
    |------------------------------------|
    * Pour une population de 1000 individus.
    ** Aux environs de la 60ème génération si on a de la
       chance, sinon jamais car on atteint un extremum local.

Entre 1/100ème et 1/10.000ème la performance évolue, mais peu. À 2/100ème on
voit que la performance est déjà en train de chuter. En dessous de
1/10.000ème, le comportement se rapproche fortement d'un taux de zéro pourcent.
On considère généralement un taux de mutation de 1/*n* comme un bon
compromis (où *n* est la taille de la population).

Voilà, cette petite analyse est terminée.
Je ne sais pas de quoi je parlerais la prochaine fois, mais le sujet
est tellement vaste que j'ai l'impression que
cette série sur les algorithmes génétiques ne s'arretera jamais…





À demain.


