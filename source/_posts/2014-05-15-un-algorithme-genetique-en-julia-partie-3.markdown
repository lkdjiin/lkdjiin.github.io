---
layout: post
title: "Un algorithme génétique en Julia - partie 3"
date: 2014-05-15 21:28
comments: true
categories: [intermédiaire, julia, algorithme génétique]
---

{% level 2 %}

Aujourd'hui j'essaye de faire la sélection en vue de la reprodution ;)
Si vous aviez suivi ma série d'articles
[les algorithmes génétiques démystifiés](http://lkdjiin.github.io/blog/categories/algorithme-genetique/) vous savez de quoi je parle…

<!-- more -->

Voici d'abord les fonctions que j'ai jusqu'à présent :

``` julia main.jl
create_chromosome(size) = rand(0:1, size)

function create_population(size, chromosome_size)
  [ create_chromosome(chromosome_size) for _ in 1:size ]
end

score(population) = map(sum, population)
```

Alors j'ai remis des `_`, parce que sans j'y arrivais vraiment pas ;)
J'ai aussi ajouté l'argument `size` à la fonction de création d'un
chromosome pour éviter les nombres magiques.

Je veux opérer une sélection très simple : un tournoi. Pour ça, je
commence avec une fonction `fight` qui va renvoyer le meilleur chromosome
parmi deux:

``` julia
function fight(scores, index1, index2)
  scores[index1] > scores[index2] ? index1 : index2
end
```

En fait je ne passe pas de chromosome à cette fonction mais le tableau des
scores de la population, obtenu avec `score` et deux indexs.

    julia> include("main.jl")

    julia> pop = create_population(8, 20)
    8-element Array{Array{Int32,1},1}:
     [1,0,1,1,1,1,1,0,1,0,1,1,1,0,1,0,1,1,1,1]
     [1,1,0,0,0,1,0,1,0,1,0,0,0,0,0,1,0,1,1,1]
     [0,0,1,0,1,0,0,1,0,1,0,0,1,1,1,0,0,1,0,1]
     [1,1,0,1,1,1,0,1,1,0,0,1,1,1,0,1,0,1,1,1]
     [0,1,0,0,1,1,1,1,0,1,0,1,1,0,0,1,0,0,0,1]
     [1,1,0,0,0,1,0,0,1,0,1,1,1,0,1,1,1,0,1,0]
     [1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,1]
     [0,0,0,1,0,1,0,0,0,1,1,1,0,1,0,1,1,1,1,1]

    julia> scores = score(pop)
    8-element Array{Int32,1}:
     15
      9
      9
     14
     10
     11
     10
     11

Et la fonction `fight` renvoit l'index du meilleur des deux chromosomes
du *combat*:

    julia> fight(scores, 1, 2)
    1

    julia> fight(scores, 7, 8)
    8

La prochaine fois je pourrais organiser le tournoi proprement dit.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

