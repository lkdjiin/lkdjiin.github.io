---
layout: post
title: "Mon premier programme Elixir"
date: 2013-07-22 07:52
comments: true
categories: [elixir, débutant]
---
{% level 1 %}

Pour apprendre Elixir, j'ai décidé de faire quelques tâches tirées du
[rosetta code](http://rosettacode.org/wiki/Category:Programming_Tasks).
Pour mon tout premier programme, je commence avec un classique: 99 bottles of beer.

<!-- more -->

Vous connaissez la chanson ? Le but du jeu est d'obtenir ça:

    99 bottles of beer on the wall
    99 bottles of beer
    Take one down, pass it around
    98 bottle of beer on the wall

    ...

    1 bottle of beer on the wall
    1 bottle of beer
    Take one down, pass it around
    0 bottles of beer on the wall

C'est parti. - *N'oubliez pas que c'est mon premier programme Elixir, le code
sera forcement maladroit.* - D'abord une version sans tenir compte du pluriel de "bottle".

``` elixir 99_bottle_of_beer_v1.exs
Enum.each 99..1, fn idx ->
  IO.puts "#{idx} bottles of beer on the wall"
  IO.puts "#{idx} bottles of beer"
  IO.puts "Take one down, pass it around"
  IO.puts "#{idx - 1} bottles of beer on the wall"
  IO.puts ""
end
```

On lance le programme comme ça:

    elixir 99_bottle_of_beer_v1.exs

Il y a pas mal de ressemblance avec Ruby. Notamment, l'interpolation
des chaînes de caractères est identique:

``` elixir
IO.puts "#{idx} bottles of beer on the wall"
```

La fameuse méthode `puts` de Ruby est utilisée pour sortir du texte.
Le fait que `puts` soit appelée d'un module `IO` me rappelle un peu
Java.
Voyons maintenant l'itération:

``` elixir
Enum.each 99..1, fn idx ->
  # ...
end
```

Tiens, on a déjà un truc qui ressemble à un pattern: `Module.méthode`. On
a vu `IO.puts`, on a maintenant `Enum.each`. On va donc itérer sur un *range*
`99..1`, et appliquer une fonction à chaque élément de ce *range*. La
fonction, anonyme, avec un argument, débute par `fn idx ->` ; `idx` prenant
à chaque itération la valeur de l'élément courant du *range*.

Je m'intéresse maintenant à une version qui tient compte du pluriel.

``` elixir 99_bottle_of_beer_v2.exs
defmodule Bottles do
  def run do
    Enum.each 99..1, fn idx ->
      IO.puts "#{idx} bottle#{plural(idx)} of beer on the wall"
      IO.puts "#{idx} bottle#{plural(idx)} of beer"
      IO.puts "Take one down, pass it around"
      IO.puts "#{idx - 1} bottle#{plural(idx-1)} of beer on the wall"
      IO.puts ""
    end
  end

  def plural num do
    if num == 1 do
      ""
    else
      "s"
    end
  end
end

Bottles.run
```

J'ai du enfermer mes fonctions dans un module, avec `defmodule`, puisqu'il
n'est pas permis d'utiliser `def` en dehors d'un module. L'intérieur de
la fonction `run` ne diffère pas vraiment de la version précédente.
La fonction `plural` est intéressante à commenter:

``` elixir
def plural num do
  if num == 1 do
    ""
  else
    "s"
  end
end
```

Comme avec Ruby, les arguments n'ont pas besoin d'être enfermés entre
parenthèses, mais on peut le faire. Pas besoin non plus d'un mot-clé
`return`, une fonction renvoie toujours une valeur, même de manière
implicite. Pour définir une fonction on utilise:
`def name args do`. Le `if` prends aussi un `do` à la fin. Elixir semble
en fait être assez cohérent et homogène:

    defmodule ... do ... end
    def       ... do ... end
    if        ... do ... end

Enfin, l'appel de la fonction `run` est sans surprise: `Bottles.run`. Je note
que je ne sais pas encore à quoi j'ai affaire avec les modules. Est-ce-qu'un
module est juste un espace de nommage ? Est-ce-qu'un module est plus qu'un
espace de nommage ?

Voilà pour une première approche d'Elixir, un langage qui ressemble
beaucoup à Ruby, et en même temps pas vraiment ;)

À demain.
{% connexe %}
