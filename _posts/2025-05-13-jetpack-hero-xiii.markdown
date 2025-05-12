---
layout: post
title: "GAME OVER (Jetpack Hero)"
date: 2025-05-13 8:00
comments: true
tags: [ ruby, dragonruby, jeu ]
---

Première notion de fin de jeu, quand un alien nous touche on écrit GAME OVER et
c'est fini. Pour rejouer il faudra relancer le jeu ; c'est violent mais il faut
bien commencer quelque part.

{% img center /images/jetpack-hero-xiii-1.png %}

<!-- more -->

DragonRuby reste avant tout du Ruby. Même s'il nous fournit un `state` très
pratique, on peut construire nos objets comme d'habitude :

{% highlight ruby %}
class Game
  def initialize
    @game_over = false
  end
end
{% endhighlight %}

Dans la partie _render_ on affiche GAME OVER au milieu de l'écran, sous condition :

{% highlight ruby %}
    if @game_over
      outputs.labels << {
        x: 640,
        y: 360,
        size_px: 200,
        alignment_enum: 1,
        vertical_alignment_enum: 1,
        text: "GAME OVER",
        r: 255,
        g: 255,
        b: 255,
      }
    end
{% endhighlight %}

On saute la partie _calc_ quand on a perdu, ce qui a pour effet de figer les éléments présents :

{% highlight ruby %}
  def calc
    return if @game_over

    # ...
  end
{% endhighlight %}

La partie est perdue dès qu'il y a collision entre un alien et le personnage :

{% highlight ruby %}
  def calc_alien_collision
    if a = Geometry.find_intersect_rect(state.hero, state.aliens)
      @game_over = true
    end
  end
{% endhighlight %}

## Références

1. Vous trouverez le code de [Jetpack Hero](https://github.com/lkdjiin/jetpack-hero) sur github
1. [Documentation](https://docs.dragonruby.org/#/) de DragonRuby

{% include serie_003.md %}
