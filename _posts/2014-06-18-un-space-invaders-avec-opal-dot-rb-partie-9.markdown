---
layout: post
title: "Un space invaders avec Opal.rb - partie 9"
date: 2014-06-18 21:05
legacy: true
tags: [intermédiaire, opal.rb, ruby, javascript, space invaders, jeu]
---



Le code que j'ai posté hier, pour gérer le déplacement des envahisseurs,
a été écrit vite et sans trop de réflexion. Il nécessite donc un ~~petit~~
gros coup de refactoring.

<!-- more -->

Le pire morceau, tout du moins celui qui me saute aux yeux ce soir, est
la méthode `update` de la classe `Enemies`. C'est le genre de chose que je
ne laisserais jamais passer au boulot, par exemple. C'est un concentré de
mauvais code et de *code smells*:

{% highlight ruby %}
  def update
    @enemies.each do |e|
      if e.x <= 10 || e.x + e.w >= 690
        change_enemies_direction
        enemies_down
        break
      end
    end
    @enemies.each do |e|
      if @direction == :left
        e.x = e.x - 2
      else
        e.x = e.x + 2
      end
    end
  end
{% endhighlight %}

Je vais m'occuper d'abord de la seconde partie, celle qui déplace les
envahisseurs à droite ou à gauche:

    @enemies.each do |e|
      if @direction == :left
        e.x = e.x - 2
      else
        e.x = e.x + 2
      end
    end

Comme on a des méthodes `move_left` et `move_right` pour la classe `Player`,
pourquoi ne pas faire pareil avec la classe `Enemy` ? Voici donc une
nouvelle écriture de la classe `Enemy`:

{% highlight ruby %}
class Enemy
  DELTA = 2

  attr_accessor :x, :y, :w, :h, :color

  def initialize(x, y, w, h, color)
    @x = x
    @y = y
    @w = w
    @h = h
    @color = color
  end

  def move_left
    @x -= DELTA
  end

  def move_right
    @x += DELTA
  end

end
{% endhighlight %}

Si on la compare avec la classe `Player`, on s'aperçoit qu'elles sont
bien trop similaires. Mais on verra ça plus tard, retournons à
`Enemies#update`.

Avant:

{% highlight ruby %}
    @enemies.each do |e|
      if @direction == :left
        e.x = e.x - 2
      else
        e.x = e.x + 2
      end
    end
{% endhighlight %}

Après:

{% highlight ruby %}
    @enemies.map do |enemy|
      @direction == :left ? enemy.move_left : enemy.move_right
    end
{% endhighlight %}

J'utilise `map` au lieu de `each`, qui marque mieux l'intention de modifier
la collection. L'argument `e`, illisible, est devenu `enemy`, clair. Et
grâce à `move_left` et `move_right`, les messages envoyés à un objet
`Enemy` sont plus simples. On s'est aussi débarrassé d'un nombre magique.

OK, c'est bien mieux. Mais y a encore un truc qui me dérange profondément.
Vous voyez ce que je veux dire ? Non ? Alors rendez-vous demain ;)



À demain.



