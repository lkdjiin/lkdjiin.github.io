---
layout: post
title: "Les algorithmes génétiques démystifiés 37: Le problème du sac à dos"
date: 2013-11-12 13:02
comments: true
categories: [algorithme génétique, intermédiaire, ruby, problème du sac à dos]
---

{% level 2 %}

Pour continuer notre exploration des algorithmes génétiques, on va
s'intéresser maintenant au problème du sac à dos:

{% blockquote Wikipédia http://fr.wikipedia.org/wiki/Probl%C3%A8me_du_sac_%C3%A0_dos %}
En algorithmique, le problème du sac à dos, noté également KP (en anglais,
Knapsack Problem) est un problème d'optimisation combinatoire. Il modélise une
situation analogue au remplissage d'un sac à dos, ne pouvant supporter plus
d'un certain poids, avec tout ou partie d'un ensemble donné d'objets ayant
chacun un poids et une valeur. Les objets mis dans le sac à dos doivent
maximiser la valeur totale, sans dépasser le poids maximum.
{% endblockquote %}

<!-- more -->

Un des intéret de ce problème est que certaines solutions *invalides* sont
plus proches de la meilleure solution que nombres de solutions *valides*.

De même, c'est un problème *théorique* qui peut être vu comme une
simplification de problèmes *pratiques*. Par exemple: «Mon bateau peut
transporter 100 containers, pour un poids de X tonnes. Je gagne plus ou
moins d'argent selon les containers transportés. Quels containers je dois
embarquer parmi un choix de 300 containers ?»

La liste des objets que je vais utiliser se trouve sur le
[projet RosettaCode](http://rosettacode.org/wiki/Knapsack_problem/0-1).

On commence tout de suite avec la création de la population:

``` ruby
KnapsackItem = Struct.new(:name, :weight, :value)

module Knapsack
  ITEMS = [
    KnapsackItem.new('map', 9, 150),
    KnapsackItem.new('compass', 13, 35),
    KnapsackItem.new('water', 153, 200),
    KnapsackItem.new('sandwich', 50, 160),
    KnapsackItem.new('glucose', 15, 60),
    KnapsackItem.new('tin', 68, 45),
    KnapsackItem.new('banana', 27, 60),
    KnapsackItem.new('apple', 39, 40),
    KnapsackItem.new('cheese', 23, 30),
    KnapsackItem.new('beer', 52, 10),
    KnapsackItem.new('suntan cream', 11, 70),
    KnapsackItem.new('camera', 32, 30),
    KnapsackItem.new('t-shirt', 24, 15),
    KnapsackItem.new('trousers', 48, 10),
    KnapsackItem.new('umbrella', 73, 40),
    KnapsackItem.new('waterproof trousers', 42, 70),
    KnapsackItem.new('waterproof overclothes', 43, 75),
    KnapsackItem.new('note-case', 22, 80),
    KnapsackItem.new('sunglasses', 7, 20),
    KnapsackItem.new('towel', 18, 12),
    KnapsackItem.new('socks', 4, 50),
    KnapsackItem.new('book', 30, 10),
  ]
end
```

Pour ceux qui ne connaissent pas Ruby, `Struct` permet de définir rapidement
une classe simpliste, une espèce de POxO (Plain Old "insérez votre langage"
Object). La classe `KnapsackItem` aura donc 3 accesseurs: `name`, `weight` et
`value`. On pourra accéder à la liste des objets avec `Knapsack::ITEMS`.

Maintenant la classe `Individual`:

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
      @chromosome = []
      chromosome_size.times { @chromosome << (rand(0..1) == 1) }
    end
  end
  private_class_method :new

  def chromosome_as_list
    list = []
    @chromosome.each_with_index do |gene, index|
      list << Knapsack::ITEMS[index].name if gene
    end
    list.join(', ')
  end

  def >(other)
    return true if other.nil?
    score > other.score
  end
end
```

Un chromosome est défini comme un Array de booléens:

``` ruby
      chromosome_size.times { @chromosome << (rand(0..1) == 1) }
```

Chaque case de l'Array nous indique si un objet est sélectionné (true) ou
non (false).

J'ai aussi ajouté 2 nouvelles méthodes à cette classe. Tout d'abord
`chromosome_as_list` produit une chaîne de caractères avec la liste
des objets sélectionnés dans le chromosome. Puis la méthode `>` nous
sera utile pour comparer deux chromosomes.

Reste la classe `Population`, qui est identique à ce que nous avons
déjà écrit avec d'autres algorithmes génétiques:

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

La prochaine fois on verra une première version de la méthode d'évaluation.

À demain.

{% connexe %}



