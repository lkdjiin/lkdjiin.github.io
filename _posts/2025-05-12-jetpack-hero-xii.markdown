---
layout: post
title: "On dégomme de l'alien (Jetpack Hero)"
date: 2025-05-12 12:00
comments: true
tags: [ dragonruby, ruby, jeu ]
---

Maintenant que le personnage tire des salves laser, il est temps de faire des
cartons. Ce sera un tout petit article puisqu'on a déjà toutes les connaissances
nécessaires.

<!-- more -->

## Mort d'un alien

Pour gérer la vie et la mort d'un alien nous avons besoin d'un nouvel état, `dead`.

{% highlight ruby %}
state.aliens << {
  x: alien.x, y: alien.y,
  w: 50 * ALIEN_SCALE, h: 35 * ALIEN_SCALE,
  path: 'sprites/alien.png',
  dead: false,
}
{% endhighlight %}

On peut ainsi supprimer facilement les aliens décédés.

{% highlight ruby %}
  def calc_aliens
    # ...
    state.aliens.reject!(&:dead)
  end
{% endhighlight %}

Un alien meurt quand il y a collision entre lui et un tir laser.
Dans ce cas on n'oublie pas de faire disparaitre aussi le laser.

{% highlight ruby %}
  def calc_shot
    # ...
    state.shots.each do |shot|
      # ...
      state.aliens.each do |a|
        if shot.intersect_rect?(a)
          shot.dead = true
          a.dead = true
        end
      end
    end
    state.shots.reject!(&:dead)
  end
{% endhighlight %}

## Et réapparition

Pour qu'un alien mort puisse réapparaitre il faut que son état `alive` repasse à `false`,
ce qui est une condition pour pouvoir être sélectionné (voir [Apparition des aliens](/blog/2025/05/10/jetpack-hero-x/)).
Pour faciliter cela j'ajoute un ID à chaque alien.

{% highlight ruby %}
    state.aliens_pool ||= [
      { x:400, y: 582, alive: false, id: 0 },
      { x:80, y: 432, alive: false, id: 1 },
      { x:700, y: 432, alive: false, id: 2 },
      { x:80, y: 282, alive: false, id: 3 },
      { x:900, y: 282, alive: false, id: 4 },
      { x:600, y: 142, alive: false, id: 5 },
    ]
{% endhighlight %}

Ce qui me permet de faire le lien entre `aliens` et `aliens_pool` lors de la
mort d'un alien.

{% highlight ruby %}
      state.aliens.each do |a|
        if shoot.intersect_rect?(a)
          shoot.dead = true
          a.dead = true
          state.aliens_pool[a.id].alive = false
        end
      end
{% endhighlight %}

## Références

1. Vous trouverez le code de [Jetpack Hero](https://github.com/lkdjiin/jetpack-hero) sur github
1. [Documentation](https://docs.dragonruby.org/#/) de DragonRuby

{% include serie_003.md %}
