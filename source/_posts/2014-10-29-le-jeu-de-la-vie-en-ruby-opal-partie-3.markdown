---
layout: post
title: "Le jeu de la vie en ruby (opal) - partie 3"
date: 2014-10-29 07:18
comments: true
categories: [jeu de la vie, ruby, opal]
---

{% level 2 %}

Il est temps de tout assembler, pour ça on va écrire une classe `Game` qui va
jouer le rôle de chef d'orchestre.

<!-- more -->

La classe Game
--------------

``` ruby
class Game

  def initialize(generation, canvas, iterations)
    @iterations = iterations
    @height = generation.size
    @width = generation.first.size
    @generation = generation
    @canvas = canvas
  end

  def start
    draw
    @iterations -= 1
    if @iterations > 0
      update
      after_ms(500) { start }
    end
  end

  def draw
    @canvas.clear
    @generation.each_with_index do |line, y|
      line.each_with_index do |cell, x|
        @canvas.pixel(x, y) if cell == 1
      end
    end
  end

  def update
    new_generation = (0...@height).map do |y|
      (0...@width).map do |x|
        extractor = NeighborhoodExtractor.new(@generation, x, y)
        Neighborhood.new(extractor.cells).next_state
      end
    end
    @generation = new_generation
  end

end
```

Rien d'exceptionnel dans ce code, à part la ligne suivante, extraite de la
méthode `start`:

``` ruby
      after_ms(500) { start }
```

Qu'est-ce que c'est que cette méthode `after_ms` ?

Je ne peux pas faire une bête boucle `loop`, ou un appel récursif à `start`
puisqu'on est en Opal.rb, et pas *vraiment* en Ruby. Le code qui tourne, au
final, sera du Javascript. Et si on n'insère pas des petites pauses, le
navigateur ne va pas aimer du tout. Et puisqu'en Javascript il n'existe pas de
fonction `pause`, il n'y en a pas non plus en Opal.rb.

J'avoue que je me suis gratter un peu la tête avant de trouver une solution
toute simple. Il suffit d'écrire un *wrapper* autour de la fonction Javascript
`setTimeout`:

``` ruby app/kernel.rb
module Kernel

  def after_ms(n, &block)
    `setTimeout(function() {`
      block.call
    `}, n);`
  end

end
```


Mise à l'échelle de l'affichage
-------------------------------

Ça, c'est très simple.

``` html index.html
<!DOCTYPE html>
<html>
  ...
  <body>
    <canvas width="400" height="400" id="canvas"></canvas>
    <script src="build.js"></script>
  </body>
</html>
```

``` ruby app/canvas.rb
class Canvas

  SCALE = 4

  def initialize
    @canvas  = `document.getElementById('canvas')`
    @context = `#@canvas.getContext('2d')`
    @height  = `#@canvas.height`
    @width   = `#@canvas.width`
  end

  def clear
    draw_rect(0, 0, @width, @height, 'black')
  end

  def pixel(x, y)
    draw_rect(x * SCALE, y * SCALE, SCALE, SCALE, 'white')
  end

  private

  def draw_rect(x, y, w, h, color)
    `#@context.fillStyle = #{color}`
    `#@context.fillRect(#{x}, #{y}, #{w}, #{h})`
  end

end
```


Supprimer les bordures
----------------------

Ça, c'est très ennuyeux, vous pouvez sauter directement à la fin de l'article.

Je désactive les tests des bordures, puis je les réécrit un par un.

``` ruby spec/neighborhood_extractor_spec.rb
require './app/neighborhood_extractor.rb'

describe NeighborhoodExtractor do

  let(:generation) do
    [
      [0, 1, 0, 1],
      [1, 0, 1, 0],
      [0, 1, 1, 0]
    ]
  end

  ...

  describe 'borders' do
    specify 'x=1 y=0' do
      extractor = NeighborhoodExtractor.new(generation, 1, 0)
      expect(extractor.cells).to eq [0, 1, 1, 0, 1, 0, 1, 0, 1]
    end

    # specify 'x=2 y=2' do
    #   extractor = NeighborhoodExtractor.new(generation, 2, 2)
    #   expect(extractor.cells).to eq [0, 1, 0, 1, 1, 0, 0, 0, 0]
    # end

    # specify 'x=0 y=1' do
    #   extractor = NeighborhoodExtractor.new(generation, 0, 1)
    #   expect(extractor.cells).to eq [0, 0, 1, 0, 1, 0, 0, 0, 1]
    # end

    # specify 'x=3 y=1' do
    #   extractor = NeighborhoodExtractor.new(generation, 3, 1)
    #   expect(extractor.cells).to eq [0, 1, 0, 1, 0, 0, 1, 0, 0]
    # end

  end
