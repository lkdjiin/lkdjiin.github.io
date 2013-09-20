---
layout: post
title: "Les algorithmes génétiques démystifiés 19"
date: 2013-09-20 09:31
comments: true
categories: [paradoxe du singe savant, algorithme génétique, ruby, intermédiaire]
---

{% level 2 %}

Suite et fin de la transformation en code orienté objet de l'algorithme
génétique sur le paradoxe du singe savant.

<!-- more -->

Le rôle de la classe `MatingPool` est de sélectionner les individus pour
la reproduction, suivant la méthode de la roue de la fortune:

``` ruby
class MatingPool
  def initialize(population)
    @mating_pool = []
    population.each do |individual|
      integer_part = individual.fitness.to_i
      real_part = individual.fitness - integer_part
      integer_part.times { @mating_pool << individual.dup }
      @mating_pool << individual.dup if rand < real_part
    end
    @size = @mating_pool.size
  end

  def random
    @mating_pool[rand(@size)]
  end
end
```

Au passage, la méthode `random` permettra de choisir un parent au hasard.

Les classes `Crossover` et `Mutator` s'occupent bien sûr de la partie
reproduction:

``` ruby
class Crossover
  def initialize(chromosome_size, mutation_rate)
    @size = chromosome_size
    @rate = mutation_rate
    @mutator = Mutator.new(@size, @rate)
  end

  def two_point(parent1, parent2)
    child = assemble(parent1, parent2, two_cut_points)
    child = @mutator.mutate(child)
    Individual.from_chromosome(child)
  end

  private

  def two_cut_points
    point1 = cut_point
    point2 = cut_point
    point1, point2 = point2, point1 if point1 > point2
    [point1, point2]
  end

  def cut_point
    rand(@size)
  end

  def assemble(parent1, parent2, points)
    point1, point2 = points
    parent1.chromosome[0...point1] + parent2.chromosome[point1..point2] +
      parent1.chromosome[point2+1..-1]
  end
end

class Mutator
  def initialize(chromosome_size, mutation_rate)
    @size = chromosome_size
    @rate = mutation_rate
  end

  def mutate(chromosome)
    @size.times {|index| chromosome[index] = Gene.random if rand < @rate }
    chromosome
  end
end
```

Le code de ces trois classes reprends plus ou moins le code développé en
style procédural dans les articles précédents et je ne vois pas tellement
ce que je pourrais en dire de plus. Il reste donc à lancer la machine:

``` ruby
generations = 500
search = "Mon royaume pour un cheval"
population = Population.new(search.size, 1000)
mutation = 0.001
GeneticAlgorithm.new(generations, population, search, mutation).run
```

Voilà, c'est terminé pour le code objet. Quand j'aurais présenter 2 ou 3
algorithmes génétiques de plus, on verra quelles classes résistent et peuvent
être réutilisées et lesquelles doivent être repensées. Ça nous conduira
éventuellement vers la création d'un framework…

À demain

{% connexe %}

