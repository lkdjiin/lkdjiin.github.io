---
layout: post
title: "Un space invaders avec Opal.rb - partie 7"
date: 2014-06-16 21:00
comments: true
categories: [intermédiaire, opal.rb, ruby, javascript, space invaders, jeu]
---

{% level 2 %}

Le fichier `app/application.rb` commence a enfler et a ressembler à un
script. On peut rassembler ce qu'il contient dans une classe `Game`.
L'idéal serait de n'avoir dans ce fichier que:

    game = Game.new
    game.start

<!-- more -->

On va donc déplacer tout dans une classe `Game`, et on ajoute une méthode
`initialize`:

``` ruby app/game.rb
class Game

  def initialize
    @canvas = SpaceCanvas.new
    @player = Player.new
  end

  def start
    init_keyboard
    main_loop(50) do
      @canvas.clear_background
      @canvas.draw_player(@player)
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

Et voici le nouveau fichier application:

``` ruby app/application.rb
require 'opal'
require 'opal-jquery'

require 'space_canvas'
require 'player'
require 'game'

game = Game.new
game.start
```

J'aime bien quand c'est organisé ;)

Pour info, voici l'arbre de notre projet:

    $ tree
    .
    ├── app
    │   ├── application.rb
    │   ├── game.rb
    │   ├── player.rb
    │   └── space_canvas.rb
    ├── build.js
    ├── Gemfile
    ├── Gemfile.lock
    ├── index.html
    └── Rakefile

Je sais que j'avais dit qu'on ajouterait les envahisseurs aujourd'hui,
mais là je n'ai plus le temps ! On verra demain.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

