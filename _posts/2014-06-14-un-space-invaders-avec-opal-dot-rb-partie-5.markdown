---
layout: post
title: "Un space invaders avec Opal.rb - partie 5"
date: 2014-06-14 21:15
legacy: true
tags: [intermédiaire, opal.rb, ruby, javascript, space invaders, jeu]
---



On faire faire un peu d'animation. Ça va être très simple, on va juste
faire bouger le joueur automatiquement d'un coté. Malgré la simplicité,
on aura après ça tout ce qu'il nous faut pour animer notre futur jeu.

<!-- more -->

Je vais ajouter une méthode `update` à la classe `Player`:

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

  def update
    @x += 1
  end
end
{% endhighlight %}

À chaque appel de cette méthode, la position du joueur sera décalée de 1
pixel vers la droite. Peux pas faire plus simple ;)

Maintenant, voici le nouveau fichier `application.rb`, où se trouve
l'animation proprement dite:

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

def start
  main_loop(50) do
    @canvas.clear_background
    @canvas.draw_player(@player)
    @player.update
  end
end

start
{% endhighlight %}

Tout d'abord, la méthode `main_loop`:

{% highlight ruby %}
def main_loop(interval, &block)
  `setInterval(#{block.to_n}, #{interval})`
end
{% endhighlight %}

Elle prend comme arguments un intervalle en millisecondes et un bloc
d'instructions ruby à exécuter toutes les `interval` millisecondes.
Elle appelle la méthode javascript `setInterval` avec ses arguments.
La méthode `to_n`, sur `#{block.to_n}`, convertie le bloc d'instructions
ruby en instructions javascript. Il me semble que `to_n` est là pour
*to native*.

Je ne suis pas content de cette méthode. En effet, mélanger deux
langages différents n'est pas très heureux. Je ne sais pas si il existe
une façon de faire cela en ruby pur, mais j'espère. Je chercherais plus
tard, pour l'instant ça fonctionnera comme ça.

Et maintenant la méthode `start` s'explique simplement:

{% highlight ruby %}
def start
  main_loop(50) do
    @canvas.clear_background
    @canvas.draw_player(@player)
    @player.update
  end
end
{% endhighlight %}

Toutes les 50 millisecondes (`main_loop(50)`) on exécute le bloc
d'instructions suivantes:

    @canvas.clear_background
    @canvas.draw_player(@player)
    @player.update

C'est à dire qu'on efface l'écran (le canvas), puis on affiche le joueur,
et enfin on déplace le joueur.

Après un `rake build` et un rafraichissement du navigateur, vous devriez
voir le joueur se déplacer lentement vers la droite. Mission accomplie !

Demain on déplace le joueur avec le clavier ?



À demain.



