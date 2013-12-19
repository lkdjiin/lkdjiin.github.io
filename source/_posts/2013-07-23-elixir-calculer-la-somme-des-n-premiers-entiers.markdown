---
layout: post
title: "Elixir: calculer la somme des n premiers entiers"
date: 2013-07-23 07:43
comments: true
categories: [elixir, débutant, tutoriel]
---

{% level 1 %}

Pour illustrer la programmation récursive avec Elixir et montrer quelques
aspects sympathiques du langage, j'ai choisi un classique et très simple
problème mathématique: calculer la somme des n premiers entiers.
Par exemple:

    Somme des n premiers entiers si n vaut 5

    5 + 4 + 3 + 2 + 1 = 15

Super simple. C'est comme la factorielle mais avec des additions. Pas de quoi
choper des boutons, même si on déteste les maths. C'est un bon problème pour
illustrer les fonctions récursives. En programmation procédurale on ferait
quelque chose dans ce genre là:

    somme = 0
    for(i = n; i > 0; i--) {
      somme += n
    }

Ma première tentative avec Elixir donne le programme suivant:

<!-- more -->

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

Vous le lancez comme ça:

    $ elixir somme.exs 
    15

**Sachez dès maintenant que ce bout de code n'est pas dans l'esprit
Elixir.**  J'ai cherché à décomposer toutes les étapes, pas à faire quelque chose
de beau, ou d'optimisé, ou de compact. Alors, que fais ce programme ?

``` elixir
def run(n, acc) do
```

C'est la définition d'une méthode `run`. Le paramètre `acc` est le diminutif de
accumulator. Avoir un accumulateur est un truc très utilisé dans ce type de
fonction. On enregistre le résultat provisioire dans cet accumulateur, qui
est propagé tout au long de la pile d'appels.

``` elixir
somme = n + acc
suivant = n - 1
```

Ici je calcule deux résultats temporaires. Dans `somme` je place la somme du
nombre n actuel et de l'accumulateur. Quant à `suivant`, il contient la
prochaine valeur du nombre n.

``` elixir
if suivant == 0 do
  somme
else
  run(suivant, somme)
end
```

Dans une fonction récursive il faut évidemment un appel à cette même fonction.
Mais surtout il faut une
condition de sortie. Sans ce garde-fou, c'est la boucle infinie à tout les
coups. Ici la condition de sortie est `suivant == 0`. Quand le prochain nombre
à traiter atteint zéro, c'est le signe que la fonction a terminé son travail donc
je renvois le résultat actuel, qui est la somme de tous les nombres traités
jusqu'ici. Dans l'autre cas, c'est l'appel récursif: `run(suivant, somme)`.

Si vous avez du mal à comprendre la logique de ce programme, vous pouvez
ajouter un traçage:

``` elixir
defmodule Somme do
  def run(n, acc) do
    IO.puts "n: #{n} --- acc: #{acc}"
    # ...
```

Ce qui donnera le résultat suivant:

    $ elixir somme.exs 
    n: 5 --- acc: 0
    n: 4 --- acc: 5
    n: 3 --- acc: 9
    n: 2 --- acc: 12
    n: 1 --- acc: 14
    15

La prochaine fois je transformerais ce programme afin qu'il soit dans
l'esprit Elixir.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
