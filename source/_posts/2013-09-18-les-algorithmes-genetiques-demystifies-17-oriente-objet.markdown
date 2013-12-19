---
layout: post
title: "Les algorithmes génétiques démystifiés 17: Orienté Objet"
date: 2013-09-18 10:06
comments: true
categories: [paradoxe du singe savant, algorithme génétique, ruby, intermédiaire]
---

{% level 2 %}

Il est temps de donner du code orienté objet, non ? C'est ce à quoi je vais
m'attacher dans cet article et les quelques qui suivront. Après ça, je
pense qu'on pourra en finir avec le paradoxe du singe savant et passer à
quelque chose de plus intéressant.

<!-- more -->

Aujourd'hui on voit la création de la population selon le paradigme OO.
Il nous faut d'abord pouvoir créer un individu:

``` ruby
class Individual
  def self.random(chromosome_size)
    new(nil, chromosome_size)
  end

  def self.from_chromosome(chromosome)
    new(chromosome)
  end

  attr_accessor :score, :fitness
  attr_reader :chromosome

  def initialize(chromosome = nil, chromosome_size = nil)
    if chromosome
      @chromosome = chromosome
    else
      @chromosome = ""
      chromosome_size.times { @chromosome += Gene.random }
    end
  end
  private_class_method :new
end
```

Il y a deux manières de créer un individu. Lors de l'initialisation de
la population, on utilisera `Individual.random` avec la taille du chromosome.
Lors d'un accouplement, on utilisera `Individual.from_chromosome` avec le
chromosome résultant des parents. On note aussi les deux attributs `score`
et `fitness`. Je ne vais pas m'étaler sur le `score`, 1 point par lettre
bien placée, voilà, vous avez compris. Par contre `fitness` demande
quelques explications puisque c'est la première fois que j'emploie ce terme,
pourtant courant en algorithme génétique.

*Fitness* signifie aptitude. Quand le score mesure la performance d'un
individu face à un problème, le *fitness* mesure un individu par rapport
à son environnement, c'est à dire ici par rapport à la population. Il n'y
a rien de nouveau, on a déjà fait ça quand on normalisait les scores et
qu'on les transformaient en pourcentage (ou en fraction). Jusqu'ici
j'étais resté vague en parlant seulement d'évaluation et je profite du
code d'aujourd'hui pour introduire cette notion de *fitness*.

La production d'un gène est assurée par la classe `Gene`, qui ne demande
pas d'explications:

``` ruby
class Gene
  @@genes = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "

  def self.random
    @@genes[rand(@@genes.size)]
  end
end
```

Il reste à concevoir la population:

``` ruby
class Population < Array
  def initialize(chromosome_size, population_size)
    population_size.times { self << Individual.random(chromosome_size) }
  end

  def best
    self.sort_by{|individual| individual.score}.last
  end
end
```

La population étant basiquement une liste d'objets `Individual`, il me
semble logique d'hériter de `Array`. J'ai prévu une méthode `best` qui
permettra d'afficher la progression de l'algorithme et qui pourra aussi
servir pour la condition d'arrêt du programme quand `individual.score`
sera égal à la taille de la chaîne recherchée.

Demain ce sera au tour de l'évaluation d'être transformée en code objet.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

