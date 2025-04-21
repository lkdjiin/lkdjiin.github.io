---
layout: post
title: "Jetpack Hero - partie II"
date: 2025-04-21 8:00
comments: true
tags: [ ruby, dragonruby, jeu ]
---

Il s'agit maintenant d'utiliser le jetpack en simulant la gravité. Simulation
naïve, mais simple.

<!-- more -->

## Impulsion du jetpack

Pour afficher un sprite le hash doit comporter les éléments `x`, `y`, `w`, `h` et
`path`. Mais on peut aussi y ajouter ce qu'on veut. La variable `impulse` retiendra
l'impulsion du jetpack, en nombre de pixels.

{% highlight ruby %}
  args.state.hero ||= {
    x: 600,
    y: 200,
    w: 7 * HERO_SCALE,
    h: 17 * HERO_SCALE,
    path: 'sprites/hero.png',
    impulse: 0,
  }
{% endhighlight %}

Lorsqu'on appuie sur la touche CONTROL du clavier ou la touche Y de la manette
(ou A, B, X, ça dépend de la manette) on fait monter le personnage de 4 pixels.
À chaque frame la valeur de `impulse` va diminuer un peu.

{% highlight ruby %}
IMPULSE = 4 # Jetpack power
IMPULSE_DECREASE = 0.9 # Jetpack power ratio decrease per frame

  if args.inputs.keyboard.control || args.inputs.controller_one.y
    args.state.hero.impulse = IMPULSE
  end

  args.state.hero.impulse *= IMPULSE_DECREASE
{% endhighlight %}

## La chute continuelle

Il est temps de mettre à jour la position `y` du personnage. Pour simuler une
espèce de gravité le personnage tombe tout le temps avec l'ajout de `-1.2`.

{% highlight ruby %}
FALL = -1.2 # Kind of gravity

  args.state.hero.y += FALL
  args.state.hero.y += args.state.hero.impulse
{% endhighlight %}

## On surveille les bords de l'écran

On s'occupe aussi de garder le personnage dans les limites de l'écran. DragonRuby
ajoute quelques méthodes à la classe `Numeric`, comme `clamp` :

{% highlight ruby %}
  args.state.hero.x = args.state.hero.x.clamp(0, Grid.w - args.state.hero.w)
  args.state.hero.y = args.state.hero.y.clamp(0, Grid.h - args.state.hero.h)
{% endhighlight %}

## Le programme complet

Pour le moment le programme entier ressemble à ce qui suit :

{% highlight ruby %}
# https://github.com/lkdjiin/jetpack-hero/tree/1c840ab53dd0d6dc8947c4efe075a78fc5047db8

HERO_SCALE = 4 # Image ratio
FALL = -1.2 # Kind of gravity
RL_SPEED = 5 # Right/left speed
IMPULSE = 4 # Jetpack power
IMPULSE_DECREASE = 0.9 # Jetpack power ratio decrease per frame

def tick args
  args.state.hero ||= {
    x: 600,
    y: 200,
    w: 7 * HERO_SCALE,
    h: 17 * HERO_SCALE,
    path: 'sprites/hero.png',
    impulse: 0,
  }

  if args.inputs.left
    args.state.hero.x -= RL_SPEED
  elsif args.inputs.right
    args.state.hero.x += RL_SPEED
  end

  if args.inputs.keyboard.control || args.inputs.controller_one.y
    args.state.hero.impulse = IMPULSE
  end

  args.state.hero.impulse *= IMPULSE_DECREASE
  args.state.hero.y += FALL
  args.state.hero.y += args.state.hero.impulse

  args.state.hero.x = args.state.hero.x.clamp(0, Grid.w - args.state.hero.w)
  args.state.hero.y = args.state.hero.y.clamp(0, Grid.h - args.state.hero.h)

  args.outputs.solids << { x: 0, y: 0, w: 1280, h: 720, r: 0, g: 0, b: 0 }
  args.outputs.sprites << args.state.hero
end
{% endhighlight %}

Pas encore 40 lignes et je trouve déjà que ça devient le boxon :D

## Du rangement

Dans un moteur de jeu, et même dans un jeu sans moteur, on retrouve d'une manière
ou d'une autre les quatre parties : initialisation, gestion des sorties, gestion
des entrées et calcul. Avec DragonRuby le niveau 1 de la structuration d'un programme (juste au-dessus
du niveau 0 : «on fourre tout dans tick») est d'utiliser le pattern suivant :

{% highlight ruby %}
def tick(args)
  defaults(args)
  render(args)
  input(args)
  calc(args)
end
{% endhighlight %}

On explose `tick` en quatre méthodes qui s'occuperont seulement de ce qui les concernent.
Voici donc le programme final pour aujourd'hui :

{% highlight ruby %}
# https://github.com/lkdjiin/jetpack-hero/tree/946a9b9071a86acb3dc4ae2b9c7bef4d5448bf39

HERO_SCALE = 4 # Image ratio
FALL = -1.2 # Kind of gravity
RL_SPEED = 5 # Right/left speed
IMPULSE = 4 # Jetpack power
IMPULSE_DECREASE = 0.9 # Jetpack power ratio decrease per frame

def tick(args)
  defaults(args)
  render(args)
  input(args)
  calc(args)
end

def defaults(args)
  args.state.hero ||= {
    x: 600,
    y: 200,
    w: 7 * HERO_SCALE,
    h: 17 * HERO_SCALE,
    path: 'sprites/hero.png',
    impulse: 0,
  }
end

def render(args)
  args.outputs.solids << { x: 0, y: 0, w: 1280, h: 720, r: 0, g: 0, b: 0 }
  args.outputs.sprites << args.state.hero
end

def input(args)
  if args.inputs.left
    args.state.hero.x -= RL_SPEED
  elsif args.inputs.right
    args.state.hero.x += RL_SPEED
  end

  if args.inputs.keyboard.control || args.inputs.controller_one.y
    args.state.hero.impulse = IMPULSE
  end
end

def calc(args)
  args.state.hero.impulse *= IMPULSE_DECREASE
  args.state.hero.y += FALL
  args.state.hero.y += args.state.hero.impulse
  args.state.hero.x = args.state.hero.x.clamp(0, Grid.w - args.state.hero.w)
  args.state.hero.y = args.state.hero.y.clamp(0, Grid.h - args.state.hero.h)
end
{% endhighlight %}

## Références

1. Vous trouverez le code de [Jetpack Hero](https://github.com/lkdjiin/jetpack-hero) sur github
1. [Documentation](https://docs.dragonruby.org/#/) de DragonRuby

{% include serie_003.md %}
