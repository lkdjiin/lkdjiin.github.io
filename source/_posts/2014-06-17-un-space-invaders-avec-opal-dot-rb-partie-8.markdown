---
layout: post
title: "Un space invaders avec Opal.rb - partie 8"
date: 2014-06-17 21:08
comments: true
categories: [intermédiaire, opal.rb, ruby, javascript, space invaders, jeu]
---

{% level 2 %}

Comme promis, on ajoute aujourd'hui les envahisseurs. Mais comme j'ai une
petite flemme ce soir, il y aura peu d'explications ;) De plus le code est
un premier jet…

Quoiqu'il en soit, c'est parti.

<!-- more -->

La classe `Enemy`:

``` ruby app/enemy.rb
class Enemy
  attr_accessor :x, :y, :w, :h, :color
  def initialize(x, y, w, h, color)
    @x = x
    @y = y
    @w = w
    @h = h
    @color = color
  end
end
```

La classe `Enemies`, pour gérer une collection d'envahisseurs:

``` ruby app/enemies.rb
class Enemies
  include Enumerable
  ENEMIES_PER_ROW = 10

  def initialize
    @enemies = []
    @direction = :right
    build(60, '#0000ff')
    build(120, '#0000dd')
    build(180, '#0000bb')
    build(240, '#000099')
    build(300, '#000077')
  end

  def each(&block)
    @enemies.each(&block)
  end

  def update
    @enemies.each do |e|
      if e.x <= 10 || e.x + e.w >= 690
        change_enemies_direction
        enemies_down
        break
      end
    end
    @enemies.each do |e|
      if @direction == :left
        e.x = e.x - 2
      else
        e.x = e.x + 2
      end
    end
  end

  private

  def change_enemies_direction
    if @direction == :left
      @direction = :right
    else
      @direction = :left
    end
  end

  def enemies_down
    @enemies.each do |e|
      e.y = e.y + 4
    end
  end

  def build(y, color)
    (1..ENEMIES_PER_ROW).each do |i|
      @enemies << Enemy.new(50 + i * 60, y, 40, 40, color)
    end
  end

end
```

La classe `Game`, remaniée:

``` ruby app/game.rb
class Game

  def initialize
    @canvas = SpaceCanvas.new
    @player = Player.new
    @enemies = Enemies.new
  end

  def start
    init_keyboard
    main_loop(50) do
      @canvas.clear_background
      @canvas.draw_player(@player)
      @enemies.update
      @enemies.each {|e| @canvas.draw_enemy(e) }
    end
  end

  def main_loop(interval, &block)
    `setInterval(#{block.to_n}, #{interval})`
  end

  def init_keyboard
    %x(
      window.addEventListener("keydown",
        function(e) {
          if(e.keyCode == 37) { #{@player.move_left} }
          if(e.keyCode == 39) { #{@player.move_right} }
        },
        false);
    )
  end
end
```

La classe `SpaceCanvas`, avec sa nouvelle méthode `draw_enemy`:

``` ruby app/space_canvas.rb
class SpaceCanvas

  def initialize
    @canvas  = `document.getElementById('canvas')`
    @context = `#@canvas.getContext('2d')`
    @height  = `#@canvas.height`
    @width   = `#@canvas.width`
  end

  def clear_background
    draw_rect(0, 0, @width, @height, 'black')
  end

  def draw_player(player)
    draw_rect(player.x, player.y, player.w, player.h, player.color)
  end

  def draw_enemy(enemy)
    draw_rect(enemy.x, enemy.y, enemy.w, enemy.h, enemy.color)
  end

  private

  def draw_rect(x, y, w, h, color)
    `#@context.fillStyle = #{color}`
    `#@context.fillRect(#{x}, #{y}, #{w}, #{h})`
  end

end
```

Et enfin `application.rb`, qui inclus les nouvelles classes:

``` ruby app/application.rb
require 'opal'
require 'opal-jquery'

require 'space_canvas'
require 'player'
require 'game'
require 'enemy'
require 'enemies'

game = Game.new
game.start
```

Voilà, il y aura surement un petit travail de refactoring à faire
prochainement ;)

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

