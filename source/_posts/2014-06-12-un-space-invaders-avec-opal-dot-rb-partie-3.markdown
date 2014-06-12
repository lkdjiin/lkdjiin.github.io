---
layout: post
title: "Un space invaders avec Opal.rb - partie 3"
date: 2014-06-12 20:54
comments: true
categories: [intermédiaire, opal.rb, ruby, javascript, space invaders, jeu]
---

{% level 2 %}

C'est le moment d'afficher un joli vaisseau pour le joueur. Bon, en fait,
ça va être un gros rectangle vert, mais c'est pareil ;)

<!-- more -->

On commence par ajouter une classe `Player`:

``` ruby
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

Y a pas grand chose à dire, hein ? X et y sont la position du coin supérieur
gauche sur le canvas, w est la largeur et h est la hauteur. C'est tout.

Pour afficher notre joueur, on ajoute une méthode `draw_player` à la classe
`SpaceCanvas`:

``` ruby
  def draw_player(player)
    `#@context.fillStyle = #{player.color}`
    `#@context.fillRect(#{player.x}, #{player.y}, #{player.w}, #{player.h})`
  end
```

Cette méthode est similaire à la méthode `clear_background`, vue la dernière
fois, ce qui va nous donner une séance de refactoring demain…

Finalement, voici le code complet du fichier `app/application.rb`:

``` ruby app/application.rb
require 'opal'
require 'opal-jquery'

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

canvas = SpaceCanvas.new
player = Player.new
canvas.clear_background
canvas.draw_player(player)
```

N'oubliez pas de faire un `rake build` avant d'ouvrir le fichier HTML.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
