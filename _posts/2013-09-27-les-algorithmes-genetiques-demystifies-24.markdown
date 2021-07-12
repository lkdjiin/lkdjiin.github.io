---
layout: post
title: "Les algorithmes génétiques démystifiés 24"
date: 2013-09-27 18:26
legacy: true
tags: [algorithme génétique, ruby]
---



Maintenant vous connaissez bien la procédure : on trouve comment représenter
les chromosomes, comment les évaluer, puis une fois la population
initialisée on sélectionne, on croise, on mute…

<!-- more -->

Dernièrement on s'est occupé des chromosomes, de l'évaluation et de la
population. Reste à sélectionner, croiser, muter.
Je ne vais pas trop m'étendre sur le code permettant de faire ceci puisqu'il
s'agit pratiquement d'un copier/coller des classes développées
précédement. Voici le code permettant de résoudre le problème des
8 dames:

{% highlight ruby %}
class Individual
  def self.random(chromosome_size)
    new(nil, chromosome_size)
  end

  def self.from_chromosome(chromosome)
    new(chromosome)
  end

  def display
    @chromosome.each do |queen_position|
      row = ""
      @chromosome.size.times do |cell|
        row += (cell == queen_position) ? "Q" : "."
      end
      puts row
    end
  end

  attr_accessor :score, :fitness
  attr_reader :chromosome

  def initialize(chromosome = nil, chromosome_size = nil)
    if chromosome
      @chromosome = chromosome
    else
      @chromosome = []
      chromosome_size.times { @chromosome << Gene.random(chromosome_size) }
    end
  end
  private_class_method :new
end

class Gene
  def self.random(limit)
    rand(limit)
  end
end

class Population < Array
  def initialize(chromosome_size, population_size)
    population_size.times { self << Individual.random(chromosome_size) }
  end

  def best
    self.sort_by{|individual| individual.score}.last
  end
end

class Evaluator
  def initialize(board_size, population)
    @board_size = board_size
    @population = population
  end

  def evaluate
    @population.each {|individual| score(individual) }
    fitness
  end

  private

  def score(individual)
    individual.score = 1.0 / conflicts(individual)
  end

  def conflicts(individual)
    board = individual.chromosome
    score = 0
    @board_size.times do |row1|
      gene1 = board[row1]
      (row1+1...@board_size).each do |row2|
        gene2 = board[row2]
        score += 1 if gene1 == gene2
        score += 1 if row2 - row1 == (gene1 - gene2).abs
      end
    end
    score
  end

  def fitness
    total = @population.inject(0) {|sum, individual| sum + individual.score }
    @population.each do |individual|
      individual.fitness = individual.score.to_f / total * @population.size
    end
  end
end

class GeneticAlgorithm
  def initialize(generations, population, board_size, mutation_rate)
    @generations = generations
    @population = population
    @board_size = board_size
    @mutation_rate = mutation_rate
    @crossover = Crossover.new(board_size, mutation_rate)
  end

  def run
    @generations.times do |generation|
      Evaluator.new(@board_size, @population).evaluate
      best = @population.best
      display(generation, best)
      if best.score > 1.0
        best.display
        exit
      end
      next_generation
    end
  end

  private

  def display(generation, best)
    puts "----------------------"
    puts "Gen: #{generation}"
    puts "Best: #{best.score}"
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
    parent1.chromosome[0...point1] + 
      parent2.chromosome[point1..point2] +
      parent1.chromosome[point2+1..-1]
  end
end

class Mutator
  def initialize(chromosome_size, mutation_rate)
    @size = chromosome_size
    @rate = mutation_rate
  end

  def mutate(chromosome)
    @size.times do |index|
      if rand < @rate
        chromosome[index] = Gene.random(@size)
      end
    end
    chromosome
  end
end

generations = 500
board_size = 8
population = Population.new(board_size, 1000)
mutation = 0.001
GeneticAlgorithm.new(generations, population, board_size, mutation).run
{% endhighlight %}

J'ai seulement ajouter une méthode `display` à la classe `Individual` pour
afficher à l'écran une représentation de la solution. Voilà le programme
en marche:

    [~/genetic]⇒ ruby 8_queens.rb 
    ----------------------
    Gen: 0
    Best: 0.5
    ----------------------
    Gen: 1
    Best: 0.5
    .
    .
    .
    Gen: 11
    Best: 1.0
    ----------------------
    Gen: 12
    Best: Infinity
    .......Q
    .Q......
    ...Q....
    Q.......
    ......Q.
    ....Q...
    ..Q.....
    .....Q..

Cool ! Une solution en 12 générations. J'ai écrit récemment que trouver
une solution pour un échiquier de 8 x 8 cases ne serait pas difficile.
Et bien voilà, c'est fait. J'ai écrit aussi qu'il serait plus intéressant de
voir ce qu'il se passe avec des plateaux plus grands. Si on essaye en
doublant les dimensions:

{% highlight ruby %}
board_size = 16
{% endhighlight %}

On aura de grandes chances de voir ce type de sortie:

    [~/genetic]⇒ ruby 8_queens.rb 
    ----------------------
    Gen: 0
    Best: 0.125
    ----------------------
    Gen: 1
    Best: 0.16666666666666666
    .
    .
    .
    Gen: 70
    Best: 0.5
    ----------------------
    Gen: 71
    Best: 1.0
    .
    .
    .
    ----------------------
    Gen: 499
    Best: 1.0

Plus de 400 générations coincées sur le même résultat. Vous pensiez en
avoir fini avec les extremums locaux ? Et ben non, ils ne sont jamais
bien loin. 3 questions:

1. Comment je sais que l'algorithme est coinçé dans un extremum local ?
2. Pourquoi cet algorithme coinçe alors qu'il est écrit comme le
   précédent qui lui, ne coinçait pas ?
3. Comment on s'en sort ?

Avant de répondre à cela, je pense qu'il est plus que temps d'expliquer
quelques petites choses sur les extremums locaux:

1. Qu'est ce que c'est qu'un extremum local ?
2. Comment un extremum local se manifeste dans les algorithmes génétiques ?

J'ai mon sujet pour le prochain article…





À demain.



