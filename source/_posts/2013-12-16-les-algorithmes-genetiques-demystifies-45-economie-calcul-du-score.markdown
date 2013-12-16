---
layout: post
title: "Les algorithmes génétiques démystifiés 45: Économie, calcul du score"
date: 2013-12-16 18:15
comments: true
categories: [algorithme génétique, intermédiaire, ruby, problème du sac à dos, économie, investissement]
---

{% level 2 %}

Hier j'ai [survolé les trois classes/modules](http://lkdjiin.github.io/blog/2013/12/15/les-algorithmes-genetiques-demystifies-44-economie/) qui s'occupent de l'évaluation,
`Evaluator`, `Score` et `Fitness`. Aujourd'hui je parle en détail du
module `Score`.

<!-- more -->

Revoici donc le module `Score` au complet:

``` ruby
module Score
  def self.profit_and_cost(individual, items)
    profit = cost = 0
    individual.chromosome.each_with_index do |number, index|
      profit += items[index].profit * number
      cost += items[index].cost * number
    end
    [profit, cost]
  end

  def compute_score!
    @population.each {|individual| individual.score = score(individual) }
    shift
  end

  def score(individual)
    profit, cost = Score.profit_and_cost individual, @items
    malus(profit, cost)
  end

  def malus(profit, cost)
    profit -= 2 * (cost - @capacity) if cost > @capacity
    profit
  end

  def shift
    score_min = @population.map(&:score).min.abs
    @population.map {|individual| individual.score += score_min + 1 }
  end
end
```

Voyons d'abord rapidement la méthode `compute_score!`:

``` ruby
  def compute_score!
    @population.each {|individual| individual.score = score(individual) }
    shift
  end
```

On calcule/affecte le score de chaque individu. Puis on appelle une méthode
`shift`, dont on verra l'utilité bientôt.

La méthode `score` maintenant:

``` ruby
  def score(individual)
    profit, cost = Score.profit_and_cost individual, @items
    malus(profit, cost)
  end
```

On calcule le profit et le coût du portefeuille d'actions que représente
un individu via la méthode de classe `Score.profit_and_cost`. Puis on envoit
tout ça dans une méthode `malus`, qui va gérer les individus invalides.

La méthode `Score.profit_and_cost` est le *coeur* du calcul:

``` ruby
  def self.profit_and_cost(individual, items)
    profit = cost = 0
    individual.chromosome.each_with_index do |number, index|
      profit += items[index].profit * number
      cost += items[index].cost * number
    end
    [profit, cost]
  end
```

Comme je vais m'en servir dans d'autres parties du programme, j'en ai fait
une méthode de classe. On calcule le profit de l'individu en additionnant
le profit généré par chacune des actions. `items[index].profit` se
réfère à la liste `Knapsack::ITEMS` et `number` est un gène de l'individu.
On procède à l'identique pour le calculer le coût.

On peut passer à la méthode `malus`:

``` ruby
  def malus(profit, cost)
    profit -= 2 * (cost - @capacity) if cost > @capacity
    profit
  end
```

J'ai utilisé le même principe empirique que dans notre
[dernier programme](http://lkdjiin.github.io/blog/2013/11/19/les-algorithmes-genetiques-demystifies-41-les-individus-invalides/),
à savoir que si le coût dépasse la capacité d'investissement
je diminue le profit de deux fois la différence entre coût
et capacité.

Il reste à parler de la méthode `shift`:

``` ruby
  def shift
    score_min = @population.map(&:score).min.abs
    @population.map {|individual| individual.score += score_min + 1 }
  end
```

De la façon dont on a calculé le score, celui-ci peut être négatif. Ce
qui pose un problème avec le calcul de la *fitness*, qui attend un
nombre positif. La méthode `shift` sert à regler ceci.
Tout d'abord je calcule la valeur absolue du score minimum. Puis j'ajoute
cette valeur, plus 1, à chacun des scores. Ainsi je suis sûr que le score
minimal sera 1.

Voilà pour aujourd'hui. Comme d'habitude, c'est l'évaluation qui demande
le plus de reflexion et d'explications.

À demain.

{% connexe %}
