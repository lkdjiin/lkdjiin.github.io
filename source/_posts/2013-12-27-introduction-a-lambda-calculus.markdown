---
layout: post
title: "Introduction à Lambda Calculus"
date: 2013-12-27 14:53
comments: true
categories: [débutant, λ calculus, tutoriel]
---

{% level 1 %}

Pour mieux comprendre la programmation fonctionnelle, j'ai décidé
de plonger aux racines de ce paradigme, à savoir le langage λ calculus
(λ se prononce lambda).
Je rédigerais quelques articles sur ce sujet, en tentant à chaque fois
d'expliquer le plus simplement possible ce que j'aurais compris de ce
langage.

<!-- more -->

Le langage λ calculus, inventé dans la décennie 1930 par
[Alonzo Church](http://en.wikipedia.org/wiki/Alonzo_Church), repose sur
3 types d'expressions:

1. Les noms
2. Les fonctions
3. Les applications

Les noms
--------

Un nom peut être n'importe quelle suite de caractères affichables, à
l'exception des caractères utilisés pour définir une fonction ou
une application. Voici quelques exemples de noms possibles en
lambda calculus:

    x
    xavier
    1
    123
    0,345
    foo_BAR
    -
    @!^

Autrement dit, tout et n'importe quoi.

Les fonctions
---------------

Une fonction débute par le caractère lambda, est suivie d'un nom, puis d'un
point et enfin du corps de la fonction. Le corps de la fonction est
une expression, ce qui signifie que cela peut être un nom, une fonction ou
même une application.
Quelques exemples:

    λx.x
    λfoo.bar
    λa.λb.c
    λfoo.(λbar.ba truc)

Il faut noter que les fonctions lambda sont anonymes, elles n'ont pas de noms.
Le nom qui suit le caractère λ n'est donc pas le nom de la fonction, mais le
nom d'une variable liée, ou *bound variable*, qui sera utilisée dans les
applications pour transformer le corps de la fonction.

Si on décortique la fonction `λa.λb.c`, cela donne:

    variable liée: a
    corps        : λb.c

Les applications
----------------

Plutôt que d'*appeler* une fonction, en λ calculus on va *appliquer* une
fonction à un argument. Pour cela on écrit entre parenthèses une fonction,
suivie d'un argument. Par exemple:

    (λx.x foo)

signifie que l'on applique la fonction `λx.x` à l'argument `foo`.

Il faut encore signaler qu'en λ calculus tout est fonction. Donc:

    (a b)

est une application valide.

La prochaine fois, on verra comment évaluer une application.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

