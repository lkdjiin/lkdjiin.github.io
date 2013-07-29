---
layout: post
title: "Elixir: calculer la somme des n premiers entiers - suite et fin"
date: 2013-07-24 07:35
comments: true
categories: [elixir, tutoriel]
---

{% level 1 %}

[Hier](http://lkdjiin.github.io/blog/2013/07/23/elixir-calculer-la-somme-des-n-premiers-entiers/),
je me suis arrêté sur cette version:

``` elixir somme.exs version 1
defmodule Somme do
  def run(n, acc) do
    somme = n + acc
    suivant = n - 1
    if suivant == 0 do
      somme
    else
      run(suivant, somme)
    end
  end
end

IO.puts Somme.run(5, 0)
```

Aujourd'hui je vais raffiner ce programme petit à petit pour montrer
quelques possibilités intéressantes du langage Elixir.

<!-- more -->

Pour commencer, je vais reécrire le if/else sur une seule ligne:

``` elixir somme.exs version 2
defmodule Somme do
  def run(n, acc) do
    somme = n + acc
    suivant = n - 1
    if suivant == 0, do: somme, else: run(suivant, somme)
  end
end

IO.puts Somme.run(5, 0)
```

Ça ne change rien à la logique du programme. Je voulais seulement vous montrer
une alternative. Il semblerait qu'Elixir n'aime pas trop les if, moi non plus
ça tombe bien. Dans la version suivante, qui pourra vous paraitre très étrange
de prime abord, je me débarasse de ce if/else qui pollue mon joli code:

``` elixir somme.exs version 3
defmodule Somme do
  def run(n, acc) when n == 0 do
    acc
  end

  def run(n, acc) do
    run(n - 1, n + acc)
  end
end

IO.puts Somme.run(5, 0)
```

Ça peut surprendre, hein ? La condition qui était précédement dans le `if` se
retrouve dans la définition de la fonction:

``` elixir
def run(n, acc) when n == 0 do
```

C'est ce qu'Elixir appelle un *guard*. Cette version de la fonction `run` sera
exécutée uniquement quand n vaut zéro. Dans les autres cas, c'est la seconde
version, généraliste, `run(n, acc) do` qui sera exécutée. Je ne sais pas si ce
truc existe dans d'autres langages, en tout cas je trouve ce comportement tout
simplement génial. Mais Elixir ne s'arrête pas là. Voici une nouvelle version:

``` elixir somme.exs version 4
defmodule Somme do
  def run(0, acc) do
    acc
  end

  def run(n, acc) do
    run(n - 1, n + acc)
  end
end

IO.puts Somme.run(5, 0)
```

Cette fois le *guard* est passé directement dans un argument de la fonction:

``` elixir
def run(0, acc) do
```

`def run(0, …` ne sera exécutée que quand le premier argument sera égal à zéro.
Et si on écrit les fonctions sur une seule ligne, on obtient un résultat très
compact:

``` elixir somme.exs version 5
defmodule Somme do
  def run(0, acc), do: acc
  def run(n, acc), do: run(n - 1, n + acc)
end

IO.puts Somme.run(5, 0)
```

Il reste encore une chose à prendre en compte: l'API. Devoir passer deux
arguments à la méthode `run` n'est pas très intuitif. Comme la valeur initiale
de l'accumulateur est toujours zéro, on s'arrange pour la cacher à
l'utilisateur:

``` elixir somme.exs version 6
defmodule Somme do
  def run(n), do: run_body(n, 0)
  defp run_body(0, acc), do: acc
  defp run_body(n, acc), do: run_body(n - 1, n + acc)
end

IO.puts Somme.run(5)
```

`run` est maintenant une fonction *bootstrap* qui sert à amorcer le vrai
travail. Mes deux anciennes fonctions `run` sont renommées `run_body` et
passe dans l'espace privé du module grâce à `defp`.
Pour finir, il faut noter qu'Elixir connait bien évidemment une
fonction `reduce`, et que le programme pourrait donc s'écrire comme ça:

``` elixir somme.exs version 7
defmodule Somme do
  def run(n), do: Enum.reduce(1..n, 0, fn(x, acc) -> x + acc end)
end
IO.puts Somme.run(5)
```

Mais avouez que ça aurait été moins drôle si j'avais commencé directement
par là.

Voilà, c'était un petit exemple de fonction récursive qui m'a permit de vous
montrer certaines particularités d'Elixir.

À demain.
