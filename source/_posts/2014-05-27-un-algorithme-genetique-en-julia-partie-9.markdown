---
layout: post
title: "Un algorithme génétique en Julia - partie 9"
date: 2014-05-27 21:16
comments: true
categories: [intermédiaire, julia, algorithme génétique]
---

{% level 2 %}

Voici une fonction de mutation pour nos chromosomes.

``` julia
function mutate(ch)
  mutator(gene) = if rand(1:10) == 1
    gene == 1 ? 0 : 1
  else
    gene
  end
  Chromosome([ mutator(x) for x in ch.genes ])
end
```

<!-- more -->

Le code me semble un peu *maladroit*, mais a l'air de fonctionner pas trop
mal ;) La fonction `mutate` prend en entrée un chromosome et produit un autre
chromosome en sortie. On peut voir qu'une seconde fonction, `mutator`, est
définie à l'intérieur.

Ça marche pas mal, même si il faudra faire quelque chose pour l'*intervalle magique* `rand(1:10)`:

    julia> include("main.jl")
    mutate (generic function with 1 method)

    julia> c = Chromosome(create_genes(20))
    Chromosome([0,1,1,0,1,0,1,0,0,0,1,1,0,1,1,0,0,0,1,1])

    julia> mutate(c)
    Chromosome({0,1,1,0,1,0,1,0,0,0,1,1,0,1,0,0,0,0,0,1})

Le seul petit truc qui me dérange, c'est qu'on a `[...]` en entrée et
`{...}` en sortie. Je ne sais ni pourquoi, ni ce que c'est… On verra bien
au prochain épisode si c'est grave ;)

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

