---
layout: post
title: "Un algorithme génétique en Julia - partie 6"
date: 2014-05-18 20:47
comments: true
categories: [intermédiaire, julia, algorithme génétique]
---

{% level 2 %}

Aujourd'hui je tente d'écrire une fonction de reproduction.
Je me dis qu'une fonction récursive serait ici la bienvenue:

``` julia
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
```

<!-- more -->

Explications ligne par ligne:

    function reproduction(new_population, current_population, selection)

`new_population` est un accumulateur, qui débute comme un tableau vide.
`current_population` est un tableau qui contient la génération courante et qui
ne changera pas. `selection` est un tableau qui contient les indexs des
reproducteurs par rapport à `current_population`.

    if selection == []
      return new_population

C'est la condition de sortie de cette fonction récursive. Au fur et à mesure,
`selection` va être vidé des ses éléments.

    father = current_population[selection[1]]
    mother = current_population[selection[2]]
    child = crossover(father, mother)

On produit un nouvel individu (`child`) par le croisement de deux éléments de
`current_population`, pointés par les deux premiers éléments de `selection`.

    reproduction([new_population, child], current_population, selection[3:end])

On appelle à nouveau la fonction `reproduction`, en ajoutant le nouvel individu
et en retirant les deux premiers éléments de `selection`.

Ça fonctionne presque, mais pas tout à fait !
En effet:

    julia> include("main.jl")
    reproduction (generic function with 1 method)

    julia> population = create_population(8, 20)
    8-element Array{Array{Int32,1},1}:
     [1,0,1,1,1,1,0,0,1,0,0,0,0,0,1,0,1,0,1,0]
     [0,1,0,1,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,1]
     [0,1,1,0,1,0,1,0,0,0,1,0,0,1,1,0,0,1,0,1]
     [1,1,0,1,1,1,0,1,0,0,0,0,1,0,0,1,1,1,0,1]
     [1,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,1,1]
     [0,0,0,1,0,1,1,0,0,1,0,0,0,0,0,1,0,0,0,0]
     [1,0,0,0,1,0,1,1,1,1,1,1,0,1,0,0,0,0,1,1]
     [0,1,0,0,0,1,0,0,1,1,1,0,1,0,0,1,0,0,0,1]

    julia> scores = score(population)
    8-element Array{Int32,1}:
      9
      9
      9
     11
     11
      5
     11
      8

    julia> selection = tournament(scores)
    16-element Array{Int32,1}:
     2
     5
     4
     1
     5
     6
     5
     5
     4
     4
     6
     5
     4
     1
     1
     6

    julia> selection = tournament(scores)
    16-element Array{Int32,1}:
     2
     7
     3
     1
     3
     3
     1
     4
     7
     7
     7
     8
     5
     4
     7
     4

    julia> generation2 = reproduction([], population, selection)
    160-element Array{Int32,1}:
     0
     1
     0
     1
     0
     0
     0
     0
     1
     1
     ⋮
     1
     1
     0
     1
     0
     0
     0
     0
     1
     1

La fonction `reproduction` ne produit pas un tableau de 8 chromosomes de
longueur 20, mais un tableau de 160 entiers. Je sens qu'il y a un truc
vraiment cool avec les tableaux en Julia, mais j'ai la preuve que je n'ai pas
encore tout compris ;)

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