end
```

``` ruby app/neighborhood_extractor.rb
  def group_of_tree(row_index)
    if row_index < 0
      generation[generation.size-1][x-1..x+1]
    elsif row_index == generation.size
      [0, 0, 0]
    else
      if x == 0
        [ 0, *generation[row_index][x..x+1] ]
      elsif x == generation.first.size - 1
        [*generation[row_index][x-1..x], 0]
      else
        generation[row_index][x-1..x+1]
      end
    end
  end
```

Après refactoring


``` ruby app/neighborhood_extractor.rb
class NeighborhoodExtractor < Struct.new(:generation, :x, :y)

  def cells
    [ *extract(y - 1), *extract(y), *extract(y + 1) ]
  end

  private

  def extract(row_index)
    row_index = generation.size - 1 if row_index < 0
    group_of_tree(row_index)
  end

  def group_of_tree(row_index)
    if row_index == generation.size
      [0, 0, 0]
    else
      if x == 0
        [ 0, *generation[row_index][x..x+1] ]
      elsif x == generation.first.size - 1
        [*generation[row_index][x-1..x], 0]
      else
        generation[row_index][x-1..x+1]
      end
    end
  end

end
```

``` ruby spec/neighborhood_extractor_spec.rb
  describe 'borders' do
    
    ...

    specify 'x=2 y=2' do
      extractor = NeighborhoodExtractor.new(generation, 2, 2)
      expect(extractor.cells).to eq [0, 1, 0, 1, 1, 0, 1, 0, 1]
    end
```

``` ruby app/neighborhood_extractor.rb
class NeighborhoodExtractor < Struct.new(:generation, :x, :y)

  def cells
    [ *extract(y - 1), *extract(y), *extract(y + 1) ]
  end

  private

  def extract(row_index)
    group_of_tree(ensure_overlapping(row_index))
  end

  def ensure_overlapping(index)
    if index < 0
      generation.size - 1
    elsif index == generation.size
      0
    else
      index
    end
  end

  def group_of_tree(row_index)
    if x == 0
      [ 0, *generation[row_index][x..x+1] ]
    elsif x == generation.first.size - 1
      [*generation[row_index][x-1..x], 0]
    else
      generation[row_index][x-1..x+1]
    end
  end

end
```

``` ruby spec/neighborhood_extractor_spec.rb
  describe 'borders' do

    ...

    specify 'x=0 y=1' do
      extractor = NeighborhoodExtractor.new(generation, 0, 1)
      expect(extractor.cells).to eq [1, 0, 1, 0, 1, 0, 0, 0, 1]
    end

    specify 'x=3 y=1' do
      extractor = NeighborhoodExtractor.new(generation, 3, 1)
      expect(extractor.cells).to eq [0, 1, 0, 1, 0, 1, 1, 0, 0]
    end
```

Ça y est, on y voit plus clair.

``` ruby app/neighborhood_extractor.rb
class NeighborhoodExtractor < Struct.new(:generation, :x, :y)

  def cells
    [ *extract(y - 1), *extract(y), *extract(y + 1) ]
  end

  private

  def extract(row_index)
    group_of_tree(ensure_overlapping(row_index))
  end

  def ensure_overlapping(index)
    if index < 0
      generation.size - 1
    elsif index == generation.size
      0
    else
      index
    end
  end

  def group_of_tree(row_index)
    row = generation[row_index]
    if x == 0
      [row[-1], *row[x..x+1] ]
    elsif x == generation.first.size - 1
      [*row[x-1..x], row[0]]
    else
      row[x-1..x+1]
    end
  end

end
```

Voilà, Ruby/Opal.rb c'est fait. Vous pouvez trouver le code sur Github si vous
êtes intéressés : [Le jeu de la vie en ruby/opal.rb](https://github.com/lkdjiin/game-of-life-ruby).

La prochaine version sera écrite en Racket, un dialecte de Lisp.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

{% connexe %}
