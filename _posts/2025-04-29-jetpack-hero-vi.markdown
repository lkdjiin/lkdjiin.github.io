---
layout: post
title: "Du carburant pour le jetpack"
date: 2025-04-29 8:00
comments: true
tags: [ ruby, dragonruby, jeu ]
---

Le carburant n'est pas infini. Chaque fois qu'on actionne le jetpack il
consomme un peu de carburant.

<!-- more -->

## Utilisation du carburant

Au début du jeu le jetpack est rempli à 100% :

{% highlight ruby %}
def defaults(args)
  args.state.hero ||= {
    # ...
    jetpack_power: 100,
  }
{% endhighlight %}

On met en place une zone d'information en bas de l'écran qui est fermée par une
plateforme qui fait la longueur de l'écran :

{% highlight ruby %}
def defaults(args)
  args.state.platforms ||= [
    # ...
    { x: 0, y: 130, w: 1280, h: 12, path: 'sprites/tile.png' },
  ]
{% endhighlight %}

La zone d'info est d'une couleur différente de la zone de jeu, et on écrit le
pourcentage en ajoutant un _hash_ dans `args.outputs.labels` :

{% highlight ruby %}
def render(args)
  args.outputs.solids << { x: 0, y: 130, w: 1280, h: 610, r: 0, g: 0, b: 0 }
  args.outputs.solids << { x: 0, y: 0, w: 1280, h: 130, r: 60, g: 60, b: 70 }
  # ...
  args.outputs.labels << {
    x: 200,
    y: 45,
    size_px: 40,
    alignment_enum: 0,
    vertical_alignment_enum: 0,
    text: "POWER #{args.state.hero.jetpack_power.to_i}%",
    r: 255,
    g: 255,
    b: 255,
  }
end
{% endhighlight %}

{% img center /images/jetpack-hero-vi-1.png %}

On retire un peu de carburant à chaque usage du jetpack. Et quand on arrive à
zéro, c'est la panne sèche :

{% highlight ruby %}
def input(args)
  # ...
  if args.inputs.keyboard.control || args.inputs.controller_one.y
    if args.state.hero.jetpack_power > 0
      args.state.hero.impulse = IMPULSE
      args.state.hero.jetpack_power -= 0.1
    end
  end
end
{% endhighlight %}

On rend le tout plus visuel avec une barre de puissance à la place du pourcentage en nombre.
Au départ entièrement jaune, le rouge se dévoile au fur et à mesure de la consommation :

{% highlight ruby %}
args.outputs.solids << { x: 305, y: 54, w: 600, h: 27, r: 255, g: 0, b: 0 }
args.outputs.solids << { x: 305, y: 54, w: args.state.hero.jetpack_power * 6, h: 27, r: 255, g: 255, b: 0 }
{% endhighlight %}

{% img center /images/jetpack-hero-vi-2.png %}

## Récupération de carburant

Pour récupérer du carburant pour le jetpack je place des bidons d'essence à
certains endroits :

{% highlight ruby %}
  args.state.fuel ||= [
    { x:700, y: 432, w: 25, h: 30, path: 'sprites/fuel.png', used: false },
    { x:700, y: 582, w: 25, h: 30, path: 'sprites/fuel.png', used: false },
  ]
{% endhighlight %}

On affiche comme d'habitude :

{% highlight ruby %}
  args.outputs.sprites << args.state.fuel
{% endhighlight %}

Et on met à jour le nécessaire lorsqu'une collision est détectée entre un bidon
d'essence et le personnage :

{% highlight ruby %}
  args.state.fuel.each do |f|
    if args.state.hero.intersect_rect?(f)
      args.state.hero.jetpack_power += 20
      args.state.hero.jetpack_power = args.state.hero.jetpack_power.clamp(0, 100)
      f.used = true
    end
  end
  args.state.fuel.reject!(&:used)
{% endhighlight %}

## Références

1. Vous trouverez le code de [Jetpack Hero](https://github.com/lkdjiin/jetpack-hero) sur github
1. [Documentation](https://docs.dragonruby.org/#/) de DragonRuby

{% include serie_003.md %}
