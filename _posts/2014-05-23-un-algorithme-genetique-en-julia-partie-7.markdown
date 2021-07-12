---
layout: post
title: "Un algorithme génétique en Julia - partie 7"
date: 2014-05-23 21:15
legacy: true
tags: [intermédiaire, julia, algorithme génétique]
---



Dans le [dernier article](blog/2014/05/18/un-algorithme-genetique-en-julia-partie-6/) sur Julia, j'avais eu un problème avec les
tableaux. En effet, leur comportement n'est pas celui que j'attendais:

    julia> a = [1, 2]
    julia> b = [3, 4]

    julia> [a, b]
    4-element Array{Int32,1}:
     1
     2
     3
     4

    julia> append!(a, b)
    4-element Array{Int32,1}:
     1
     2
     3
     4

Alors que j'attendais plutôt ceci : `[ [1, 2], [3, 4] ]`.

<!-- more -->

Pour régler ça, on doit pouvoir utiliser les tableaux multi-dimensionnels,
que Julia à tendance à nommer des «matrices». Vu mon niveau en math, ça
ne m'a pas vraiment attiré ;)

J'ai préféré regarder du coté des types. Pour l'instant, je comprends les
types comme des structures dans le genre de C, c'est-à-dire un ensemble de 
donnés regroupées au sein d'une même référence.

J'ai donc besoin d'un type, que j'appelerais `Chromosome`, qui va contenir
le tableau des gènes:

{% highlight julia %}
type Chromosome
  genes
end
{% endhighlight %}

On l'utilise comme ceci:

    julia> Chromosome([1, 2, 3])
    Chromosome([1,2,3])

Je vais devoir modifier un peu les fonctions définies jusqu'ici pour qu'elle
fonctionnent avec des `Chromosome`s. Par exemple, pour créer la population:

{% highlight julia %}
create_chromosome(size) = rand(0:1, size)

function create_population(size, chromosome_size)
  [ Chromosome(create_chromosome(chromosome_size)) for _ in 1:size ]
end
{% endhighlight %}

Ce qui donne:

    julia> pop = create_population(8, 20)
    8-element Array{Chromosome,1}:
     Chromosome([0,1,0,0,0,1,0,0,0,0,0,1,1,0,0,1,0,1,0,0])
     Chromosome([1,1,0,0,0,1,1,1,0,1,0,0,0,1,0,0,0,1,0,1])
     Chromosome([1,1,0,0,0,1,1,0,1,1,0,0,0,1,1,1,1,1,0,1])
     Chromosome([1,1,1,1,1,0,0,0,0,1,0,1,1,1,1,1,0,0,0,1])
     Chromosome([0,0,0,0,1,0,0,1,1,0,0,1,1,0,0,0,0,1,0,1])
     Chromosome([1,0,1,1,0,0,0,1,1,0,1,0,1,1,1,1,0,0,0,1])
     Chromosome([1,0,1,1,1,1,1,0,0,1,1,1,1,0,0,0,0,0,1,0])
     Chromosome([1,1,1,1,1,0,0,1,1,1,1,0,0,1,0,1,1,1,1,0])




À demain.



