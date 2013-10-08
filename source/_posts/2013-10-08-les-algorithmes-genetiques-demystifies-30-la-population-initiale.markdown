---
layout: post
title: "Les algorithmes génétiques démystifiés 30: La population initiale"
date: 2013-10-08 21:30
comments: true
categories: [problème des 8 dames, algorithme génétique, ruby, intermédiaire]
---

{% level 2 %}

Aujourd'hui je voudrais parler un peu de la population initiale dans
l'algorithme génétique du problème des 8 dames et en général.

<!-- more -->

La population initiale
----------------------

Dans le paradoxe du singe savant, les chromosomes de la population initiale,
c'est à dire les phrases, étaient générés complètement au hasard. Ce n'est
pas le cas dans le programme qu'on a développé pour solutionner le problème
des 8 dames…

Les dames ne sont pas placées au hasard sur l'échiquier, mais sont
placées une seule par rangée. Cela a pour effet d'*orienter* la population
initiale. Les chromosomes de la population initiale appartiennent à un
sous-ensemble des chromosomes possibles. Et comme la fonction de mutation
s'applique elle aussi sur une rangée on ne peut jamais sortir de ce
sous-ensemble.

On pourrait même *orienter* encore plus la population initiale en faisant
en sorte que les dames ne puissent se trouver ni sur une même rangée, ni
sur une même colonne. Pour cela, on pourrait changer la méthode
`initialize` de la classe `Individual` ainsi:

``` ruby
  def initialize(chromosome = nil, chromosome_size = nil)
    if chromosome
      # Comme précédement…
    else
      @chromosome = (0...chromosome_size).to_a.shuffle
    end
  end
```

Alors est-ce-que c'est bien d'orienter la population initiale ? Ça dépend.
Le truc c'est qu'on ne possède pas toujours une totale compréhension du
problème et de l'ensemble des solutions potentielles. Et bien souvent,
orienter la population initiale d'une manière que l'on *croit* bonne a pour
effet d'emmener le programme dans un extremum local d'où il peut être
long de sortir. Il est difficile d'obtenir la preuve qu'on puisse se passer
de certains gènes…

À demain.

{% connexe %}

