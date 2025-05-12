---
layout: post
title: "Tir du personnage (Jetpack Hero)"
date: 2025-05-12 8:00
comments: true
tags: [ ruby, dragonruby, jeu ]
---

Le personnage doit pouvoir tirer au laser pour dégommer les aliens. Voyons comment gérer les entrées,
ajouter du son, animer le tir, etc…

<!-- more -->

## Un tir très simple pour commencer

Dans cette première version il est impossible de tirer plus d'une fois.
Impossible aussi de tirer à gauche, le laser part toujours à droite.
Bref, pas très utile, mais il faut bien commencer quelque part.

Je commence par ajouter l'état `shooting` dans le hash `hero` pour savoir si un
tir est en cours.

{% highlight ruby %}
    state.hero ||= {
      # ...
      shooting: false,
    }
{% endhighlight %}

Il nous faut un hash pour conserver les sprites de laser, et il faut les
afficher.

{% highlight ruby %}
    state.shots ||= []

    outputs.sprites << state.shots
{% endhighlight %}

On déclenche le tir avec la touche ALT ou un bouton de la manette.
Sans la ligne `if state.shots.empty?` un tir serait déclenché à chaque frame. Essayez pour voir le problème.

{% highlight ruby %}
    if inputs.keyboard.alt || inputs.controller_one.b
      if state.shots.empty?
        state.hero.shooting = true
        audio[:laser] = { input: 'sounds/laser.wav' }
      end
    end
{% endhighlight %}

Si un tir à eu lieu, on ajoute un sprite dans le hash `shots`. Ce sprite sera
déplacé de 5 pixels vers la droite à chaque frame.

{% highlight ruby %}
  def calc_shot
    if state.hero.shooting
      state.shots << {
        x: state.hero.x,
        y: state.hero.y + 20,
        w: 24,
        h: 10,
        path: 'sprites/laser.png',
      }
      state.hero.shooting = false
    end
    state.shots.each do |shot|
      shot.x += 5
    end
  end
{% endhighlight %}

## Pouvoir tirer et re-tirer

On ajoute un état `dead` à chaque tir, qui passe à `true` quand le sprite
disparait de l'écran. Ça permet de supprimer les tirs hors jeu avec `reject!`.
De cette manière on obtient un tir _à la space invaders_.

{% highlight ruby %}
  def calc_shot
    if state.hero.shooting
      state.shots << {
        # ...
        dead: false,
      }
      state.hero.shooting = false
    end

    state.shots.each do |shot|
      shot.x += 5
      shot.dead = true if shot.x > Grid.w
    end
    state.shots.reject!(&:dead)
  end
{% endhighlight %}

## Tirer à droite et à gauche

L'état `hero.moving` nous permet de savoir si le perso bouge vers la droite ou la gauche,
mais ne nous apprend rien quand à la direction à laquelle il fait face
lorsqu'il ne bouge pas. On va ajouter `hero.facing` pour toujours savoir où le
perso regarde, même quand il est à l'arrêt.

{% highlight ruby %}
    state.hero ||= {
      # ...
      moving: :none,
      facing: :right,
      # ...
    }

  def input
    if inputs.left
      state.hero.moving = :left
      state.hero.facing = :left
    elsif inputs.right
      state.hero.moving = :right
      state.hero.facing = :right
    else
      state.hero.moving = :none
    end
  end
{% endhighlight %}

Maintenant on peut tirer dans la direction du regard du perso, par l'intermédiaire de
`speed`.

{% highlight ruby %}
  def calc_shot
    if state.hero.shooting
      state.shots << {
        # ...
        speed: state.hero.facing == :right ? LASER_SPEED : -LASER_SPEED,
      }
      state.hero.shooting = false
    end

    state.shots.each do |shot|
      shot.x += shot.speed
      shot.dead = true if shot.x > Grid.w || shot.x < 0
    end
    state.shots.reject!(&:dead)
  end
{% endhighlight %}

## Cadence de tir

Disons qu'on veut pouvoir tirer toutes les 1/2 secondes, donc toutes les 30
frames :

{% highlight ruby %}
    FIRE_RATE = 30 # Maximum is one shot every FIRE_RATE frames
{% endhighlight %}

On va se souvenir du moment du dernier tir :

{% highlight ruby %}
    state.hero ||= {
      # ...
      last_shot_at: 0,
    }
{% endhighlight %}

On autorisera un tir seulement si le dernier a eu lieu il y a plus d'une demi
seconde :

{% highlight ruby %}
    if inputs.keyboard.alt || inputs.controller_one.b
      if state.hero.last_shot_at + FIRE_RATE < Kernel.tick_count
        state.hero.shooting = true
        audio[:laser] = { input: 'sounds/laser.wav' }
      end
    end
{% endhighlight %}

On met à jour le moment du tir :

{% highlight ruby %}
  def calc_shot
    if state.hero.shooting
      state.shots << {
        # ...
      }
      state.hero.shooting = false
      state.hero.last_shot_at = Kernel.tick_count
    end
{% endhighlight %}

## Animation

Pour finir, voici une animation toute simple du laser. Celui-ci est retourné
verticallement toutes les 10 frames :

{% highlight ruby %}
  LASER_ANIMATION = 10

  def calc_shot
    if state.hero.shooting
      state.shots << {
        # ...
        animation_counter: LASER_ANIMATION,
        flip_vertically: false,
      }
      state.hero.shooting = false
      state.hero.last_shot_at = Kernel.tick_count
    end

    state.shots.each do |shot|
      shot.animation_counter -= 1
      if shot.animation_counter == 0
        shot.animation_counter = LASER_ANIMATION
        shot.flip_vertically = !shot.flip_vertically
      end
      shot.x += shot.speed
      shot.dead = true if shot.x > Grid.w || shot.x < 0
    end
    state.shots.reject!(&:dead)
  end
{% endhighlight %}

## Références

1. Vous trouverez le code de [Jetpack Hero](https://github.com/lkdjiin/jetpack-hero) sur github
1. [Documentation](https://docs.dragonruby.org/#/) de DragonRuby

{% include serie_003.md %}
