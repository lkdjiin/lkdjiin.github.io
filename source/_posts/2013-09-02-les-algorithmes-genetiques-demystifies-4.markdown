---
layout: post
title: "Les algorithmes génétiques démystifiés 4"
date: 2013-09-02 08:26
comments: true
categories: [algorithme génétique, ruby, intermédiaire]
---

{% level 2 %}

Après en avoir terminer avec la création de la population et la sélection,
on passe à la reproduction.

<!-- more -->

Pour imiter ce qu'il se passe dans la nature, de manière fort simple,
on va définir une fonction `crossover` (croisé, croisement) qui prend
en entrée deux chromosomes, les parents, et qui produit en sortie une liste
de deux autres chromosomes, les enfants. Le principe est de couper chaque
chromosomes parents en deux parties A et B, puis d'assembler la partie A
du parent 1 avec la partie B du parent 2 et vice-versa. Voici une illustration
du processus avec des chromosomes de 8 bits (symbolisés par des lettres):

    parent1  aaabbbbb
    parent2  xxxyyyyy

    enfant1  aaayyyyy
    enfant2  xxxbbbbb

Voici donc la fonction:

``` ruby
def crossover(parent1, parent2)
  point = rand(1..47)
  child1 = [nil, parent1.last[0...point] + parent2.last[point..-1]]
  child2 = [nil, parent2.last[0...point] + parent1.last[point..-1]]
  [child1, child2]
end
```

Tout d'abord on défini le point de croisement avec `point = rand(1..47)`.
Puis on assemble les deux chromosomes enfants et on les renvoient sous
la forme d'une liste. Ce mode de reproduction est le plus simple, mais
pas forcement le plus efficace (on en reparle un autre jour).

On a maintenant tout ce qu'il faut pour produire la génération suivante:

``` ruby
def next_generation
  @selection = selection
  @population = []
  25.times do
    parent1, parent2 = @selection.slice!(0, 2)
    child1, child2 = crossover(parent1, parent2)
    child3, child4 = crossover(parent1, parent2)
    @population += [child1, child2, child3, child4]
  end
end
```

Après avoir sélectionné les 50 meilleures solutions (voir
[article précédent](http://lkdjiin.github.io/blog/2013/08/30/les-algorithmes-genetiques-demystifies-3/)) je crée une nouvelle population : Avec 50
individus on forme 25 couples qui vont chacun produire 4 enfants et
on retrouve une population de 100 solutions, sensée être globalement
meilleure que la génération précédente.

Même si c'est peu représentatif des phénomènes naturels, dans un algorithme
génétique les générations successives restent généralement stable en taille.
Ça évite aussi bien la croissance infinie (mémoire des ordinateurs limitée)
que le dépérissement de la population.

La prochaine fois on assemblera le tout pour voir notre algorithme
génétique à l'oeuvre.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

