---
layout: post
title: "Jetpack Hero III - Une plateforme, des collisions"
date: 2025-04-22 8:00
comments: true
tags: [ ruby, dragonruby, jeu ]
---

Voyons comment afficher une plateforme, comment le personnage peut s'y cogner, et
comment il peut s'y promener.

{% img center /images/jetpack-hero-iii-1.png %}

<!-- more -->


## Affichage

La plateforme est un PNG de 8x12 que j'étire à une largeur de 500 pixels. Comme
le personnage, c'est un hash qu'on place dans `args.state` et qu'on affiche en
l'ajoutant dans `args.outputs.sprites`.

{% highlight ruby %}
 args.state.platform ||= {
   x: 400,
   y: 400,
   w: 500,
   h: 12,
   path: 'sprites/tile.png'
 }

 args.outputs.sprites << args.state.platform
{% endhighlight %}

## Collision au bas de la plateforme

Considérons dans un premier temps que le personnage peut se cogner la tête sur
la plateforme lorsqu'il l'aborde par le bas, et oublions les côtés et le haut de la plateforme.
DragonRuby offre la méthode `intersect_rect?` pour tout objet considéré comme un
rectangle. Un rectangle répond à `x`, `y`, `w` et `h`. Donc `a.intersect_rect?(b)` teste si une
collision existe entre les rectangles a et b.
Quand une collision se produit entre le personnage et la plateforme, le personnage est
replacé sous la plateforme. J'ajoute `-2` parce que j'aime bien l'effet que ça produit.

{% highlight ruby %}
 if args.state.hero.intersect_rect?(args.state.platform)
   # Assuming hero is coming from below
   args.state.hero.y = args.state.platform.y - args.state.hero.h - 2
 end
{% endhighlight %}

Ça fonctionne bien quand le perso vient d'en bas.
Si vous approchez la plateforme depuis le haut ou un côté cela va activer la téléportation :D

## Collision en haut

Maintenant qu'est-ce qu'on fait quand le perso vient d'en haut ?
D'abord il faut être en mesure de déterminer si le perso monte ou descend.
Je vois deux solutions :

1. `impulse + FALL` supérieur à zéro veut dire que le perso monte,sinon il descend.
2. On enregistre le `y` avant transformation. Puis on calcule (après - avant), une valeur négative veut dire qu'on descend.

J'ai une préférence pour la seconde méthode car je ne sais pas ce qui pourrait venir plus tard affecter le `y` du perso, en plus
de FALL et impulse.

Pour vérifier que la méthode fonctionne, on peut écrire dans la console avec `puts` :

{% highlight ruby %}
def calc(args)
  # Enregistrement du y avant transformation.
  y_before = args.state.hero.y

  # Transformation
  args.state.hero.impulse *= IMPULSE_DECREASE
  args.state.hero.y += FALL
  args.state.hero.y += args.state.hero.impulse

  # Test (après - avant)
  if args.state.hero.y - y_before < 0
    puts "En descente"
  else
    puts "Je monte"
  end

  # [...]
end
{% endhighlight %}

Pour référence, voici la méthode `calc` complète, avec la gestion des collisions d'en haut ou d'en bas du perso contre une
plateforme :


{% highlight ruby %}
def calc(args)
  y_before = args.state.hero.y

  args.state.hero.impulse *= IMPULSE_DECREASE
  args.state.hero.y += FALL
  args.state.hero.y += args.state.hero.impulse

  if args.state.hero.y - y_before < 0
    ascending = false
  else
    ascending = true
  end

  if args.state.hero.intersect_rect?(args.state.platform)
    if ascending
      args.state.hero.y = args.state.platform.y - args.state.hero.h - 2
    else
      args.state.hero.y = args.state.platform.y + args.state.platform.h
    end
  end

  args.state.hero.x = args.state.hero.x.clamp(0, Grid.w - args.state.hero.w)
  args.state.hero.y = args.state.hero.y.clamp(0, Grid.h - args.state.hero.h)
end
{% endhighlight %}

## Et pour les côtés ?

Reste à savoir ce qu'on fait quand le perso vient d'un côté.

On voudrait faire un truc similaire, c'est à dire enregistrer le `x` avant transformation pour
savoir si le perso vient de la gauche ou de la droite, mais pour l'instant la transformation est faite
directement dans la méthode `input` :

{% highlight ruby %}
def input(args)
  if args.inputs.left
    args.state.hero.x -= RL_SPEED
{% endhighlight %}

Et ça c'est pas bien du tout, `input()` ne devrait jamais faire de calculs.
Il faut donc améliorer ça pour que les transformations soit réalisées dans la méthode `calc`.
J'ajoute l'état `moving` au hash `hero`, au choix `:none`, `:left` ou `:right` :

{% highlight ruby %}
args.state.hero ||= {
# [...]
moving: :none,
}
{% endhighlight %}


L'état `moving` est modifié dans `input()` à chaque frame :

{% highlight ruby %}
def input(args)
  if args.inputs.left
    args.state.hero.moving = :left
  elsif args.inputs.right
    args.state.hero.moving = :right
  else
    args.state.hero.moving = :none
  end
end
{% endhighlight %}

Maintenant on peut écrire la méthode `calc()` en gérant les collisions de tout
les côtés :


{% highlight ruby %}
def calc(args)
  y_before = args.state.hero.y
  x_before = args.state.hero.x

  args.state.hero.impulse *= IMPULSE_DECREASE
  args.state.hero.y += FALL
  args.state.hero.y += args.state.hero.impulse

  if args.state.hero.moving == :left
    args.state.hero.x -= RL_SPEED
  elsif args.state.hero.moving == :right
    args.state.hero.x += RL_SPEED
  end

  if args.state.hero.y - y_before < 0
    ascending = false
  else
    ascending = true
  end

  if args.state.hero.intersect_rect?(args.state.platform)
    # Le perso vient de la gauche
    if (x_before + args.state.hero.w) < args.state.platform.x
      args.state.hero.x = x_before
    # Le perso vient de la droite
    elsif x_before >= (args.state.platform.x + args.state.platform.w)
      args.state.hero.x = x_before
    # Le perso monte
    elsif ascending
      args.state.hero.y = args.state.platform.y - args.state.hero.h - 2
    # Le perso descend
    else
      args.state.hero.y = args.state.platform.y + args.state.platform.h
    end
  end

  args.state.hero.x = args.state.hero.x.clamp(0, Grid.w - args.state.hero.w)
  args.state.hero.y = args.state.hero.y.clamp(0, Grid.h - args.state.hero.h)
end
{% endhighlight %}

## Références

1. Vous trouverez le code de [Jetpack Hero](https://github.com/lkdjiin/jetpack-hero) sur github
1. [Documentation](https://docs.dragonruby.org/#/) de DragonRuby

{% include serie_003.md %}
