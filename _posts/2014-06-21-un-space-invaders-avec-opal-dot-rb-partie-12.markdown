---
layout: post
title: "Un space invaders avec Opal.rb - partie 12"
date: 2014-06-21 16:25
legacy: true
tags: [intermédiaire, opal.rb, ruby, javascript, space invaders, jeu]
---



On commence aujourd'hui à ajouter les tirs du joueur. Le code que je vous
propose est un brouillon, qu'il faudra améliorer successivement.

D'abord dans la classe `Game`, j'ajoute un champ `@fires`:

{% highlight ruby %}
class Game

  def initialize
    @canvas = SpaceCanvas.new
    @player = Player.new
    @enemies = Enemies.new(@canvas.width)
    @fires = []
  end
{% endhighlight %}

<!-- more -->

On déclenchera la méthode `fire` lors d'un appui sur la barre d'espace (32):

{% highlight ruby %}
  def init_keyboard
    %x(
      window.addEventListener("keydown",
        function(e) {
          if(e.keyCode == 32) { #{fire} }
          if(e.keyCode == 37) { #{@player.move_left} }
          if(e.keyCode == 39) { #{@player.move_right} }
        },
        false);
    )
  end
{% endhighlight %}

Voici la méthode `fire`, qui ajoute simplement un objet à la collection:

{% highlight ruby %}
  def fire
    @fires << Fire.new(@player.x, @player.y)
  end
{% endhighlight %}

Et maintenant une méthode qui met à jour les tirs du joueur:

{% highlight ruby %}
  def update_fires
    @fires.each do |fire|
      fire.update_position
      @canvas.draw_fire(fire)
    end
    @fires.select! {|fire| fire.y >= 0 }
  end
{% endhighlight %}

La dernière ligne de cette méthode supprime de la collection les tirs qui
ne sont plus visibles à l'écran.

Pour finir, voici la classe `Fire`:

{% highlight ruby %}
class Fire
  WIDTH = 4
  DELTA = 5

  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def w; WIDTH; end

  def h; WIDTH; end

  def color; "white"; end

  def update_position
    @y -= DELTA
  end
end
{% endhighlight %}

Tout ce code pose un certain nombre de problèmes sur lesquels je reviendrais
dans les prochains jours. Demain je pense que je mettrais le code sur Github.



À demain.


