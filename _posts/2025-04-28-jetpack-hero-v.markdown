---
layout: post
title: "Jetpack Hero V : Ajouter des plateformes"
date: 2025-04-28 8:00
comments: true
tags: [ jeu, ruby, dragonruby ]
---

Notre personnage doit pouvoir évoluer sur plusieurs plateformes. Sinon quelle serait
l'utilité d'avoir un jetpack ?

<!-- more -->

On regroupe toutes nos plateformes dans un tableau de sprites :

{% highlight ruby %}
def defaults(args)
  args.state.platforms ||= [
    { x: 0, y: 550, w: 200, h: 12, path: 'sprites/tile.png' },
    { x: 400, y: 550, w: 700, h: 12, path: 'sprites/tile.png' },
  ]
end
{% endhighlight %}

Et on l'affiche de la manière qu'on connait déjà. `sprites` accepte aussi bien
un _hash_ qu'un _array_ :

{% highlight ruby %}
def render(args)
  args.outputs.sprites << args.state.platforms
end
{% endhighlight %}

Et on calculera les collisions pour chaque plateforme :

{% highlight ruby %}
def calc(args)
  args.state.platforms.each do |p|
    if args.state.hero.intersect_rect?(p)
      if (x_before + args.state.hero.w) < p.x
        args.state.hero.x = x_before
      elsif x_before >= (p.x + p.w)
        args.state.hero.x = x_before
      elsif ascending
        args.state.hero.y = p.y - args.state.hero.h - 2
      else
        args.state.hero.path = 'sprites/hero-standing.png'
        args.state.hero.y = p.y + p.h
      end
    end
  end
end
{% endhighlight %}

Mais si on doit gérer beaucoup de plateformes ça peut-être mauvais pour les
performances. On utilisera plutôt `find` pour s'arrêter dès qu'on a repéré
une collision, puisqu'en toute logique le perso ne peut entrer en collision qu'avec
une seule plateforme à la fois. Mais il y a une manière plus _DragonRuby_ de faire.
La méthode `find_intersect_rect` est optimisée pour ce travail :

{% highlight ruby %}
def calc(args)
  if p = Geometry.find_intersect_rect(args.state.hero, args.state.platforms)
    if (x_before + args.state.hero.w) < p.x
      args.state.hero.x = x_before
    elsif x_before >= (p.x + p.w)
      args.state.hero.x = x_before
    elsif ascending
      args.state.hero.y = p.y - args.state.hero.h - 2
    else
      args.state.hero.path = 'sprites/hero-standing.png'
      args.state.hero.y = p.y + p.h
    end
  end
end
{% endhighlight %}

Je sais bien que l'idiome suivant :

    if variable
      # Faire un truc
    end

fera mal aux yeux de beaucoup, mais il
faut accepter qu'on est en train de faire du DragonRuby, et pas du Rails ;)

## Références

1. Vous trouverez le code de [Jetpack Hero](https://github.com/lkdjiin/jetpack-hero) sur github
1. [Documentation](https://docs.dragonruby.org/#/) de DragonRuby

{% include serie_003.md %}
