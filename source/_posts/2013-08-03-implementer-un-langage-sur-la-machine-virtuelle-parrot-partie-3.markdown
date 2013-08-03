---
layout: post
title: "Implémenter un langage sur la machine virtuelle Parrot: partie 3"
date: 2013-08-03 08:16
comments: true
categories: [intermédiaire, parrot]
---

{% level 2 %}

Après avoir vu
[l'installation de Parrot](http://lkdjiin.github.io/blog/2013/08/02/implementer-un-langage-sur-la-machine-virtuelle-parrot-partie-2/),
il est temps d'écrire
notre premier programme en PIR. On va réaliser une version simpliste
d'une fonction qui renvoie le signe d'un nombre entier. On oublie
momentanément l'existence du zéro pour n'avoir que deux cas à traiter:
positif ou négatif.

    simple_sign(n) = 1 si n > 0
    simple_sign(n) = -1 sinon

<!-- more -->

La procédure simple_sign
------------------------
Voici un programme PIR qui fait ça:

``` gas simple_sign.pir
.sub simple_sign
  .param int n

  .local int result

  if n > 0 goto POSITIVE

  result = -1
  goto RETURN

POSITIVE:
  result = 1

RETURN:
  .return(result)
.end

.sub main :main
  .local int f
  f = simple_sign(4)
  say f
.end
```

Pour le lancer:

    parrot simple_sign.pir

Comme c'est de l'assembleur, le plus simple est d'expliquer les lignes de
code une par une.

    .sub simple_sign

C'est la définition d'une procédure `simple_sign`.

    .param int n

On signale à l'assembleur que notre fonction `simple_sign` prend un
argument de type `int` et qu'on souhaite s'y réferer
par la suite à l'aide du nom `n`. Ça ressemble donc fortement à une
déclaration de variable.

    .local int result

Cette fois on déclare une variable locale nommée. Elle est de type `int` et
on pourra s'y réferer avec le nom `result`.

    if n > 0 goto POSITIVE

Littéralement: Si la valeur de n est supérieur à zéro, sauter à l'adresse
réferencée par le label POSITIVE. Le saut conditionnel ou non est la seule
instruction de branchement dont on dispose avec PIR. Vous avez surement
appris que «goto c'est mal !». Oubliez le:

{% blockquote %}
En assembleur, goto est normal.
{% endblockquote %}

Et c'est souvent la seule façon d'obtenir le résultat voulu.

    result = -1

Voilà comment affecter une valeur.

    goto RETURN

Voilà un saut inconditionnel vers l'adresse réferencée par le label
RETURN.

    POSITIVE:
      result = 1

`POSITIVE:` définit une adresse. Chaque fois qu'on écrit `goto POSITIVE`, le
programme débranche à cette adresse (en fait à la ligne de code suivante).
Notez qu'on peut écrire les deux lignes précédentes en une seule :
`POSITIVE: result = 1`.

    RETURN:
      .return(result)

Définition du label RETURN puis renvoi du résultat avec la directive
`.return`. Les instructions qui commencent par un `.` sont des directives.
Ce qui veut dire qu'elles seront remplacées dans notre dos par plusieurs
instructions de plus bas niveau.

    .end

Fin de notre procédure `simple_sign`.

    .sub main :main

Nouvelle procédure, nommée `main`. Le `:main` dit à Parrot que c'est cette
procédure qu'il faut lancer à l'ouverture du programme. Si on ne le fait
pas, Parrot lance la première procédure qu'il rencontre.

    .local int f
    f = simple_sign(4)
    say f
    .end

La fin du programme se comprend maintenant facilement.

Voilà, si vous avez déjà travaillé en assembleur, la syntaxe PIR ne
devrait pas vous poser de problèmes particuliers car c'est un
assembleur de plutôt haut niveau ; par exemple on n'a pas encore eu
besoin de manipuler directement les registres. Si au contraire c'est
votre première rencontre avec un assembleur, vous allez devoir apprendre
à décomposer vos actions/pensées. Par exemple vous pourriez être tenté
d'écrire la procédure `main` de cette façon:

    .sub main :main
      say simple_sign(4)
    .end

Mais ça ne marcheras pas, il faut décomposer…

À demain.

