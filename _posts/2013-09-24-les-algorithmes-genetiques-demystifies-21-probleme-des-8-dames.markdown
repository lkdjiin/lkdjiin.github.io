---
layout: post
title: "Les algorithmes génétiques démystifiés 21: Problème des 8 dames"
date: 2013-09-24 10:04
legacy: true
tags: [algorithme génétique, ruby]
---



On va tenter de résoudre le problème des 8 dames à l'aide d'un algorithme
génétique.

{% blockquote Wikipédia http://fr.wikipedia.org/wiki/Probl%C3%A8me_des_huit_dames %}
Le but du problème des huit dames est de placer huit dames d'un jeu d'échecs sur un échiquier de 8 × 8 cases sans que les dames ne puissent se menacer mutuellement, conformément aux règles du jeu d'échecs (la couleur des pièces étant ignorée). Par conséquent, deux dames ne devraient jamais partager la même rangée, colonne, ou diagonale.
{% endblockquote %}

<!-- more -->

Avant toute chose, il faut trouver comment nos chromosomes vont pouvoir
représenter une solution potentielle. On pourrait coder ça sous forme
d'une chaîne de 64 bits, un par case, les 0 étants des cases vides et
les 1 étants les cases occupées par les dames. On pourrait aussi les coder
comme un tableau à deux dimensions, soit 8 rangées multipliées par 8 colonnes.
En y regardant de plus près (ou simplement en relisant la définition du
problème), on remarque que pour qu'une solution soit
viable, il faut une seule dame par rangée, une seule par colonne et une
seule par diagonale. On peut donc se contenter d'une liste (un tableau) de
8 nombres entiers, ces nombres étants le numéro de la colonne. Ainsi, pour
un échiquier de 4 x 4 cases, la liste `[0, 2, 3, 3]` équivaut à la position
suivante:

    ---------
    |D| | | |
    ---------
    | | |D| |
    ---------
    | | | |D|
    ---------
    | | | |D|
    ---------

Maintenant on peut s'occuper de la population. Je vais me servir du code
objet développé dans les derniers articles, en essayant de le modifier
le moins possible.

{% highlight ruby %}
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
      chromosome_size.times { @chromosome << Gene.random(chromosome_size) }
    end
  end
  private_class_method :new
end

class Gene
  def self.random(limit)
    rand(limit)
  end
end

class Population < Array
  def initialize(chromosome_size, population_size)
    population_size.times { self << Individual.random(chromosome_size) }
  end

  def best
    self.sort_by{|individual| individual.score}.last
  end
end
{% endhighlight %}

J'ai été obligé de modifier la méthode `initialize` de la classe `Individual`
ainsi que la classe `Gene`. Il faudra en tenir compte si on veut qu'un
framework sorte de tout ça…

Le prochain article traitera de l'évaluation du problème des 8 dames.





À demain.



