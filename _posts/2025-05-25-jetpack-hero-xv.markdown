---
layout: post
title: "Plusieurs petites animations (Jetpack Hero)"
date: 2025-05-25 8:00
comments: true
tags: [ ruby, dragonruby, jeu ]
---

Pour rendre le jeu plus attractif je vais ajouter quelques animations.

<!-- more -->

## Une flamme à l'utilisation du jetpack

{% img center /images/jetpack-hero-xv-1.png %}

Le code est brut et un peu naïf, mais je n'ai pas besoin de plus.

{% highlight ruby %}
  def render_jetpack_flame
    return if state.hero.impulse < 0.2

    flame = {
      x: state.hero.facing == :left ? state.hero.x + 14 : state.hero.x - 1,
      y: state.hero.y - 15,
      w: 16, h: 40
    }

    if state.hero.impulse > 3
      flame.merge!({ path: 'sprites/flame-0.png'})
    elsif state.hero.impulse > 2
      flame.merge!({ path: 'sprites/flame-1.png'})
    elsif state.hero.impulse > 1
      flame.merge!({ path: 'sprites/flame-2.png'})
    elsif state.hero.impulse > 0.6
      flame.merge!({ path: 'sprites/flame-3.png'})
    elsif state.hero.impulse > 0.2
      flame.merge!({ path: 'sprites/flame-4.png'})
    end

    outputs.sprites << flame
  end
{% endhighlight %}

J'aurais peut-être pu m'éviter de calculer l'emplacement de la flamme par
rapport au personnage (suivant que celui-ci est tourné vers la gauche ou la droite)
en _ancrant_ le sprite en son milieu et non pas par sa coordonnée bas/gauche comme c'est
le cas par défaut.

## Mort d'un alien

Lorsqu'un alien est touché par notre laser, on joue une animation pour sa
dispartion, comme on avait fait pour son apparition [dans cet article](/blog/2025/05/10/jetpack-hero-x/).

J'ajoute un _hash_ pour contenir les sprites :

{% highlight ruby %}
    state.aliens_disparition ||= []

    outputs.sprites << state.aliens_disparition

    state.aliens.each do |alien|
      if alien.dead
        state.aliens_disparition << alien.dup.merge({
          start_looping_at: Kernel.tick_count,
          finished: false,
        })
        audio[:explosion] = { input: "sounds/explosion.wav" }
        next
      end

      # ...
    end
{% endhighlight %}

Et j'utilise la méthode `frame_index` pour l'animation proprement dite :

{% highlight ruby %}
    state.aliens_disparition.each do |alien|
      sprite_index = alien.start_looping_at.frame_index(7, 8, false)
      if sprite_index
        alien.path = "sprites/disparition-#{sprite_index}.png"
      else
        alien.finished = true
        state.aliens_pool[alien.id].alive = false
      end
    end
    state.aliens_disparition.reject!(&:finished)
{% endhighlight %}

## Et d'autres encore

Sur le même principe (utilisation de `frame_index`) j'ajoute une animation pour :

- le rotor du jetpack
- le personnage en marche
- l'explosion d'un baril de fuel


## Références

1. Vous trouverez le code de [Jetpack Hero](https://github.com/lkdjiin/jetpack-hero) sur github
1. [Documentation](https://docs.dragonruby.org/#/) de DragonRuby

{% include serie_003.md %}
