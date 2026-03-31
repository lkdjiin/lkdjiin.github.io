---
layout: post
title: "Un space invaders avec Opal.rb - partie 4"
date: 2014-06-13 19:01
legacy: true
tags: [ opal, ruby, javascript, space invaders, jeu]
---



Petite séance de refactoring aujourd'hui. Tout d'abord, comme nous avons
maintenant deux classes dans le fichier `app/application.rb`, on va les mettre
dans des fichiers séparés, pour obtenir ça:

    ● tree
    .
    ├── app
    │   ├── application.rb
    │   ├── player.rb
    │   └── space_canvas.rb
    ├── build.js
    ├── Gemfile
    ├── Gemfile.lock
    ├── index.html
    └── Rakefile

<!-- more -->

Le fichier `application.rb` est maintenant réduit à ceci:

{% highlight ruby %}
require 'opal'
require 'opal-jquery'

require 'space_canvas'
require 'player'

canvas = SpaceCanvas.new
player = Player.new
canvas.clear_background
canvas.draw_player(player)
{% endhighlight %}

Le fichier `player.rb` contient la classe `Player`:

{% highlight ruby %}
class Player
  attr_accessor :x, :y, :w, :h, :color

  def initialize
    @x = 325
    @y = 560
    @w = 50
    @h = 30
    @color = 'green'
  end
end
{% endhighlight %}

Quant au fichier `space_canvas.rb`, le voici:

{% highlight ruby %}
class SpaceCanvas

  def initialize
    @canvas  = `document.getElementById('canvas')`
    @context = `#@canvas.getContext('2d')`
    @height  = `#@canvas.height`
    @width   = `#@canvas.width`
  end

  def clear_background
    `#@context.fillStyle = 'black'`
    `#@context.fillRect(0, 0, #@width, #@height)`
  end

  def draw_player(player)
    `#@context.fillStyle = #{player.color}`
    `#@context.fillRect(#{player.x}, #{player.y}, #{player.w}, #{player.h})`
  end
end
{% endhighlight %}

Les méthodes `clear_background` et `draw_player` sont trop similaires pour
être laissées en l'état ! En voici un petit refactoring:

{% highlight ruby %}
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

  private

  def draw_rect(x, y, w, h, color)
    `#@context.fillStyle = #{color}`
    `#@context.fillRect(#{x}, #{y}, #{w}, #{h})`
  end

end
{% endhighlight %}

Comme toujours, `rake build` pour s'assurer que ça fonctionne bien !

Demain, on verra comment faire bouger notre joueur…



À demain.



