---
layout: post
title: "Les algorithmes génétiques démystifiés 43: Économie, la population"
date: 2013-12-13 21:36
comments: true
categories: [algorithme génétique, intermédiaire, ruby, problème du sac à dos, économie, investissement]
---

{% level 2 %}

Après avoir vu dernièrement l'énoncé du [problème d'investissement](http://lkdjiin.github.io/blog/2013/12/11/les-algorithmes-genetiques-demystifies-42-un-probleme-deconomie/)
que je me propose de résoudre à l'aide d'un algorithme génétique, on
peut maintenant créer la population initiale.

<!-- more -->


Je me base sur le programme développé pour le problème du sac à dos
[disponible sur Github](https://github.com/lkdjiin/knapsack_genetic_algorithm/blob/master/knapsack3.rb).
Par contre, le code nécessite la version 2.1 de Ruby (disponible en
preview2 à l'heure où j'écris ces lignes).

Tout d'abord la classe `Individual`, qui recueille toutes les informations
sur nos individus: chromosome, score et fitness.

``` ruby
class Individual

  class << self
    def random(items)
      new(nil, items)
    end

    def from_chromosome(chromosome)
      new(chromosome)
    end

    def listing(chromosome:, items:)
      chromosome.map.with_index do |gene, index|
        "#{gene} #{items[index].name}"
      end.join("\n")
    end
  end

  attr_accessor :score, :fitness
  attr_reader :chromosome

  def initialize(chromosome = nil, items = nil)
    if chromosome
      @chromosome = chromosome
    else
      @chromosome = []
      items.each_with_index do |item, index|
        @chromosome << rand(0..item.number)
      end
    end
  end
  private_class_method :new

  def >(other)
    return true if other.nil?
    score > other.score
  end
end
```

J'ai ajouté une méthode de classe `listing`:

``` ruby
    def listing(chromosome:, items:)
      chromosome.map.with_index do |gene, index|
        "#{gene} #{items[index].name}"
      end.join("\n")
    end
```

Elle utilise [les arguments nommés requis](http://lkdjiin.github.io/blog/2013/11/27/du-nouveau-dans-ruby-2-dot-1-argument-nomme-et-requis/) de Ruby 2.1 et prend en
paramêtre un chromosome et la liste des actions (`Knapsack::ITEMS`,
[voir l'article précédent](http://lkdjiin.github.io/blog/2013/12/11/les-algorithmes-genetiques-demystifies-42-un-probleme-deconomie/)). Elle servira à afficher la liste des actions,
avec le nombre retenu pour chacune d'entres elles à la fin de l'algorithme.

Dans la méthode `initialize`, on peut voir comment je crée les chromosomes
de la population initiale:

``` ruby
    else
      @chromosome = []
      items.each_with_index do |item, index|
        @chromosome << rand(0..item.number)
      end
    end
```

`items` se réfère à la liste des actions (`Knapsack::ITEMS`). Un chromosome est
une liste de la même taille que `items`. Chaque gène (ou emplacement dans
la liste) est un nombre compris entre zéro et le nombre maximum d'actions
pour cette action particulière (voir encore une fois `Knapsack::ITEMS`).

Maintenant, pour la création de la population proprement dite, il n'y a
rien de nouveau:

``` ruby
class Population < Array
  def initialize(items, population_size)
    population_size.times { self << Individual.random(items) }
  end

  def best
    self.sort_by{|individual| individual.score}.last
  end
end
```

La prochaine fois on verra l'évaluation…



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
