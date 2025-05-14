---
layout: post
title: "Les aliens bougent enfin (Jetpack Hero)"
date: 2025-05-14 8:00
comments: true
tags: [ ruby, dragonruby, jeu ]
---

Il est plus que temps de faire se déplacer les aliens.

<!-- more -->

Le plus simple est de leur donner une limite à droite `x_max` et une à gauche `x_min`.
Et pourquoi ne pas leur donner à chacun une vitesse unique ?

{% highlight ruby %}
    state.aliens_pool ||= [
      { x: 420, y: 582, w: ALIEN_W, h: ALIEN_H, alive: false, id: 0, speed: 2, x_min: 410, x_max: 1_000 },
      { x: 80, y: 432, w: ALIEN_W, h: ALIEN_H, alive: false, id: 1, speed: 0.8, x_min: 50, x_max: 120 },
      { x: 700, y: 432, w: ALIEN_W, h: ALIEN_H, alive: false, id: 2, speed: -1.8, x_min: 410, x_max: 1_000 },
      { x: 80, y: 282, w: ALIEN_W, h: ALIEN_H, alive: false, id: 3, speed: 0.7, x_min: 50, x_max: 120 },
      { x: 900, y: 282, w: ALIEN_W, h: ALIEN_H, alive: false, id: 4, speed: 1.7, x_min: 410, x_max: 1_000 },
      { x: 200, y: 142, w: ALIEN_W, h: ALIEN_H, alive: false, id: 5, speed: 2, x_min: 50, x_max: 1_200 },
      { x: 900, y: 142, w: ALIEN_W, h: ALIEN_H, alive: false, id: 5, speed: -2, x_min: 50, x_max: 1_200 },
    ]
{% endhighlight %}

Et on inverse la direction quand une limite est atteinte.

{% highlight ruby %}
    state.aliens.each do |alien|
      alien.x += alien.speed
      if alien.x <= alien.x_min || alien.x >= alien.x_max
        alien.speed = -alien.speed
      end
    end
{% endhighlight %}


Je vais aussi faire une petite animation quand ils marchent. Elle va
simplement consister à inverser le sens du sprite en boucle.
Pour cela on utilise la propriété `flip_horizontally` d'un sprite.

{% highlight ruby %}
ALIEN_ANIMATION = 15

state.aliens << alien.dup.merge({
  path: 'sprites/alien.png',
  dead: false,
  flip_horizontally: false,
  animation_counter: ALIEN_ANIMATION,
})
{% endhighlight %}

Et donc on inverse le sprite dans le sens horizontal toutes les 15 frames.
Une animation du pauvre en quelque sorte.

{% highlight ruby %}
state.aliens.each do |alien|
  # ...
  alien.animation_counter -= 1
  if alien.animation_counter == 0
    alien.animation_counter = ALIEN_ANIMATION
    alien.flip_horizontally = !alien.flip_horizontally
  end
end
{% endhighlight %}

## Références

1. Vous trouverez le code de [Jetpack Hero](https://github.com/lkdjiin/jetpack-hero) sur github
1. [Documentation](https://docs.dragonruby.org/#/) de DragonRuby

{% include serie_003.md %}
