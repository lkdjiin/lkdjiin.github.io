---
layout: post
title: "Un space invaders avec Opal.rb - partie 12"
date: 2014-06-21 16:25
comments: true
categories: [intermédiaire, opal.rb, ruby, javascript, space invaders, jeu]
---

{% level 2 %}

On commence aujourd'hui à ajouter les tirs du joueur. Le code que je vous
propose est un brouillon, qu'il faudra améliorer successivement.

D'abord dans la classe `Game`, j'ajoute un champ `@fires`:

``` ruby
class Game

  def initialize
    @canvas = SpaceCanvas.new
    @player = Player.new
    @enemies = Enemies.new(@canvas.width)
    @fires = []
  end
```

<!-- more -->

On déclenchera la méthode `fire` lors d'un appui sur la barre d'espace (32):

``` ruby
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
```

Voici la méthode `fire`, qui ajoute simplement un objet à la collection:

``` ruby
  def fire
    @fires << Fire.new(@player.x, @player.y)
  end
```

Et maintenant une méthode qui met à jour les tirs du joueur:

``` ruby
  def update_fires
    @fires.each do |fire|
      fire.update_position
      @canvas.draw_fire(fire)
    end
    @fires.select! {|fire| fire.y >= 0 }
  end
```

La dernière ligne de cette méthode supprime de la collection les tirs qui
ne sont plus visibles à l'écran.

Pour finir, voici la classe `Fire`:

``` ruby app/fire.rb
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
```

Tout ce code pose un certain nombre de problèmes sur lesquels je reviendrais
dans les prochains jours. Demain je pense que je mettrais le code sur Github.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
