---
layout: post
title: "Les tours de Hanoi - partie 3"
date: 2014-07-07 21:13
comments: true
categories: [algorithme génétique, intermédiaire, ruby, opal]
---

{% level 2 %}

On commence à coder l'algorithme génétique pour solutionner les tours de
Hanoi.

    $ tree
    .
    ├── ga.rb
    ├── lib
    │   ├── hanoi
    │   │   ├── board.rb
    │   │   ├── game.rb
    │   │   └── rules.rb
    │   └── hanoi.rb
    └── spec
        ├── board_spec.rb
        ├── game_spec.rb
        ├── integration
        │   └── game_spec.rb
        └── spec_helper.rb

<!-- more -->

``` ruby ga.rb
require './lib/hanoi/board'
require './lib/hanoi/game'
require './lib/hanoi/rules'

class Chromosome
  attr_reader :genes
  def initialize(number_of_pieces)
    @genes = Array.new(2 ** number_of_pieces - 1) { rand(6) }
  end
end

class Population
  def initialize(size, number_of_pieces)
    @population = Array.new(size) { Chromosome.new(number_of_pieces) }
  end

  def each(&block)
    @population.each(&block)
  end
end

class GA

  def initialize
    @population = Population.new(20, 3)
  end

  def evaluate
    @population.each do |chromosome|
      board = ::Hanoi::Board.new(3)
      game = ::Hanoi::Game.new(board)
      chromosome.genes.each do |gene|
        case gene
        when 0 then game.move from: 1, to: 2
        when 1 then game.move from: 1, to: 3
        when 2 then game.move from: 2, to: 1
        when 3 then game.move from: 2, to: 3
        when 4 then game.move from: 3, to: 1
        when 5 then game.move from: 3, to: 2
        end
      end
      p board.eval
    end
  end
end

ga = GA.new
ga.evaluate
```

Voilà de quoi commencer, des chromosomes, une population et l'évaluation
de chaque chromosome.

Ça fonctionne:

    $ ruby ga.rb 
    0
    5
    4
    2
    2
    4
    5
    5
    4
    4
    4
    1
    5
    4
    1
    0
    0
    2
    0
    4

Mais la fonction `GA#evaluate` me dérange. D'abord elle est trop longue, mais
rien qui ne puisse s'arranger avec un refactoring. Ce qui me dérange surtout
c'est qu'elle délègue la *vraie* évaluation à `Board`. Or, l'évaluation
dévrait faire partie intégrante de l'algorithme génétique, et pas de la
mécanique du jeu. C'est donc un point à améliorer avant d'aller plus loin.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
