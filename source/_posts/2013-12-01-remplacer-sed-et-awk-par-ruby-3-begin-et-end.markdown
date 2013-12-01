---
layout: post
title: "Remplacer Sed et Awk par Ruby 3: BEGIN et END"
date: 2013-12-01 21:23
comments: true
categories: [sed, awk, ruby, débutant]
---

{% level 1 %}

Les blocs BEGIN et END du langage Ruby paraissent étranges pour beaucoup
de personnes. Ils sont inutiles (et certainement néfastes) pour des
programmes dit *classiques*. Ils peuvent être utiles pour un script.
Il sont indispensables pour remplacer Sed et Awk et on va donc les
regarder plus en détail.

<!-- more -->

Un exemple simple vaut mieux qu'un long discours:

``` ruby test1.rb
BEGIN { puts "avant" }
END { puts "après" }
puts "au milieu"
```

    [~]⇒ ruby test1.rb 
    avant
    au milieu
    après

`BEGIN` est donc l'endroit où on initialisera les variables et `END`
permettra de faire les calculs et l'affichage en fin de traitement.

Il faut savoir qu'on peut avoir plusieurs blocs
`BEGIN` et `END`. Les blocs `BEGIN` seront interprétés dans l'ordre
d'apparition, tandis que les blocs `END` seront interprétés dans l'ordre
inverse d'apparition:

``` ruby test2.rb
END { puts "end 1" }
END { puts "end 2" }
END { puts "end 3" }
BEGIN { puts "begin 1" }
BEGIN { puts "begin 2" }
BEGIN { puts "begin 3" }
```

    [~]⇒ ruby test2.rb
    begin 1
    begin 2
    begin 3
    end 3
    end 2
    end 1

Enfin, pour être exhaustif, on ne peut pas remplacer les `{}` par `do`
et `end`, comme on pourrait s'y attendre:

``` ruby test3.rb
BEGIN do
  puts "avant"
end
```

    [~]⇒ ruby test3.rb
    test3.rb:1: syntax error, unexpected keyword_do, expecting '{'
    test3.rb:3: syntax error, unexpected keyword_end, expecting end-of-input

À demain.

{% connexe %}



