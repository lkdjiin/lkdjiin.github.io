---
layout: post
title: "Apparition des aliens (Jetpack Hero)"
date: 2025-05-10 8:00
comments: true
tags: [ ruby, dragonruby, jeu ]
---

Il est temps d'ajouter des ennemis dans notre jeu. Ce seront des aliens roses. Vous pouvez voir
à quel point j'ai fait des progrès en graphisme :D

{% img center /images/jetpack-hero-x-1.png %}

<!-- more -->

Dans le jeu les aliens peuvent se téléporter en créant des portails. J'aimerai une petite animation
qui suggererait un portail avant que l'alien apparaisse. Et puis ça laissera le temps au joueur de réagir.

J'ai trouvé ce [pack d'effets graphique](https://bdragon1727.itch.io/super-package-retro-pixel-effects-32x32-pack-2)

{% img center /images/jetpack-hero-x-2.png %}

## Les bases

Je crée un hash `aliens`, vide au départ, qui contiendra les aliens au fur et à
mesure de leurs _téléportations_.

{% highlight ruby %}
    state.aliens ||= []
{% endhighlight %}

De même, je crée un hash `aliens_apparition` qui contiendra les animations des
portails.

{% highlight ruby %}
    state.aliens_apparition ||= []
{% endhighlight %}

Je crée aussi un `aliens_pool`, pour savoir à quels endroits les aliens peuvent
apparaitrent.

{% highlight ruby %}
    state.aliens_pool ||= [
      { x:400, y: 582, alive: false },
      { x:80, y: 432, alive: false },
      { x:700, y: 432, alive: false },
      { x:80, y: 282, alive: false },
      { x:900, y: 282, alive: false },
      { x:600, y: 142, alive: false },
    ]
{% endhighlight %}

Finalement il ne faut pas oublier d'afficher les animations et les aliens.

{% highlight ruby %}
    outputs.sprites << state.aliens_apparition
    outputs.sprites << state.aliens
{% endhighlight %}

## Animation des portails

{% highlight ruby %}
  def calc
    calc_init
    calc_aliens
    # ...
  end
{% endhighlight %}

Dans la 1ère partie de `calc_aliens` chaque alien du _pool_ a une chance sur mille
de se téléporter (`rand(1_000) == 0`) à chaque frame, si il n'est pas déjà en jeu (`alien.alive == false`).
Si la chance lui sourit, on crée un portail dans `aliens_apparition`.

{% highlight ruby %}
  def calc_aliens
    state.aliens_pool.each do |alien|
      if alien.alive == false && rand(1_000) == 0
        alien.alive = true
        state.aliens_apparition << {
          x: alien.x, y: alien.y,
          w: 50 * ALIEN_SCALE, h: 35 * ALIEN_SCALE,
          start_looping_at: Kernel.tick_count,
          finished: false,
        }
        break
      end
    end
{% endhighlight %}

Dans la seconde partie on s'occupe d'animer les portails avec [la méthode
utilitaire frame_index](https://docs.dragonruby.org/#/api/numeric?id=frame_index)
fournie par DragonRuby. Et lorsque l'animation est terminée, on la retire du hash
`state.aliens_apparition` et on ajoute un alien au même endroit de l'écran dans
le hash `state.aliens`.

{% highlight ruby %}
    state.aliens_apparition.each do |portail|
      sprite_index = portail.start_looping_at.frame_index(10, 8, false)
      if sprite_index
        portail.path = "sprites/apparition-#{sprite_index}.png"
      else
        portail.finished = true
        state.aliens << {
          x: portail.x, y: portail.y,
          w: 50 * ALIEN_SCALE, h: 35 * ALIEN_SCALE,
          path: 'sprites/alien.png',
        }
      end
    end
    state.aliens_apparition.reject!(&:finished)
  end
{% endhighlight %}
