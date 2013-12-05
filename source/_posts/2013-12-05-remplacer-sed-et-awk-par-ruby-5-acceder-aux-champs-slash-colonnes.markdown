---
layout: post
title: "Remplacer Sed et Awk par Ruby 5: Accéder aux champs/colonnes"
date: 2013-12-05 19:12
comments: true
categories: [sed, awk, ruby, débutant]
---

{% level 1 %}

Toujours dans l'optique de remplacer Sed et Awk par Ruby,
et après avoir vu [les options -p et -l](http://lkdjiin.github.io/blog/2013/12/04/remplacer-sed-et-awk-par-ruby-4-les-options-p-et-l/), on voit
comment accéder facilement aux différentes colonnes
d'un fichier.

<!-- more -->

Voici le fichier de données tout simple qui va nous servir aujourd'hui:

``` raw data.txt
1 a
2 a
3 b
4 a
5 a
6 b
7 b
8 b
9 b
```

L'objectif est de calculer la somme des valeurs de la 1ère colonne,
uniquement quand la 2e colonne affiche `a`. On pourrait bien sûr splitter
la ligne (`$_`) pour obtenir nos champs, mais il y a plus rapide.
En activant l'option `-a` de la ligne de commande, Ruby va automatiquement
splitter chaque lignes du fichier de données dans la variable prédéfinie
`$F` (pour *Fields*). On n'a donc rien à faire ;) et on peut se concentrer
sur les calculs:

``` ruby test.rb
BEGIN { total = 0 }

total += $F[0].to_i if $F[1] == "a"

END { puts "Total: #{total}" }
```

    [~]⇒ ruby -an test.rb < data.txt 
    Total: 12


À demain.

{% connexe %}

