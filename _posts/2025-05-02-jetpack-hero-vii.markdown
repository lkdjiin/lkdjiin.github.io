---
layout: post
title: "Collecte de minerai (Jetpack Hero)"
date: 2025-05-02 8:00
comments: true
tags: [ ruby, dragonruby, jeu ]
---

J'ai décidé que l'objectif du jeu serait de collecter du minerai. Pour terminer
un niveau, il faut apporter chaque tas de minerai au collecteur.

<!-- more -->


## Ramasser du minerai

{% img center /images/jetpack-hero-vii-1.png %}

Dans un premier temps on s'inspire de ce qu'on a déjà fait avec les barils de
fuel. On remplit un tableau avec des _hash_ représentant des sprites de minerai
et on les affiche :

{% highlight ruby %}
  args.state.ores ||= [
    { x:1220, y: 282, w: 30, h: 27, path: 'sprites/gold.png', used: false },
    # ...
  ]

  args.outputs.sprites << args.state.ores
{% endhighlight %}

Lorsqu'on détecte une collision entre le personnage et un tas de minerai, celui-ci
est considéré comme ramassé :

{% highlight ruby %}
  args.state.ores.each do |o|
    if args.state.hero.intersect_rect?(o)
      o.used = true
    end
  end
  args.state.ores.reject!(&:used)
{% endhighlight %}

## Apporter le minerai au collecteur

Maintenant on ajoute le collecteur, qui est simplement un endroit où le personnage
va devoir déposer le minerai :

{% highlight ruby %}
  args.state.collector ||= { x:0, y: 582, w: 80, h: 80, path: 'sprites/collector.png' }

  args.outputs.sprites << args.state.collector
{% endhighlight %}

Le perso peut transporter un seul tas de minerai à la fois.

{% highlight ruby %}
  args.state.hero ||= {
    # ...
    ore: 0,
  }
{% endhighlight %}

On transforme en conséquence la détection de collision :

{% highlight ruby %}
  args.state.ores.each do |o|
    if args.state.hero.ore == 0 && args.state.hero.intersect_rect?(o)
      o.used = true
      args.state.hero.ore = 1
      puts "I pick one!"
    end
  end
  args.state.ores.reject!(&:used)
{% endhighlight %}

Et on dépose un tas de minerai au collecteur.

{% highlight ruby %}
  if args.state.hero.ore == 1 && args.state.hero.intersect_rect?(args.state.collector)
    args.state.hero.ore = 0
    puts "100 points!"
  end
{% endhighlight %}

J'ajoute une indication visuelle pour savoir quand le perso transporte du minerai
en affichant du minerai en dessous du personnage.
Je n'en suis pas fou, mais ça fonctionne pour l'instant.

{% highlight ruby %}
  if args.state.hero.ore == 1
    args.outputs.sprites << {
      x: args.state.hero.x,
      y: args.state.hero.y,
      w: 30, h: 40, path: 'sprites/gold.png'
    }
  end
  args.outputs.sprites << args.state.hero
{% endhighlight %}

## Première notion de niveau

On peut commencer à penser les niveaux du jeu. On crée une structure, qui pour
l'instant contient un minimum d'informations : le nombre de minerai restant à
collecter et si oui ou non le niveau est terminé.

{% highlight ruby %}
  args.state.level ||= {
    remaining_ores: 5,
    completed: false,
  }
{% endhighlight %}

On met à jour ces infos quand le personnage dépose du minerai dans le collecteur.

{% highlight ruby %}
  if args.state.hero.ore == 1 && args.state.hero.intersect_rect?(args.state.collector)
    args.state.hero.ore = 0
    args.state.level.remaining_ores -= 1
    args.state.level.completed = true if args.state.level.remaining_ores == 0
  end
{% endhighlight %}

Et finalement on indique quand le niveau est terminé :

{% highlight ruby %}
  if args.state.level.completed
    args.outputs.labels << {
      x: 640,
      y: 360,
      size_px: 120,
      alignment_enum: 1,
      vertical_alignment_enum: 1,
      text: "Level Completed!",
      r: 255,
      g: 255,
      b: 255,
    }
  end
{% endhighlight %}

{% img center /images/jetpack-hero-vii-2.png %}

## Références

1. Vous trouverez le code de [Jetpack Hero](https://github.com/lkdjiin/jetpack-hero) sur github
1. [Documentation](https://docs.dragonruby.org/#/) de DragonRuby

{% include serie_003.md %}
