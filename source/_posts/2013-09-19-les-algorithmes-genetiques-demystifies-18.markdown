---
layout: post
title: "Les algorithmes génétiques démystifiés 18"
date: 2013-09-19 18:14
comments: true
categories: [paradoxe du singe savant, algorithme génétique, ruby, intermédiaire]
---

{% level 2 %}

On continue la transformation en code orienté objet de l'algorithme génétique
sur le paradoxe du singe savant.

<!-- more -->

D'abord la classe `Evaluator`, dont le rôle est d'évaluer la population:

``` ruby
class Evaluator
  def initialize(search_value, population)
    @search_value = search_value
    @population = population
  end

  def evaluate
    @population.each {|individual| score(individual) }
    fitness
  end

  private

  def score(individual)
    score = 0
    individual.chromosome.split('').each_with_index do |character, index|
      score += 1 if @search_value[index] == character
    end
    individual.score = score
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

On voit le découpage entre *score* et *fitness*, dont on a parlé hier.

Ensuite, voici la classe `GeneticAlgorithm`:

``` ruby
class GeneticAlgorithm
  def initialize(generations, population, search_value, mutation_rate)
    @generations = generations
    @population = population
    @search_value = search_value
    @mutation_rate = mutation_rate
    @crossover = Crossover.new(search_value.size, mutation_rate)
  end

  def run
    @generations.times do |generation|
      Evaluator.new(@search_value, @population).evaluate
      best = @population.best
      display(generation, best)
      exit if best.score == @search_value.size
      next_generation
    end
  end

  private

  def display(generation, best)
    puts "----------------------"
    puts "Gen: #{generation}"
    puts "Best: #{best.chromosome}"
  end

  def next_generation
    pool = MatingPool.new(@population)
    population_size = @population.size
    @population.clear
    population_size.times do
      @population << @crossover.two_point(pool.random, pool.random)
    end
  end
end
```

La méthode `run` remplace la fonction principale qu'on avait dans nos
scripts jusqu'ici. En écrivant l'article, je vois que la méthode `display`
me dérange : elle ne repose sur aucun membre, elle serait donc mieux dans
une classe à part entière.

Voilà, c'est un peu court en explication comme article et je m'en excuse
mais aujourd'hui je suis très préssé. La prochaine fois on parle des classes
`MatingPool`, `Crossover` et `Mutator`.

À demain.

{% connexe %}

