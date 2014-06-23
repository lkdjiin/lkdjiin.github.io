---
layout: post
title: "Un space invaders avec Opal.rb - partie 14"
date: 2014-06-23 21:19
comments: true
categories: [intermédiaire, opal.rb, ruby, javascript, space invaders, jeu]
---

{% level 2 %}

Lorsque le joueur faisait feu, le tir prenait naissance dans le coin
supérieur gauche du joueur. On le voudrait plutôt au milieu.

<!-- more -->

Voici donc la nouvelle classe `Fire`:

``` ruby app/fire.rb
class Fire
  SIDE = 4
  DELTA = 5

  attr_reader :x, :y

  def initialize(player)
    @x = player.x + player.w / 2
    @y = player.y - SIDE
  end

  def w; SIDE; end

  def h; SIDE; end

  def color; "white"; end

  def update_position
    @y -= DELTA
  end
end
```

Dans `initialize`, on calcule la position d'origine du tir par rapport
au joueur, passé en argument.

Il faut donc changer aussi la méthode `fire` de la classe `Game`:

``` ruby
class Game
  
  ...

  def fire
    @fires << Fire.new(@player)
  end

  ...
end
```

Voilà, ça c'est fait. N'oubliez pas que le code est maintenant disponible
sur [Github](https://github.com/lkdjiin/space-invaders-in-opal-rb).

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
