---
layout: post
title: "Un score et des vies (Jetpack Hero)"
date: 2025-05-26 8:00
comments: true
tags: [ ruby, dragonruby, jeu ]
---

On arrive doucement vers la fin et on se rapproche d'un jeu complet en ajoutant un score et des vies.

{% img center /images/jetpack-hero-xvi-1.png %}

<!-- more -->

## Score

Ça a beau être du DragonRuby, on peut quand même utiliser nos bonnes vieilles
variables d'objet. À priori une variable `@score` pour un objet `Game` a du sens :

{% highlight ruby %}
    @score = 0
{% endhighlight %}

Il faut bien sûr l'afficher :

{% highlight ruby %}
    outputs.labels << {
      x: 900,
      y: 10,
      size_px: 55,
      alignment_enum: 2,
      vertical_alignment_enum: 0,
      text: @score,
      r: 255,
      g: 255,
      b: 255,
    }
{% endhighlight %}

Et on augmente le score au bon moment :

{% highlight ruby %}
    state.aliens.each do |alien|
      if alien.dead
        @score += 100
        # ...
      end
      # ...
    end
{% endhighlight %}

## Vies

Pour les vies ce sera la même mécanique. D'abord une variable et un affichage :

{% highlight ruby %}
    @lives = 3

    @lives.times do |i|
      outputs.sprites << {
        x: 1_000 + i * 80,
        y: 50,
        w: 7 * 3,
        h: 17 * 3,
        path: 'sprites/hero-flying-0.png'
      }
    end
{% endhighlight %}

Puis une mise à jour quand on est touché par un alien. J'ai aussi ajouté du son :

{% highlight ruby %}
  def calc_alien_collision
    if a = Geometry.find_intersect_rect(state.hero, state.aliens)
      @lives -= 1
      if @lives == 0
        @game_over = true
        audio[:game_over] = { input: "sounds/game-over.wav" }
        return
      end
      audio[:live_down] = { input: "sounds/life-lost.wav" }
      state.hero.x = 120
      state.hero.y = 700
    end
  end
{% endhighlight %}

## Références

1. Vous trouverez le code de [Jetpack Hero](https://github.com/lkdjiin/jetpack-hero) sur github
1. [Documentation](https://docs.dragonruby.org/#/) de DragonRuby

{% include serie_003.md %}
