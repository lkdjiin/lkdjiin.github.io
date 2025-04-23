---
layout: post
title: "Jetpack Hero IV - Première animation du personnage"
date: 2025-04-23 8:00
comments: true
tags: [ ruby, dragonruby, jeu ]
---
On donne un peu de vie au personnage en l'orientant à droite ou à gauche et en
le modifiant légèrement quand il vole.

<!-- more -->

## Orientation droite/gauche

`flip_horizontally` fait partie des paramètres optionnels d'un sprite.
Sans surprise DragonRuby s'en sert pour un effet mirroir.

{% highlight ruby %}
args.state.hero ||= {
  x: 600,
  y: 200,
  w: 7 * HERO_SCALE,
  h: 17 * HERO_SCALE,
  path: 'sprites/hero-standing.png',
  impulse: 0,
  moving: :none,
  flip_horizontally: false
}
{% endhighlight %}

On met à jour ce paramètre quand on déplace le personnage :

{% highlight ruby %}
if args.state.hero.moving == :left
  args.state.hero.x -= RL_SPEED
  args.state.hero.flip_horizontally = false
elsif args.state.hero.moving == :right
  args.state.hero.x += RL_SPEED
  args.state.hero.flip_horizontally = true
end
{% endhighlight %}

## En vol ou stationnaire

On a déjà tout ce qu'il nous faut pour modifier la représentation du personnage
suivant qu'il est debout sur une plateforme ou bien en vol.
Par défaut on lui colle une image "en vol", qu'on modifie uniquement lorsqu'il
aborde une plateforme par le haut :

{% highlight ruby %}
def calc(args)
  args.state.hero.path = 'sprites/hero-flying.png'
  # [...]

  if args.state.hero.intersect_rect?(args.state.platform)
    if (x_before + args.state.hero.w) < args.state.platform.x
      # [...]
    elsif x_before >= (args.state.platform.x + args.state.platform.w)
      # [...]
    elsif ascending
      # [...]
    else
      args.state.hero.path = 'sprites/hero-standing.png'
      # [...]
    end
  end
end
{% endhighlight %}

## Références

1. Vous trouverez le code de [Jetpack Hero](https://github.com/lkdjiin/jetpack-hero) sur github
1. [Documentation](https://docs.dragonruby.org/#/) de DragonRuby

{% include serie_003.md %}
