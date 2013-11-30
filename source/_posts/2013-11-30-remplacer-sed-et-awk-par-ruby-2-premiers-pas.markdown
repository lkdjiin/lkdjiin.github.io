---
layout: post
title: "Remplacer Sed et Awk par Ruby 2: Premiers pas"
date: 2013-11-30 16:29
comments: true
categories: [sed, awk, ruby, débutant]
---

{% level 1 %}

Vous avez décidé de [remplacer Sed et Awk par Ruby](http://lkdjiin.github.io/blog/2013/11/29/remplacer-sed-et-awk-par-ruby/) ? C'est parti.
L'objectif de cet article sera de calculer et d'afficher la somme des
valeurs contenues dans un fichier.

Prenons le simple fichier de données (data.txt) suivant:

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

<!-- more -->

Hello world!
------------
Le premier pas sera d'afficher chaque ligne du fichier de données. Voici le
script Ruby qui va faire ça:

``` ruby test1.rb
puts $_
```

La variable `$_` est une variable prédéfinie qui contient la ligne en cours
de traitement. Dans [l'article précédent](http://lkdjiin.github.io/blog/2013/11/29/remplacer-sed-et-awk-par-ruby/), j'évoquai la boucle de traitement
implicite. Pour dire à Ruby d'utiliser cette boucle implicite, on doit
utiliser l'option `-n` sur la ligne de commande:

``` bash
[~]⇒ ruby -n test1.rb < data.txt
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

BEGIN et END
------------
Pour calculer la somme des valeurs du fichier, il va falloir initialiser
une variable *avant* la boucle de traitement et l'afficher *après* la
boucle de traitement. Pour ça, Ruby reprend ce que fait Awk avec les
blocs `BEGIN {}` et `END {}`:

``` ruby one_shot.rb
BEGIN { total = 0 }

total += $_.to_i

END { puts total }
```

Le code placé dans un bloc `BEGIN` est executé avant tout autre code du
fichier. Celui placé dans un bloc `END` est executé après tout autre code
du fichier. Objectif atteint:

``` bash
[~]⇒ ruby -n one_shot.rb < data.txt 
45
```

Il faut noter qu'on a réussi notre objectif sans avoir explicitement à ouvrir
le fichier et à lire chaque ligne.

À demain.

{% connexe %}

