---
layout: post
title: "Les algorithmes génétiques démystifiés 44: Économie"
date: 2013-12-15 18:25
legacy: true
tags: [algorithme génétique, ruby]
---



Maintenant que [la population initiale est créée](),
voyons comment l'évaluer.

<!-- more -->

Voici la classe `Evaluator`, qui a pris un coup de jeune:

{% highlight ruby %}
class Evaluator
  include Score
  include Fitness

  def initialize(capacity:, population:, items:)
    @capacity = capacity
    @population = population
    @items = items
  end

  def evaluate!
    compute_score!
    compute_fitness!
  end
end
{% endhighlight %}

J'ai transferé les calculs du score et de la *fitness* dans des modules
car cette classe `Evaluator` commence à enfler (et aussi car je teste
quelques idées en vue d'un futur framework).

Le module `Score` est bien sûr responsable de l'évaluation d'un
portefeuille d'actions. Je le présenterais demain, car je n'ai
malheureusement pas le temps nécessaire aujourd'hui. Je vous donne
malgré tout le code dès maintenant:

{% highlight ruby %}
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
{% endhighlight %}


En ce qui concerne le module `Fitness`, le code est le même que
d'habitude.

{% highlight ruby %}
module Fitness
  def compute_fitness!
    total = @population.inject(0) {|sum, individual| sum + individual.score }
    size = @population.size
    @population.each do |individual|
      individual.fitness = individual.score.to_f / total * size
    end
  end
end
{% endhighlight %}

Voilà, demain on verra en détail le module `Score`.





À demain.


