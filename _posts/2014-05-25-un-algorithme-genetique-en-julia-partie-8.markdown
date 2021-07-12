---
layout: post
title: "Un algorithme génétique en Julia - partie 8"
date: 2014-05-25 19:03
legacy: true
tags: [intermédiaire, julia, algorithme génétique]
---



Voici le programme actuel, qui tient compte de l'utilisation du type
`Chromosome`, ajouté dans la partie 7.

<!-- more -->

{% highlight julia %}
type Chromosome
  genes
end

create_genes(size) = rand(0:1, size)

function create_population(size, chromosome_size)
  [ Chromosome(create_genes(chromosome_size)) for _ in 1:size ]
end

score(population) = map(x -> sum(x.genes), population)

function fight(scores, index1, index2)
  scores[index1] > scores[index2] ? index1 : index2
end

function tournament(scores)
  population_size = length(scores)
  selection_size = population_size * 2
  [ fight(scores, rand(1:population_size), rand(1:population_size))
    for _ in 1:selection_size ]
end

function crossover(chromosome1, chromosome2)
  cut_point = rand(1:length(chromosome1.genes))
  first_part = chromosome1.genes[1:cut_point]
  second_part = chromosome2.genes[cut_point + 1:end]
  Chromosome([ first_part, second_part])
end

function reproduction(new_population, current_population, selection)
  if selection == []
    return new_population
  else
    father = current_population[selection[1]]
    mother = current_population[selection[2]]
    child = crossover(father, mother)
    reproduction([new_population, child], current_population, selection[3:end])
  end
end
{% endhighlight %}

Le changement le plus important est l'utilisation d'une fonction anonyme:

{% highlight julia %}
score(population) = map(x -> sum(x.genes), population)
{% endhighlight %}

On arrive bien à calculer la génération suivante:

    julia> include("main.jl")
    reproduction (generic function with 1 method)

    julia> pop = create_population(8, 20)
    8-element Array{Chromosome,1}:
     Chromosome([1,0,1,1,1,0,0,1,0,0,0,1,0,0,0,0,0,0,0,1])
     Chromosome([0,1,0,0,1,1,1,0,1,0,0,1,0,1,1,0,1,0,0,0])
     Chromosome([0,0,1,0,0,1,0,1,0,0,0,0,1,0,0,0,1,0,0,0])
     Chromosome([0,0,0,1,1,0,0,0,1,1,0,0,0,1,1,0,0,1,0,0])
     Chromosome([1,1,0,1,1,0,0,0,1,1,0,0,0,1,0,1,0,1,0,0])
     Chromosome([1,0,1,1,1,1,0,0,1,0,0,0,1,0,0,0,0,1,1,1])
     Chromosome([1,1,0,0,1,0,1,0,0,1,0,1,0,1,0,0,1,1,1,1])
     Chromosome([0,1,1,0,0,1,0,1,0,1,1,0,0,0,1,0,1,1,1,0])

    julia> scores = score(pop)
    8-element Array{Int32,1}:
      7
      9
      5
      7
      9
     10
     11
     10

    julia> selection = tournament(scores)
    16-element Array{Int32,1}:
     2
     4
     6
     1
     6
     5
     8
     7
     5
     7
     5
     6
     8
     4
     6
     6

    julia> generation2 = reproduction([], pop, selection)
    8-element Array{Chromosome,1}:
     Chromosome([0,1,0,0,1,1,1,0,1,1,0,0,0,1,1,0,0,1,0,0])
     Chromosome([1,0,1,1,1,0,0,1,0,0,0,1,0,0,0,0,0,0,0,1])
     Chromosome([1,0,1,1,1,1,0,0,1,0,0,0,1,0,0,0,0,1,0,0])
     Chromosome([0,1,1,0,0,1,1,0,0,1,0,1,0,1,0,0,1,1,1,1])
     Chromosome([1,1,0,1,1,0,0,0,1,1,0,0,0,1,0,0,1,1,1,1])
     Chromosome([1,1,0,1,1,1,0,0,1,0,0,0,1,0,0,0,0,1,1,1])
     Chromosome([0,1,1,0,0,1,0,1,0,1,1,0,0,0,1,0,1,1,0,0])
     Chromosome([1,0,1,1,1,1,0,0,1,0,0,0,1,0,0,0,0,1,1,1])

La première version de l'algorithme est bientôt finie…



À demain.



