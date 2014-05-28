---
layout: post
title: "Un algorithme génétique en Julia - partie 10"
date: 2014-05-28 21:19
comments: true
categories: [intermédiaire, julia, algorithme génétique]
---

{% level 2 %}

Voici le nouveau code de l'algorithme:

``` julia main.jl
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
  mutate(Chromosome([ first_part, second_part]))
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

function mutate(ch)
  mutator(g) = if rand(1:10) == 1
    g == 1 ? 0 : 1
  else
    g
  end
  Chromosome([ mutator(x) for x in ch.genes ])
end
```

<!-- more -->

J'ai simplement ajouter la fonction `mutate` dans `crossover`:

``` julia
function crossover(chromosome1, chromosome2)
  cut_point = rand(1:length(chromosome1.genes))
  first_part = chromosome1.genes[1:cut_point]
  second_part = chromosome2.genes[cut_point + 1:end]
  mutate(Chromosome([ first_part, second_part]))
end
```

Et ça fonctionne:

    julia> include("main.jl")

    julia> pop = create_population(8, 20)
    8-element Array{Chromosome,1}:
     Chromosome([0,0,0,1,1,1,0,0,0,0,0,1,1,0,1,1,0,1,0,1])
     Chromosome([1,0,1,1,0,0,0,0,1,1,0,1,1,0,1,0,1,0,1,1])
     Chromosome([1,0,1,1,1,0,1,0,0,0,1,0,0,1,0,1,0,0,0,1])
     Chromosome([1,1,1,1,1,0,0,0,0,0,1,1,0,1,1,0,1,0,0,1])
     Chromosome([0,1,1,0,0,0,0,0,0,1,1,1,0,1,0,0,1,0,1,0])
     Chromosome([0,1,0,1,1,0,0,1,0,0,1,1,1,1,0,0,0,0,0,1])
     Chromosome([1,1,1,0,0,0,1,1,0,1,1,0,0,0,1,1,1,0,0,0])
     Chromosome([1,0,0,0,1,0,0,1,0,1,0,1,0,0,0,0,1,0,0,0])

    julia> scores = score(pop)
    8-element Array{Int32,1}:
      9
     11
      9
     11
      8
      9
     10
      6

    julia> selection = tournament(scores)
    16-element Array{Int32,1}:
     7
     7
     7
     7
     ...
     4
     1
     1

    julia> gen2 = reproduction([], pop, selection)
    8-element Array{Chromosome,1}:
     Chromosome({1,1,1,0,0,0,1,1,0,1,1,0,1,0,1,1,1,0,0,0})
     Chromosome({1,1,1,0,0,0,1,0,0,1,1,0,0,0,1,1,0,0,0,0})
     Chromosome({0,1,0,0,1,0,0,1,0,1,1,1,1,0,1,0,1,0,1,1})
     Chromosome({1,0,1,0,0,1,0,0,1,1,1,1,0,1,0,0,1,0,1,1})
     Chromosome({1,0,1,1,0,0,0,0,1,0,0,1,1,0,1,1,0,0,0,1})
     Chromosome({1,1,1,1,1,1,0,0,0,0,1,1,0,1,1,1,1,0,0,0})
     Chromosome({0,1,1,0,0,0,1,0,0,0,1,1,0,1,1,0,1,0,0,1})
     Chromosome({0,0,0,1,1,1,0,0,0,1,0,1,1,0,1,1,0,1,0,1})

Mais un truc me dérange toujours, le tableau est *modifié* après passage
dans `mutate`:

    julia> c = chromosome(create_genes(10))
    chromosome([0,0,0,1,1,1,1,1,0,1])

    julia> d = mutate(c)
    Chromosome({0,0,0,1,1,1,1,1,0,1})

    julia> c.genes
    10-element Array{Int32,1}:
    ...

    julia> d.genes
    10-element Array{Any,1}:
    ...

C'est bien ça, le tableau n'est pas du même type. Bon, ça ne dérange pas
l'algorithme et c'est l'occasion d'un prochain article sur Julia ;)

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

