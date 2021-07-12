---
layout: post
title: "Les algorithmes génétiques démystifiés 41: Les individus invalides"
date: 2013-11-19 20:56
legacy: true
tags: [algorithme génétique, ruby]
---



La dernière fois on a vu comment l'introduction d'une petite dose
d'élitisme augmentait légèrement les performances d'un algorithme
génétique ([lire l'article](http://lkdjiin.github.io/blog/2013/11/18/les-algorithmes-genetiques-demystifies-40-ajout-delitisme/)).
Aujourd'hui on va *véritablement booster* ces performances
dans le cadre du problème du sac à dos, en tenant compte des individus
invalides.

<!-- more -->

Bref rappel du problème
-----------------------
La capacité du sac à dos est de 400 (grammes, kilos, unités, etc…) et on ne
doit pas la dépasser. Autrement dit, un couple {*poids*, *valeur*} de
{401, 1000} est bien plus proche de la solution idéale que le couple
{399, 500}. Pourtant, d'après les règles qu'on a utilisées jusqu'ici, la
solution {401, 1000} est purement et simplement éliminée puisque jugée
invalide.

Il est légitime de se demander ici si on ne perd pas des gènes précieux en
éliminant de telles solutions ?

Prise en compte des solutions invalides
---------------------------------------
L'idée est donc de permettre aux solutions qui dépassent un peu le poids
d'être prise en considération, sans pour autant mettre les solutions
invalides à égalité avec les solutions valides.

Pour cela, on va appliquer une pénalité, une sanction, aux solutions
invalides. Tout se passe dans la méthode `score` de la classe
`Evaluator`. Vous pouvez trouver le code complet de cette troisième
version du programme sur Github: [knapsack3.rb](https://github.com/lkdjiin/knapsack_genetic_algorithm/blob/master/knapsack3.rb).
Voici ce qui change:

{% highlight ruby %}
  def score(individual)
    # [...]
    if weight > @capacity
      value -= 2 * (weight - @capacity)
      value = 0 if value < 0
    end
    individual.score = value
  end
{% endhighlight %}

La pénalité appliquée à une sanction invalide est ici: 2 fois la différence
entre le poids du sac et sa capacité. C'est une valeur obtenue par
tatonnement, il n'y a rien de magique et vous devriez faire d'autres
essais… Je m'assure ensuite que la valeur n'est pas négative puisque la
méthode `fitness` attend une valeur positive.

Les performances
----------------
J'ai fait tourner chaque programme 200 fois et fait la moyenne de la
génération où la meilleure solution (score de 1030) est trouvée:

    Programme    | Génération moyenne | Remarques
    =========================================================
    knapsack.rb  |              72.06 | algo original
    ---------------------------------------------------------
    knapsack2.rb |              67.61 | + élite
    ---------------------------------------------------------
    knapsack3.rb |              22.55 | + élite + invalides

Le gain de performance est remarquable ! Moralité de cette affaire:
Pensez y à deux fois avant de jeter un chromosome invalide à la poubelle,
il contient peut-être des gènes importants.





À demain.



