---
layout: post
title: "Un algorithme génétique en Julia - partie 16"
date: 2014-06-03 21:02
legacy: true
tags: [intermédiaire, julia, algorithme génétique]
---



J'ai retiré les nombres magiques et renommé les quelques variables qui étaient
abrégées. Puis j'ai voulu commencer à documenter le code. Là je me suis
aperçu que le *typage* était une bonne façon de documenter Julia. Par
exemple:

{% highlight julia %}
type Chromosome
  genes::Array{Int}
end
{% endhighlight %}

m'apparait quasiment comme étant *auto-documenté*, comparé à la version
précédente:

{% highlight julia %}
type Chromosome
  genes
end
{% endhighlight %}

<!-- more -->

Plus de documentation plus tard, quand j'aurais trouvé si il y a un
*standard* en Julia (j'ai bien l'impression qu'il n'y en a pas :( ).

Pour l'instant, voici le code après son enième remaniement:

{% highlight julia %}
type Chromosome
  genes::Array{Int}
end

create_genes(size) = rand(0:1, size)

function create_population(size, chromosome_size)
  [ Chromosome(create_genes(chromosome_size)) for _ in 1:size ]
end

score(population) = map(chromosome -> sum(chromosome.genes), population)

function fight(scores, index1, index2, rate)
  if rand() < rate
    scores[index1] > scores[index2] ? index1 : index2
  else
    scores[index1] > scores[index2] ? index2 : index1
  end
end

function tournament(scores, rate)
  population_size = length(scores)
  selection_size = population_size * 2
  [ fight(scores, rand(1:population_size), rand(1:population_size), rate)
    for _ in 1:selection_size ]
end

function crossover(chromosome1, chromosome2, population_size)
  cut_point = rand(1:length(chromosome1.genes))
  first_part = chromosome1.genes[1:cut_point]
  second_part = chromosome2.genes[cut_point + 1:end]
  mutate(Chromosome([ first_part, second_part]), population_size)
end

function reproduction(new_population, current_population, selection,
                      population_size)
  if selection == []
    return new_population
  else
    father = current_population[selection[1]]
    mother = current_population[selection[2]]
    child = crossover(father, mother, population_size)
    reproduction([new_population, child], current_population, selection[3:end],
                 population_size)
  end
end

function mutate(chromosome, population_size)
  mutator(gene) = if rand(1:population_size) == 1
    gene == 1 ? 0 : 1
  else
    gene
  end
  Chromosome([ mutator(gene) for gene in chromosome.genes ])
end

function run(population_size, genes_size, generations, fight_rate)
  current = create_population(population_size, genes_size)
  for i in 1:generations
    scores = score(current)
    best = maximum(scores)
    println("Generation $i Best $best")
    selection = tournament(scores, fight_rate)
    current = reproduction([], current, selection, population_size)
  end
end
{% endhighlight %}



À demain.


