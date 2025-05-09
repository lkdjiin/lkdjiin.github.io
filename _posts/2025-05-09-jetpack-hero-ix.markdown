---
layout: post
title: "Du rangement avec la classe Game (Jetpack Hero)"
date: 2025-05-09 12:00
comments: true
tags: [ jeu, dragonruby, ruby ]
---

Quand on commence l'écriture d'un jeu avec DragonRuby il est d'usage de tout mettre dans la
méthode `tick`.

{% highlight ruby %}
    def tick(args)
      # Tout le jeu
    end
{% endhighlight %}

C'est le niveau zéro de la structuration (il n'y en a pas)
mais c'est idéal pour commencer rapidement et sans prise de tête.
Bien sûr ça devient assez vite le fouillis…

<!-- more -->

## Niveau 1

Quand ça devient le cas, le pattern à suivre est de séparer le code en 4 méthodes :

{% highlight ruby %}
    def tick(args)
      defaults(args)
      render(args)
      input(args)
      calc(args)
    end

    def defaults(args)
      # Code pour l'initialisation
    end

    def render(args)
      # Code dédié à l'affichage
    end

    def input(args)
      # Gestion du clavier, des manettes, etc
    end

    def calc(args)
      # Tout les calculs
    end
{% endhighlight %}

Passer du niveau zéro au niveau 1 est très rapide et on gagne tout de suite en
clarté, mais
immanquablement il arrive là aussi un moment où le contenu de ces méthodes devient
incontrôlable.

## Niveau 2

Il est alors d'usage d'exploser le contenu en plusieurs méthodes,
chacune gérant sa propre affaire (on dirait _concern_ en anglais). Par exemple
la méthode `calc` de notre jeu pourrait ressembler à ceci si on la remaniait de
cette manière :

{% highlight ruby %}
    def calc(args)
      calc_init(args)
      calc_hero_location_y(args)
      calc_direction(args)
      calc_platform_collisions(args)
      calc_picking_fuel(args)
      calc_picking_ore(args)
      calc_collecting_ore(args)
    end
{% endhighlight %}

Mais je n'aime pas faire cette étape. D'un côté c'est évidemment mieux que sans, car il
est préférable d'avoir dix méthodes de dix lignes qu'une seule de cent lignes.
D'un autre côté le passage en argument de `args` dans toutes les méthodes ne
fait que souligner ce qu'il manque : une classe.

## Niveau 3

C'est pourquoi on va passer directement au niveau supérieur :

{% highlight ruby %}
    class Game
      attr_gtk

      def tick
        defaults
        render
        input
        calc
      end

      def defaults
       # ...
      end

      # ...
    end

    $game = Game.new

    def tick(args)
      $game.args = args
      $game.tick
    end
{% endhighlight %}

`attr_gtk` nous fournit _magiquement_ `@args` et des méthodes comme `outputs` ou `inputs`
qui nous permettent de se passer d'écrire `args` partout.

## Références

1. Vous trouverez le code de [Jetpack Hero](https://github.com/lkdjiin/jetpack-hero) sur github
1. [Documentation](https://docs.dragonruby.org/#/) de DragonRuby

{% include serie_003.md %}
