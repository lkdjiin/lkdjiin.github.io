---
layout: post
title: "Un algorithme génétique en Julia - partie 11"
date: 2014-05-29 21:13
comments: true
categories: [intermédiaire, julia, algorithme génétique]
---

{% level 2 %}

Hier on a vu qu'il y avait une légère différence de *type* entre les gènes
d'un chromosome avant et après la mutation:

    julia> c = Chromosome(create_genes(10))
    Chromosome([0,0,0,1,1,1,1,1,0,1])

    julia> d = mutate(c)
    Chromosome({0,0,0,1,1,1,1,1,0,1})

    julia> c.genes
    10-element Array{Int32,1}:

    julia> d.genes
    10-element Array{Any,1}:

C'est l'occasion de regarder un peu les types en Julia.

<!-- more -->

Voici une fonction `foo` qui additionne deux nombres:

    julia> foo(a, b) = a + b
    foo (generic function with 1 method)

    julia> foo(1, 2)
    3

Que se passe-t-il si je lui passe deux chaînes de caractères ?

    julia> foo("he", "llo")
    ERROR: no method +(ASCIIString, ASCIIString)

C'est une erreur, puisque la fonction `+` ne sait pas additionner des
chaînes.

Très bien, apprenons à `foo` l'addition de chaînes. Pour cela, on indique
à Julia ce qu'il faut faire lorsque les arguments reçus par `foo` sont de
type `String`:

    julia> foo(a::String, b::String) = "$a$b"
    foo (generic function with 2 methods)

    julia> foo("he", "llo")
    "hello"

Et `foo` fonctionne toujours avec des nombres:

    julia> foo(1, 2)
    3

La fonction `foo` possède 2 *méthodes*, une à utiliser quand elle reçoit des
arguments *String*, et une autre, à utiliser dans tous les autres cas:

    julia> methods(foo)
    # 2 methods for generic function "foo":
    foo(a::String,b::String) at none:1
    foo(a,b) at none:1

La prochaine fois on arrangera notre fonction `mutate` pour que les gènes
conservent le même type.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
