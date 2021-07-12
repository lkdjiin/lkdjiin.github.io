---
layout: post
title: "Un algorithme génétique en Julia - partie 2"
date: 2014-05-14 21:04
legacy: true
tags: [intermédiaire, julia, algorithme génétique]
---



Je continue l'algorithme génétique en Julia que j'ai commencé hier, en
cherchant la manière de calculer le score d'un chromosome.

<!-- more -->

Tout d'abord, je met les fonctions créées hier dans un fichier `main.jl`.
J'en profite pour les renommer. La convention en Julia veut qu'on accolle
les mots, sans séparation. Bien que je trouve ça curieux et illisible, je
vais m'y plier, après tout j'apprends…

{% highlight julia %}
createchromosome() = rand(0:1, 10)

createpopulation(size) = [ createchromosome() for _ in 1:size ]
{% endhighlight %}

Une fois l'interpréteur Julia lancé, je charge les définitions de fonctions
du fichier `main.jl`:

    julia> include("main.jl")

Puis je crée un chromosome:

    julia> chromosome = createchromosome()
    10-element Array{Int32,1}:
     1
     0
     0
     1
     1
     0
     0
     0
     1
     1

L'algorithme génétique que je veux mettre en place est le plus simple qui
existe. Je cherche à maximiser les chromosomes, c'est à dire que je veux
obtenir un chromosome qui ne comporte que des 1. Pour calculer son score,
il suffit donc de faire la somme de ses gènes. Très facile, puisque Julia
fournit la fonction `sum`:

    julia> sum(chromosome)
    5

Maintenant je dois trouver comment calculer le score de chaque chromosome.
Je crée donc une population:

    julia> population = createpopulation(8)
    8-element Array{Array{Int32,1},1}:
     [0,0,1,1,1,0,0,0,0,1]
     [1,0,0,0,1,0,1,1,0,0]
     [0,0,1,1,0,0,0,1,0,1]
     [1,0,0,1,1,0,0,0,0,0]
     [1,0,1,0,1,0,1,0,0,1]
     [0,1,1,1,1,1,0,1,0,0]
     [0,1,1,0,1,0,1,0,1,1]
     [0,1,1,1,1,1,0,1,0,0]

Et j'utilise `map`, qui va *mapper* la fonction `sum` sur chaque élément
de la population:

    julia> map(sum, population)
    8-element Array{Int32,1}:
     4
     4
     4
     3
     5
     6
     6
     6

Voilà, si on veut, on peut aussi créer une fonction `score`:

    julia> score(population) = map(sum, population)

    julia> score(population)
    8-element Array{Int32,1}:
     4
     4
     4
     3
     5
     6
     6
     6



À demain.



