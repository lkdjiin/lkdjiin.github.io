---
layout: post
title: "Les fonctions en Julia - partie 2"
date: 2014-05-12 21:05
legacy: true
tags: [intermédiaire, julia, programmation fonctionnelle]
---



Suite du tour d'horizon des fonctions en Julia. Je m'intéresse aujourd'hui
aux arguments par défaut et aux arguments nommés (souvent appellés
*keyword arguments*).

<!-- more -->

La fonction suivante possède un argument *normal*, `a`, et un argument par
défaut, `b`:

    julia> function add(a, b = 10)
               a + b
           end

Lorsqu'on l'appelle avec deux arguments, elle les additionne:

    julia> add(1, 2)
    3

Lorsqu'on l'appelle avec un seul argument, la valeur par défaut du second
argument est utilisé:

    julia> add(1)
    11

Tout ça est très classique, sans surprise. Voyons maintenant les arguments
nommés:

    julia> function add(a, b = 10 ; c = 0)
               a + b + c
           end

J'ai ici défini la fonction `add` avec un argument normal, `a`, un argument par
défaut, `b`, et un argument nommé, `c`. On doit séparer les arguments
nommés par un point-virgule.

Avec une seule valeur, `b` vaut 10 et `c` vaut 0:

    julia> add(1)
    11

Avec deux valeurs, `b` vaut 2 et `c` vaut 0:

    julia> add(1, 2)
    3

Avec trois valeurs, je suis obligé de *nommer* `c`:

    julia> add(1, 2, c = 10)
    13

Lorsqu'on a uniquement des arguments nommés, la syntaxe peut paraître
étrange, il ne faut pas oublier le point-virgule:

    julia> function foo(; bar = "bar", baz = "baz")
               "$bar $baz"
           end

    julia> foo()
    "bar baz"

    julia> foo(bar = "hello", baz = "world")
    "hello world"

Pour finir, on va mettre en exergue une différence de *portée* entre les
arguments par défaut et les arguments nommés. Soit `b` qui vaut 3:

    julia> b = 3
    3

Dans la fonction `foo` suivante je n'ai que des arguments par défaut.
L'argument `a` a comme valeur par défaut le contenu de `b`. Il s'agit du
contenu du `b` précédent, pas celui de l'argument:

    julia> foo(a = b, b = 9) = a + b

    julia> foo()
    12

Maintenant, même chose avec des arguments nommés:

    julia> foo(; a = b, b = 9) = a + b

    julia> foo()
    ERROR: b not defined

Oups ! Les arguments nommés n'ont pas accès au monde extérieur.



À demain.



