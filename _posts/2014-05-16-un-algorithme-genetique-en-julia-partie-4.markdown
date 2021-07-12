---
layout: post
title: "Un algorithme génétique en Julia - partie 4"
date: 2014-05-16 21:00
legacy: true
tags: [intermédiaire, julia, algorithme génétique]
---



Voici le fichier actuel:

{% highlight julia %}
create_chromosome(size) = rand(0:1, size)

function create_population(size, chromosome_size)
  [ create_chromosome(chromosome_size) for _ in 1:size ]
end

score(population) = map(sum, population)

function fight(scores, index1, index2)
  scores[index1] > scores[index2] ? index1 : index2
end
{% endhighlight %}

Aujourd'hui on ajoute la fonction `tournament`.

<!-- more -->

La voilà:

{% highlight julia %}
function tournament(scores)
  population_size = length(scores)
  selection_size = population_size * 2
  [ fight(scores, rand(1:population_size), rand(1:population_size))
    for _ in 1:selection_size ]
end
{% endhighlight %}

On voit que pour connaître la taille d'un tableau, on utilise la fonction
`length` et que je me sers encore d'une compréhension de liste pour produire
un tableau qui contiendra les index (sur la population) de mes reproducteurs.

    julia> include("main.jl")
    tournament (generic function with 1 method)

    julia> pop = create_population(8, 20)
    8-element Array{Array{Int32,1},1}:
     [0,0,0,0,1,1,0,0,0,0,0,1,0,1,1,0,0,1,1,0]
     [1,0,1,1,1,0,1,1,0,0,1,1,1,0,1,1,1,1,0,0]
     [1,0,1,1,0,1,0,0,1,0,0,1,0,0,0,0,1,1,0,1]
     [1,1,1,0,1,0,1,0,1,0,0,1,0,1,1,1,0,0,0,1]
     [1,1,1,1,0,1,0,0,0,1,0,0,1,0,1,0,1,1,0,1]
     [1,1,1,1,1,1,1,0,0,1,0,0,0,1,1,1,0,1,1,0]
     [0,1,1,1,1,1,1,0,1,1,1,1,0,1,0,0,0,1,1,0]
     [0,0,1,1,1,0,1,0,0,1,1,1,0,0,0,1,0,1,0,0]

    julia> scores = score(pop)
    8-element Array{Int32,1}:
      7
     13
      9
     11
     11
     13
     13
      9

    julia> tournament(scores)
    16-element Array{Int32,1}:
     5
     6
     6
     4
     4
     6
     7
     2
     6
     6
     3
     7
     2
     2
     6
     3

À plus tard pour la suite…



À demain.



