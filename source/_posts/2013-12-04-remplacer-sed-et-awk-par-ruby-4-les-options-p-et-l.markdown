---
layout: post
title: "Remplacer Sed et Awk par Ruby 4: Les options -p et -l"
date: 2013-12-04 21:21
comments: true
categories: [sed, awk, ruby, débutant]
---

{% level 1 %}

Les options -p et -l de la ligne de commande de Ruby permettent de se
rapprocher encore un peu plus du comportement de Sed et Awk.  On reprend notre
fichier tout simple:

``` raw data.txt
1
2
3
4
5
6
7
8
9
```

Aujourd'hui l'objectif est d'ajouter une nouvelle colonne, qui nous dit si
le nombre est pair (p) ou impair (i). C'est un exemple trivial, mais
suffisant pour ce que je veux montrer.

<!-- more -->

Un premier script déjà concis
------------------------------
Voici un premier code possible, avec ce que nous connaissons déjà, c'est
à dire l'option -n:

``` ruby test1.rb
$_ = $_.chomp + ($_.to_i.even? ? " p" : " i")
puts $_
```

    [~]⇒ ruby -n test1.rb < data.txt 
    1 i
    2 p
    3 i
    4 p
    5 i
    6 p
    7 i
    8 p
    9 i

On peut noter que:

- contrairement à l'exemple précédent, on n'utilise pas les blocs BEGIN et
  END (voir [Premiers pas](http://lkdjiin.github.io/blog/2013/11/30/remplacer-sed-et-awk-par-ruby-2-premiers-pas/)
  et [BEGIN et END](http://lkdjiin.github.io/blog/2013/12/01/remplacer-sed-et-awk-par-ruby-3-begin-et-end/)).
- la variable prédéfinie `$_` est **accessible en écriture**.
- la variable prédéfinie `$_` contient le caractère de fin de ligne, il a
  fallu le supprimer avec `chomp`. C'est agaçant.
- on écrit chaque nouvelle ligne avec `puts`. C'est un pattern classique,
  il doit bien y avoir un truc pour nous éviter cela.

La même chose en plus court
--------------------------
Voici maintenant une réécriture du script ci-dessus, qui tire parti
des options -p et -l:

``` ruby test2.rb
$_ += $_.to_i.even? ? " p" : " i"
```

    [~]⇒ ruby -pl test2.rb < data.txt 
    1 i
    2 p
    3 i
    4 p
    5 i
    6 p
    7 i
    8 p
    9 i

Les explications de -p et -l
------------
L'option -p fonctionne comme l'option -n, mais en plus, affiche automatiquement
le contenu de la variable `$_` à la fin de la boucle de traitement.

L'option -l, quant à elle, s'occupe automatiquement du caractère de fin
de ligne en le supprimant.

À demain.

{% connexe %}

