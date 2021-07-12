---
layout: post
title: "Un space invaders avec Opal.rb - partie 6"
date: 2014-06-15 19:53
legacy: true
tags: [intermédiaire, opal.rb, ruby, javascript, space invaders, jeu]
---



Et si on controlait notre joueur au clavier ? On commence par ajouter deux
méthodes à la classe `Player`, une pour changer sa position vers la
gauche (`move_left`), et une autre pour aller à droite (`move_right`):

{% highlight ruby %}
class Player
  DELTA = 10

  attr_accessor :x, :y, :w, :h, :color

  def initialize
    @x = 325
    @y = 560
    @w = 50
    @h = 30
    @color = 'green'
  end

  def move_left
    @x -= DELTA
  end

  def move_right
    @x += DELTA
  end

end
{% endhighlight %}

<!-- more -->

Maintenant, il faut faire en sorte qu'un appui sur la touche *flêche gauche*
appelle la méthode `move_left` (et qu'un appui sur *flêche droite* appelle
`move_right`). Pour ça, je vais encore écrire un mélange de ruby/javascript:

{% highlight ruby %}
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
{% endhighlight %}

Le `%x()` joue le même rôle que les backticks, mais sur plusieurs lignes.
Ce qui est entre `%x(` et `)` est donc du code javascript (mais qui peut
utiliser l'interpolation de chaînes de caractères ruby…).

Le code javascript est simple, on enregistre un *listener* sur l'évenement
`"keydown"`. Le code `37` correspond à la touche *flêche gauche*, le code
`39`, bin, vous avez deviné ;)

Il reste a insérer la méthode `init_keyboard` dans la méthode `start`:

{% highlight ruby %}
def start
  init_keyboard
  main_loop(50) do
    @canvas.clear_background
    @canvas.draw_player(@player)
  end
end
{% endhighlight %}

Après un `rake build`, vous pouvez déplacer le joueur au clavier.

Pour info, voici le code complet de `application.rb`:

{% highlight ruby %}
require 'opal'
require 'opal-jquery'

require 'space_canvas'
require 'player'

@canvas = SpaceCanvas.new
@player = Player.new

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

def start
  init_keyboard
  main_loop(50) do
    @canvas.clear_background
    @canvas.draw_player(@player)
  end
end

start
{% endhighlight %}

Je pense que demain, on commencera à s'occuper des envahisseurs…



À demain.



