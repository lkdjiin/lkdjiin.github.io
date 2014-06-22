---
layout: post
title: "Un space invaders in Opal.rb - partie 13"
date: 2014-06-22 13:42
comments: true
categories: [intermédiaire, opal.rb, ruby, javascript, space invaders, jeu]
---

{% level 2 %}

Voici un extrait de la classe `SpaceCanvas` actuelle:

``` ruby app/space_canvas
class SpaceCanvas

  ...

  def draw_player(player)
    draw_rect(player.x, player.y, player.w, player.h, player.color)
  end

  def draw_enemy(enemy)
    draw_rect(enemy.x, enemy.y, enemy.w, enemy.h, enemy.color)
  end

  def draw_fire(fire)
    draw_rect(fire.x, fire.y, fire.w, fire.h, fire.color)
  end

  ...

end
```

Pas bien ! Le code est dupliqué, et si j'aime l'idée d'avoir trois méthodes
différentes, dont le nom est explicite, je ne veux pas avoir à réécrire
le même code chaque fois que j'ajouterais ce genre de méthode (`draw_ship`,
`draw_special_fire`, `draw_bomb`, etc).

<!-- more -->

La solution réside dans l'utilisation de `alias_method`:

``` ruby app/space_canvas
class SpaceCanvas

  ...

  def draw_object(object)
    draw_rect(object.x, object.y, object.w, object.h, object.color)
  end
  alias_method :draw_player, :draw_object
  alias_method :draw_enemy, :draw_object
  alias_method :draw_fire, :draw_object

  ...

end
```

Il n'y a plus de duplication, et l'ajout d'une nouvelle méthode se fait
simplement en ajoutant un nouvel alias.

Le code de cette série d'articles est désormais sur Github ici :
[space-invaders-in-opal-rb](https://github.com/lkdjiin/space-invaders-in-opal-rb),
et le jeu lui-même (du moins dans son état actuel, c'est à dire pas grand chose) est visible ici : [http://lkdjiin.github.io/space-invaders-in-opal-rb/](http://lkdjiin.github.io/space-invaders-in-opal-rb/).

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
