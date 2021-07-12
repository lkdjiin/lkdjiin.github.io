---
layout: post
title: "La fonction d'identité en lambda calculus"
date: 2013-12-28 20:49
legacy: true
tags: [débutant, λ calculus]
---



Après avoir introduit les expressions du λ calculus, on voit
aujourd'hui comment appliquer une fonction sur un argument, à
travers la fonction d'identité.

<!-- more -->

La fonction d'identité est `λx.x`. Sa particularité est qu'elle renvoie
l'argument sur lequel elle est appliquée. Les noms utilisés n'ont aucune
importance: on pourrait l'écrire `λa.a`, ou encore `λtruc.truc`.

Voyons le mécanisme pour appliquer une fonction, en appliquant la fonction
d'identité sur l'argument `foo`:

    (λx.x foo)

Les parenthèses nous disent qu'il s'agit d'une application. L'expression qui
tient lieu de fonction est la fonction:

    λx.x

Et l'expression qui tient lieu d'argument est le nom:

    foo

Dans la fonction `λx.x`, le premier `x` est la variable liée, le second
`x` est le corps de la fonction.

Pour appliquer la fonction `λx.x` sur `foo`, il faut substituer chaque
occurences de la variable liée (x) dans le corps de la fonction par l'argument.
Le nom `x` dans le corps de la fonction est substitué par le nom
`foo`. Le résultat est donc:

    foo

Voilà, j'ai cherché à décomposer au maximum ce mécanisme fort simple de
substitution. N'ayez pas peur, il se pourrait que cela se complique
quelque peu par la suite ;-)



À demain.


