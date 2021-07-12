---
layout: post
title: "Les algorithmes génétiques démystifiés 46: Économie, la boucle principale"
date: 2013-12-19 14:26
legacy: true
tags: [algorithme génétique, ruby]
---



Après [le calcul du score](http://lkdjiin.github.io/blog/2013/12/16/les-algorithmes-genetiques-demystifies-45-economie-calcul-du-score/)
d'un individu, voici maintenant le coeur du programme, la classe
`GeneticAlgorithm`.

<!-- more -->

Cette classe est batie sur le même modèle que pour les problèmes vus
précédement, je ne vais donc pas la commenter en détails. Voici d'abord
les méthodes publiques:

{% highlight ruby %}
class GeneticAlgorithm
  def initialize(generations:, population:, capacity:, mutation_rate:, items:)
    @generations = generations
    @population = population
    @capacity = capacity
    @mutation_rate = mutation_rate
    @items = items
    @crossover = Crossover.new chromosome_size: items.size,
      mutation_rate: mutation_rate,
      items: items
    @best_ever = nil
  end

  def run
    @generations.times do |generation|
      Evaluator.new(capacity: @capacity, population: @population,
        items: @items).evaluate!
      find_best_ever(generation)
      next_generation
    end
    puts IndividualFormatter.display_best_ever individual: @best_ever,
      items: @items
  end

  # ...

end
{% endhighlight %}

L'initialisation est des plus basiques. Quant à la méthode `run`, elle
introduit une nouvelle classe : `IndividualFormatter`. Cette classe sera
discutée en détail dans le prochain article.

Maintenant les méthodes privées:

{% highlight ruby %}
class GeneticAlgorithm

  # ...

  private

  def find_best_ever(generation)
    best = @population.best
    @best_ever = best if best > @best_ever
    puts IndividualFormatter.display individual: @best_ever,
      generation: generation,
      items: @items,
      capacity: @capacity
  end

  def next_generation
    @population.sort_by! {|i| i.score}
    elite = @population.pop(4)
    pool = MatingPool.new(@population)
    population_size = @population.size
    @population.clear
    population_size.times do
      @population << @crossover.two_point(pool.random, pool.random)
    end
    @population.concat elite
  end
end
{% endhighlight %}

`find_best_ever` va trouver le meilleur individu à un moment précis, toutes
générations confondues *et* va afficher cet individu via `IndividualFormatter`
(*Je sais, c'est mal, cette méthode fait deux choses…*).

Quant à la méthode `next_generation`, c'est la même que pour
[le problème précédent](http://lkdjiin.github.io/blog/2013/11/16/les-algorithmes-genetiques-39-resolution-du-sac-a-dos/).



À demain.



