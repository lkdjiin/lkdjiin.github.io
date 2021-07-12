---
layout: post
title: "Les algorithmes génétiques démystifiés: un point sur les performances"
date: 2013-10-09 11:57
legacy: true
tags: [algorithme génétique, ruby]
---



Aujourd'hui j'ai peu de temps à consacrer à ce blog. Je voudrais faire
un petit point sur les performances de différentes versions de
l'interpréteur Ruby.

<!-- more -->

Utiliser un interpréteur plus rapide est le moyen le plus simple de
booster les performances. J'ai calculé le temps que prends une génération
avec diverses tailles d'échiquier (16, 30 et 40) et trois interpréteurs
différents: MRI 1.9.3, MRI 2.0.0 et Rubinius 2.0.0.
Voici les résultats:

    Temps en seconde pour une génération
    ====================================

                     16x16  30x30  40x40

    MRI 1.9.3        0.092  0.24   0.40
    MRI 2.0.0        0.081  0.20   0.34
    Rubinius 2.0.0   0.075  0.15   0.24

C'est sans appel et sans surprise. On peut quand même noter que plus
la taille de l'échiquier augmente, plus Rubinius est proportionnelement rapide.
En gros 22% plus rapide sur un échiquier de 16x16 cases et 66% plus rapide sur
un échiquier de 40x40 cases.

Conclusion évidente: choisissez bien vos outils ;-)





À demain.



