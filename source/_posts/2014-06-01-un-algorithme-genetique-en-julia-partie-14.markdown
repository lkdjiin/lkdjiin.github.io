---
layout: post
title: "Un algorithme génétique en Julia - partie 14"
date: 2014-06-01 18:53
comments: true
categories: [intermédiaire, julia, algorithme génétique]
---

{% level 2 %}

Ça y est ! J'ai enfin un algorithme génétique écrit en Julia. Le programme
est certainement maladroit par endroit, mais il fonctionne.

<!-- more -->

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
  if rand() < 0.8
    scores[index1] > scores[index2] ? index1 : index2
  else
    scores[index1] > scores[index2] ? index2 : index1
  end
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
  mutator(g) = if rand(1:400) == 1
    g == 1 ? 0 : 1
  else
    g
  end
  Chromosome([ mutator(x)::Int for x in ch.genes ])
end

function run()
  current = create_population(400, 20)
  for i in 1:50
    scores = score(current)
    best = maximum(scores)
    println("Generation $i Best $best")
    selection = tournament(scores)
    current = reproduction([], current, selection)
  end
end
```

Voici un exemple d'utilisation:

    julia> include("main.jl")
    run (generic function with 1 method)

    julia> run()
    Generation 1 Best 18
    Generation 2 Best 18
    Generation 3 Best 17
    Generation 4 Best 17
    Generation 5 Best 18
    Generation 6 Best 17
    Generation 7 Best 18
    Generation 8 Best 19
    Generation 9 Best 19
    Generation 10 Best 19
    Generation 11 Best 20
    ...

Il me reste encore pas mal de choses à faire pour améliorer ce programme,
mais c'était un bon début pour apprendre le langage Julia.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
