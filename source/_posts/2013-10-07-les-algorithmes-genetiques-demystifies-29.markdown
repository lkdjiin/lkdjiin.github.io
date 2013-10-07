---
layout: post
title: "Les algorithmes génétiques démystifiés 29"
date: 2013-10-07 18:48
comments: true
categories: [problème des 8 dames, extremum local, algorithme génétique, ruby, intermédiaire]
---

{% level 2 %}

Aujourd'hui on voit comment sortir de l'extremum local qui bloque notre
algorithme sur le problème des 8 dames.

<!-- more -->

Pour rappel, on essaie de faire fonctionner l'algorithme sur des échiquiers
de plus grande taille: 16, 20 ou 30 cases.
On a vu dernièrement que le faible taux de mutation (1/*n*, où *n* est la
taille de la population) qu'on emploie à du bon et du mauvais.
Il est bon puisqu'en exploitant les chromosomes, il mène assez vite à une
*presque* solution. Et il est mauvais puisque arrivé à cette *presque* solution,
qui est un extremum local, il ne permet pas l'exploration d'autres chromosomes.

À priori, on peut penser qu'il suffit d'augmenter le taux de mutation.
Effectivement, on obtiendra souvent de très bons résultats entre 1 et
3%. Mais souvent ne veut pas dire toujours et on restera régulièrement
coincé.

Une solution envisageable est d'avoir un taux de mutation variable. 1/*n*
au début, puis quand on sent arriver l'extremum local on augmente le taux
pour permettre à l'exploration de reprendre. Enfin, quand on pense être
sorti de l'extremum local, on repasse au taux original.

Voici la nouvelle classe `Mutator`, j'ai mis le code supplémentaire
entre `# ---`:

``` ruby
class Mutator
  def initialize(chromosome_size, mutation_rate)
    @size = chromosome_size
    @rate = mutation_rate
    # ---
    @original = mutation_rate
    # ---
  end

  def mutate(chromosome)
    @size.times do |index|
      if rand < @rate
        chromosome[index] = Gene.random(@size)
      end
    end
    chromosome
  end

  # ---
  def increase_mutation_rate
    @rate += 0.1
  end

  def original_mutation_rate
    @rate = @original
  end
  # ---
end
```

Le nouveau membre `@original` et les deux nouvelles méthodes permettent
d'augmenter le taux de mutation (de 10% carrément) et de le repasser
à l'original.

Les autres modifications du code sont en rapport avec ceci. Voici le code
complet:

``` ruby 8_queens.rb
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
    # ---
    old_best = 0
    same_best = 1
    # ---
    @generations.times do |generation|
      Evaluator.new(@board_size, @population).evaluate
      best = @population.best
      display(generation, best)
      if best.score > 1.0
        best.display
        exit
      end
      # ---
      if best.score == old_best
        same_best += 1
      else
        same_best = 1
        @crossover.original_mutation_rate
      end
      old_best = best.score
      if same_best == 5
        same_best = 1
        puts "Increase mutation rate to #{@crossover.increase_mutation_rate}"
      end
      # ---
      next_generation
    end
  end

  private

  def display(generation, best)
    puts "#{generation} #{best.score}"
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

  # ---
  def increase_mutation_rate
    @mutator.increase_mutation_rate
  end

  def original_mutation_rate
    @mutator.original_mutation_rate
  end
  # ---

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
    # ---
    @original = mutation_rate
    # ---
  end

  def mutate(chromosome)
    @size.times do |index|
      if rand < @rate
        chromosome[index] = Gene.random(@size)
      end
    end
    chromosome
  end

  # ---
  def increase_mutation_rate
    @rate += 0.1
  end

  def original_mutation_rate
    @rate = @original
  end
  # ---
end

generations = 1_000
board_size = 16
population = Population.new(board_size, 1000)
mutation = 0.001
GeneticAlgorithm.new(generations, population, board_size, mutation).run
```

On peut voir dans la méthode `run` que l'augmentation du taux de mutation
se fait lorsque 5 générations successives on le même meilleur score.
Avec cette méthode, je génère une solution pour un échiquier de 16x16 cases
avec une moyenne de 311 générations.

À demain.

{% connexe %}

