---
layout: post
title: "Ruby CSV tests et quelques questions"
date: 2014-07-03 21:31
legacy: true
tags: [ruby, csv, test]
---

Ça fait une semaine que je travaille sur des exports de statisques au format
CSV en Ruby. Ce n'est pas la première fois que je bosse sur ce genre de
fonctionnalité, que ce soit en Ruby ou dans un autre langage, et j'ai
toujours et encore le même problême: les tests.

<!-- more -->

Je m'explique. J'aime avoir des tests d'intégration qui s'assurent que les
bons fichiers soient produits. Par exemple:

    A, B, C, D ...
    1, 2, 3, 4 ...
    .
    .
    .

J'aime pouvoir contrôler la production de plusieurs fichiers, un pour chaque
scénario. Le gros soucis avec ce genre de test, c'est leur fragilité,
quand, par exemple, les utilisateurs s'aperçoivent que l'ordre des champs serait mieux
ainsi:

    A, C, D, B ...
    1, 3, 4, 2 ...
    .
    .
    .

Et là, il faut réécrire tous les fichiers de contrôle. Certains pouvant
contenir des dizaines de champs…

J'ai donc une question pour vous: comment faites vous pour faciliter ce
genre de tests ?



À demain.


