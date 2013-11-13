---
layout: post
title: "Les algorithmes génétiques démystifiés 38: Évaluation du sac à dos"
date: 2013-11-13 09:32
comments: true
categories: [algorithme génétique, intermédiaire, ruby, problème du sac à dos]
---

{% level 2 %}

Comment évaluer le contenu du sac à dos ? C'est à cette question qu'on
répond aujourd'hui, après avoir vu hier la
[création de la population](http://lkdjiin.github.io/blog/2013/11/12/les-algorithmes-genetiques-demystifies-37-le-probleme-du-sac-a-dos/).

<!-- more -->

La fonction d'évaluation
-------------------------
Évaluer le contenu du sac à dos est trivial, on calcule sa valeur en
ajoutant la valeur de tout les objets, et on calcule son poids en ajoutant
le poids de tout les objets. Si le poids total dépasse la capacité du
sac à dos, on va considèrer *pour l'instant* que la solution est invalide, et
on ne lui permettra pas de se reproduire. Autrement dit, plus la valeur est
importante sans que le poids ne dépasse la capacité, meilleure est
l'individu.

La classe Evaluator
------------------------------
Voici le code complet de la classe `Evaluator`:

``` ruby
class Evaluator
  def initialize(capacity, population)
    @capacity = capacity
    @population = population
  end

  def evaluate
    @population.each {|individual| score(individual) }
    fitness
  end

  private

  def score(individual)
    value = 0
    weight = 0
    individual.chromosome.each_with_index do |item, index|
      if item
        value += Knapsack::ITEMS[index].value
        weight += Knapsack::ITEMS[index].weight
      end
    end
    if weight > @capacity
      individual.score = 0
    else
      individual.score = value
    end
  end

  def fitness
    total = @population.inject(0) {|sum, individual| sum + individual.score }
    size = @population.size
    @population.each do |individual|
      individual.fitness = individual.score.to_f / total * size
    end
  end
end
```

Explication du code
-------------------
Ce qui nous intéresse se passe dans la méthode `score`. Tout d'abord on
calcule la valeur totale et le poids total du sac à dos:

``` ruby
    individual.chromosome.each_with_index do |item, index|
      if item
        value += Knapsack::ITEMS[index].value
        weight += Knapsack::ITEMS[index].weight
      end
    end
```

Je rappelle qu'un chromosome est ici un Array de booléens, d'où la ligne
`if item` pour savoir si l'objet est présent ou non.

Une fois valeur et poids calculés, on peut donner un score:

``` ruby
    if weight > @capacity
      individual.score = 0
    else
      individual.score = value
    end
```

Si le poids du sac à dos dépasse sa capacité, on invalide l'individu en
mettant son score à zéro, ce qui lui interdira par la suite de se reproduire.
Sinon, le score est simplement la valeur totale du sac à dos.

La prochaine fois on mettra en place la sélection, le croisement, la mutation,
etc…

À demain.

{% connexe %}

