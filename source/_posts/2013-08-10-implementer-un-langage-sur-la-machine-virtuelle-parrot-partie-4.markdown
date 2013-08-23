---
layout: post
title: "Implémenter un langage sur la machine virtuelle Parrot - partie 4"
date: 2013-08-10 11:21
comments: true
categories: [intermédiaire, parrot, compilateur]
---

{% level 2 %}

Après avoir vu un premier
[programme très simple](http://lkdjiin.github.io/blog/2013/08/03/implementer-un-langage-sur-la-machine-virtuelle-parrot-partie-3/)
en PIR la dernière fois, on s'attaque aujourd'hui au calcul de la
factorielle. C'est pas beaucoup plus compliqué, mais
on va employer les registres de la VM Parrot.

<!-- more -->

La procédure factorial
----------------------

``` gas
.sub factorial
  .param int n
  .local int result

  if n == 0 goto ONE

  $I0 = n - 1
  $I1 = factorial($I0)
  result = n * $I1
  goto RETURN

ONE:
  result = 1

RETURN:
  .return(result)
.end

.sub main :main
  .local int out
  out = factorial(10)
  say out
.end
```

Ce qui est nouveau, c'est qu'ici j'utilise les registres:

    $I0 = n - 1
    $I1 = factorial($I0)
    result = n * $I1
    goto RETURN

En PIR, il n'est pas possible d'écrire directement:

    factorial(n - 1)

et encore moins:

    result = n * factorial(n - 1)

J'utilise donc les registres pour stocker les résultats temporaires.
Ils sont simples à utiliser et leur nombre est illimité.

Il faut noter qu'il n'y a pas d'obligation à utiliser les registres ici.
J'aurais aussi bien pu écrire le programme ainsi:

``` gas
.sub factorial
    .param int n
    .local int result, temp1, temp2

    if n == 0 goto ONE

    temp1 = n - 1
    temp2 = factorial(temp1)
    result = n * temp2
    goto RETURN

    ...
```

Mais je voulais montrer l'utilisation des registres.

Voilà, même si PIR permet de faire d'autres choses, je pense que j'en sais
suffisament sur lui pour commencer à
[implémenter Naam](http://lkdjiin.github.io/blog/2013/08/01/implementer-un-langage-sur-la-machine-virtuelle-parrot-partie-1/).

À demain.

{% connexe %}
