---
layout: post
title: "La fonction d'auto-application en Lambda Calculus"
date: 2013-12-31 15:51
legacy: true
tags: [débutant, λ calculus]
---



La dernière fois on a vu [la fonction d'identité](http://lkdjiin.github.io/blog/2013/12/28/la-fonction-didentite-en-lambda-calculus/), cette fois ci on
va parler de la fonction d'auto-application en λ calculus.

<!-- more -->

La fonction d'auto-application : λs.(s s)
-----------------------------------------

Appliquée à un argument A, la fonction d'auto-application crée une nouvelle
application, dont la fonction et l'argument sont A. Décortiquons d'abord un peu cette
fonction:

    λs.(s s)

Le premier `s`, coincé entre le caractère lambda et le point est la
variable liée. À droite du point, nous avons le corps de la fonction :

    (s s)

qui est une application.

(λs.(s s) foo)
--------------

Voyons ce qu'il se passe quand la fonction d'auto-application est appliquée
à l'argument `foo`:

    (λs.(s s) foo)

On remplace, dans le corps de la fonction, chaque occurence de la variable liée
par l'argument. Et c'est ce corps de fonction, après substitution, qui
est renvoyé:

    (foo foo)

`foo` étant un nom, il s'évalue en tant que lui-même, et on ne peut donc
pas aller plus loin.

(λs.(s s) λx.x)
---------------

Voyons maintenant l'application de la fonction d'auto-application à la
fonction d'identité, vue la dernière fois:

    (λs.(s s) λx.x)

Comme précédement, on remplace chaque occurence de `s` dans le corps de
la fonction:

    (λx.x λx.x)

Cette fois, l'application peut être évaluée. On a vu la dernière fois
que la fonction d'identité renvoyait l'argument, donc:

    λx.x

La prochaine fois, on verra ce qu'il se passe quand la fonction
d'auto-application est appliquée sur elle-même. En fait, si vous avez
compris le mécanisme, vous pouvez d'ores et déjà essayer par vous même…



À demain.



