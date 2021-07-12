---
layout: post
title: "Un algorithme génétique en Julia - partie 12"
date: 2014-05-30 21:11
legacy: true
tags: [intermédiaire, julia, algorithme génétique]
---



Avec ce que j'ai compris au [dernier épisode](blog/2014/05/29/un-algorithme-genetique-en-julia-partie-11/)
à propos des types, je peux améliorer la fonction `mutate`:

{% highlight julia %}
function mutate(ch)
  mutator(g) = if rand(1:10) == 1
    g == 1 ? 0 : 1
  else
    g
  end
  Chromosome([ mutator(x)::Int for x in ch.genes ])
end
{% endhighlight %}

<!-- more -->

Maintenant les gènes des chromosomes restent toujours des tableaux de
*Int*:

    julia> include("main.jl")
    mutate (generic function with 1 method)

    julia> pop = create_population(8, 20)
    8-element Array{Chromosome,1}:
     Chromosome([0,0,0,0,1,0,0,0,1,0,0,1,1,1,0,1,0,1,1,1])
     Chromosome([1,1,1,1,1,0,0,0,0,1,0,0,0,0,0,0,1,1,0,1])
     Chromosome([1,1,1,0,1,1,0,0,0,1,1,0,1,0,0,0,0,1,1,0])
     Chromosome([0,0,1,0,0,1,1,0,1,0,1,0,1,0,0,0,0,0,1,1])
     Chromosome([0,1,0,1,0,1,1,0,1,0,1,0,1,1,0,0,0,0,1,1])
     Chromosome([0,0,0,1,0,1,1,1,0,0,1,0,1,0,0,0,0,1,0,0])
     Chromosome([0,1,1,0,0,0,1,0,0,0,0,1,0,0,1,0,0,1,1,1])
     Chromosome([0,0,1,1,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0,1])

    julia> scores = score(pop)
    8-element Array{Int32,1}:
      9
      9
     10
      8
     10
      7
      8
      6

    julia> selection = tournament(scores)
    16-element Array{Int32,1}:
     7
     2
     7
     5
     2
     7
     3
     7
     2
     2
     1
     3
     6
     5
     2
     3

    julia> gen2 = reproduction([], pop, selection)
    8-element Array{Chromosome,1}:
     Chromosome([1,1,1,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,1])
     Chromosome([0,1,1,0,0,0,1,1,0,0,0,1,0,0,1,0,0,1,1,1])
     Chromosome([1,1,1,1,1,0,0,0,0,1,0,1,0,0,1,0,0,1,1,1])
     Chromosome([0,0,1,0,1,1,0,0,0,0,1,0,1,0,0,0,0,1,0,1])
     Chromosome([1,1,1,0,1,0,1,0,0,1,0,0,0,1,0,0,1,0,0,0])
     Chromosome([0,0,1,0,1,1,0,0,1,1,1,0,1,0,0,0,0,1,0,0])
     Chromosome([0,0,0,1,0,0,1,1,0,0,1,0,1,1,0,0,1,0,1,1])
     Chromosome([1,0,1,0,1,1,0,0,0,1,1,0,1,0,1,0,1,1,1,0])



À demain.


