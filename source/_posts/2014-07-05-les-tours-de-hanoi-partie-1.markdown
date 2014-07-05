---
layout: post
title: "Les tours de Hanoi - partie 1"
date: 2014-07-05 15:25
comments: true
categories: [algorithme génétique, intermédiaire, ruby, opal]
---

{% level 2 %}

Je vais commencer par implémenter une classe `Board`, dont la tâche est
de retenir l'état du plateau de jeu, c'est à dire la position des pièces.
J'ai envie de faire des tests avec Rspec, donc voici les premiers fichiers:

    $ tree
    .
    ├── board.rb
    └── spec
        └── board_spec.rb

<!-- more -->

Voici les tests de `Board`, qui décrivent ce que j'attend de cette classe:

``` ruby spec/board_spec.rb
require './board'

describe Board do

  before { @board = Board.new(3) }

  it 'has a position' do
    expect(@board.position).to eq [ [3, 2, 1], [], [] ]
  end

  it 'accepts a position' do
    @board.position = [ [], [3], [2, 1] ]
    expect(@board.position).to eq [ [], [3], [2, 1] ]
  end

  describe 'position evalution' do

    specify { expect(@board.eval).to eq 0 }

    specify do
      @board.position = [ [], [3], [2, 1] ]
      expect(@board.eval).to eq 9
    end

    specify do
      @board.position = [ [], [], [3, 2, 1] ]
      expect(@board.eval).to eq 12
    end

  end

end
```

On doit pouvoir l'initialiser avec un nombre de pièces:

    before { @board = Board.new(3) }

À l'initialisation, les pièces sont en position de départ:

    it 'has a position' do
      expect(@board.position).to eq [ [3, 2, 1], [], [] ]
    end

On peut modifier la position à volonté:

    it 'accepts a position' do
      @board.position = [ [], [3], [2, 1] ]
      expect(@board.position).to eq [ [], [3], [2, 1] ]
    end

Enfin, la position actuelle peut être évaluée:

    describe 'position evalution' do

      specify { expect(@board.eval).to eq 0 }

      specify do
        @board.position = [ [], [3], [2, 1] ]
        expect(@board.eval).to eq 9
      end

      specify do
        @board.position = [ [], [], [3, 2, 1] ]
        expect(@board.eval).to eq 12
      end

    end

Pour finir, l'implémentation minimum:

``` ruby board.rb
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

end
```

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
