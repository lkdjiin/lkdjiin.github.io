---
layout: post
title: "Un space invaders avec Opal.rb - partie 4"
date: 2014-06-13 19:01
comments: true
categories: [intermédiaire, opal.rb, ruby, javascript, space invaders, jeu]
---

{% level 2 %}

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

``` ruby app/application.rb
require 'opal'
require 'opal-jquery'

require 'space_canvas'
require 'player'

canvas = SpaceCanvas.new
player = Player.new
canvas.clear_background
canvas.draw_player(player)
```

Le fichier `player.rb` contient la classe `Player`:

``` ruby app/player.rb
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
```

Quant au fichier `space_canvas.rb`, le voici:

``` ruby app/space_canvas.rb
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
```

Les méthodes `clear_background` et `draw_player` sont trop similaires pour
être laissées en l'état ! En voici un petit refactoring:

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

  private

  def draw_rect(x, y, w, h, color)
    `#@context.fillStyle = #{color}`
    `#@context.fillRect(#{x}, #{y}, #{w}, #{h})`
  end

end
```

Comme toujours, `rake build` pour s'assurer que ça fonctionne bien !

Demain, on verra comment faire bouger notre joueur…

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

