---
layout: post
title: "Un algorithme génétique en Julia - partie 1"
date: 2014-05-13 21:09
legacy: true
tags: [intermédiaire, julia, programmation fonctionnelle, algorithme génétique]
---



Pour continuer d'apprendre le langage Julia, je vais coder un algorithme
génétique simple.

<!-- more -->

Tout d'abord un chromosome, qui va contenir 10 valeurs, chaque valeur pouvant
être soit zéro, soit un:

    julia> chromosome() = rand(0:1, 10)

La fonction `rand` prend un *range* en premier paramêtre.

On teste cette fonction:

    julia> chromosome()
    10-element Array{Int32,1}:
     0
     1
     1
     1
     1
     1
     1
     0
     1
     1

Maintenant je veux une population:

    julia> population(size) = [ chromosome() for _ in 1:size ]

Il s'agit d'une *compréhension de liste*. Pour chaque valeur (symbolisée
par le `_`) du *range* de 1 à `size`, on applique la fonction `chromosome`.
Je peux donc avoir une population:

    julia> population(8)
    8-element Array{Array{Int32,1},1}:
     [1,0,1,0,1,0,0,1,1,0]
     [1,1,0,1,0,1,0,1,0,0]
     [1,0,1,1,0,1,1,1,1,1]
     [0,0,1,0,0,1,0,0,1,1]
     [1,0,0,1,0,1,1,1,1,0]
     [0,1,0,0,1,1,1,0,1,1]
     [0,0,0,1,0,1,0,1,1,1]
     [0,1,0,0,0,1,0,1,1,0]



À demain.



