---
layout: post
title: "Un algorithme génétique pour les tours de Hanoi avec Opal.rb"
date: 2014-07-04 21:07
legacy: true
tags: [algorithme génétique, intermédiaire, ruby, opal]
---



Pour débuter la résolution du jeu des tours de Hanoi à l'aide d'un algorithme
génétique, j'ai envie de commencer par réfléchir à la représentation des
chromosomes, aux règles de mouvement, à la fonction d'évaluation, sans
forcément commencer à coder.

<!-- more -->

Les règles sont sur [wikipédia](http://fr.wikipedia.org/wiki/Tours_de_Hano%C3%AF).

J'apprend un truc qui va me servir, il faut 2^n - 1 coups au minimum pour
solutionner le problème (n est le nombre de disques). Du coup, mes chromosomes
devront posséder 2^n - 1 gènes. Ce qui ira sans trop de soucis jusqu'à une
dizaines de disques, mais au delà c'est pas gagné.

Pour faire simple, un gène va représenter un mouvement à l'aide d'un nombre:

    0 -> du 1er poteau au 2ème poteau
    1 -> du 1er poteau au 3ème poteau
    2 -> du 2ème poteau au 1er poteau
    3 -> du 2ème poteau au 3ème poteau
    4 -> du 3ème poteau au 1er poteau
    5 -> du 3ème poteau au 2ème poteau

Que faire quand un mouvement est illégal ? Le plus simple est de l'ignorer,
c'est donc ce que je vais faire.

La fonction d'évaluation, maintenant ? J'ai envie de donner un *poids* à
chaque disque suivant le poteau où il se trouve. Sur le premier poteau, un
disque vaut 0 point. Sur le second poteau, il vaut 1 point, et sur le
troisième, il vaut 2 points.

Par exemple, si je commence avec seulement 3 disques, la position suivante
vaut 0 point:

      x|x      |       |   
     xx|xx     |       |   
    xxx|xxx    |       |    

Alors que la suivante vaut 6 points:

       |       |      x|x   
       |       |     xx|xx 
       |       |    xxx|xxx

C'est pas suffisant pour différencier certaines solutions, donc on appliquera
un multiplicateur suivant la taille du disque, 1 pour le plus petit, 2 pour
le suivant et 3 pour le plus grand. Je vous laisse faire les calculs, ça me
prend trop de temps de faire les petits dessins ;)

Allez, la prochaine fois on code…



À demain.


