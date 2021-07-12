---
layout: post
title: "Les tours de hanoi - partie 2"
date: 2014-07-06 13:02
legacy: true
tags: [algorithme génétique, intermédiaire, ruby, opal]
---



Je termine l'implémentation de la mécanique du jeu, pour pouvoir passer ensuite
à la construction de l'algorithme génétique.

    $ tree
    .
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

J'ai mis [le code](https://github.com/lkdjiin/hanoi) sur Github pour que vous puissiez le voir dans son
ensemble.

La classe `Board` gagne une méthode `move`, sans intelligence aucune:

{% highlight ruby %}
module Hanoi

  class Board

    def initialize(number_of_pieces)
      @pegs = [ (1..number_of_pieces).to_a.reverse, [], [] ]
    end

    def position
      @pegs
    end

    def position=(pegs)
      @pegs = pegs
    end

    def eval
      @pegs[1].reduce(0, :+) + 2 * @pegs[2].reduce(0, :+)
    end

    def move(from, to)
      piece = @pegs[from - 1].pop
      @pegs[to - 1].push(piece)
    end
  end

end
{% endhighlight %}

La mécanique du jeu est assurée par la classe `Game`, qui délègue à `Board` et
se repose sur un module `Rules` pour les décisions:

{% highlight ruby %}
module Hanoi

  class Game

    def initialize(board)
      @board = board
    end

    def move(from: 1, to: 1)
      @board.move(from, to) if Rules.valid?(@board, from, to)
    end

    def win?
      Rules.win?(@board)
    end

    def position
      @board.position
    end
  end

end
{% endhighlight %}

{% highlight ruby %}
module Hanoi::Rules

  def self.valid?(board, from, to)
    return false if board.position[from - 1].empty?
    return true if board.position[to - 1].empty?
    if board.position[from - 1][0] < board.position[to - 1][0]
      true
    else
      false
    end
  end

  def self.win?(board)
    if board.position[0].empty? && board.position[1].empty?
      true
    else
      false
    end
  end

end
{% endhighlight %}

Voilà, notre futur algorithme génétique a maintenant les moyens d'évaluer
une suite de mouvements, reste plus qu'à le coder ;)



À demain.


