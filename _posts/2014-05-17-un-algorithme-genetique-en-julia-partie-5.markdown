---
layout: post
title: "Un algorithme génétique en Julia - partie 5"
date: 2014-05-17 15:38
legacy: true
tags: [intermédiaire, julia, algorithme génétique]
---



Aujourd'hui je cherche à faire une fonction `crossover`, pour effectuer un
croisement entre deux chromosomes.

Soit les deux chromosomes suivants:

    julia> a = [1, 2, 3, 4, 5]

    julia> b = [6, 7, 8, 9, 0]

<!-- more -->

Pour obtenir la taille d'un tableau:

    julia> length(a)
    5

Pour obtenir le *point de croisement*, on tire au hasard:

    julia> cut_point = rand(1:length(a))
    4

Le nouveau chromosome sera composé du début du premier, jusqu'au point de
croisement:

    julia> cut_point = 3
    3
    julia> a[1:cut_point]
    3-element Array{Int32,1}:
     1
     2
     3

Puis de la fin du second chromosome:

    julia> a[cut_point + 1:end]
    2-element Array{Int32,1}:
     4
     5

Si on rassemble tout ça dans un tableau, on obtient notre nouveau
chromosome:

    julia> [ a[1:cut_point], b[cut_point + 1:end] ]
    5-element Array{Int32,1}:
     1
     2
     3
     9
     0

Il ne reste plus qu'à en faire une fonction:

{% highlight julia %}
function crossover(chromosome1, chromosome2)
  cut_point = rand(1:length(chromosome1))
  [ chromosome1[1:cut_point], chromosome2[cut_point + 1:end] ]
end
{% endhighlight %}



À demain.



