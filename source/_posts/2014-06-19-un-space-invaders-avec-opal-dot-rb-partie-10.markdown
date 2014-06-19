---
layout: post
title: "Un space invaders avec Opal.rb - partie 10"
date: 2014-06-19 21:04
comments: true
categories: [intermédiaire, opal.rb, ruby, javascript, space invaders, jeu]
---

{% level 2 %}

Le code suivant ne me convient toujours pas :

``` ruby
    @enemies.map do |enemy|
      @direction == :left ? enemy.move_left : enemy.move_right
    end
```

Pourquoi ne pas dire
simplement à la classe `Enemy` ce qu'elle doit faire en une seule fois:

``` ruby
    @enemies.map {|enemy| enemy.move(@direction) }
```

<!-- more -->

C'est quand même bien plus simple ! Bien sûr, pour que ça fonctionne il
faut ajouter une méthode à la classe `Enemy`:

``` ruby
  def move(direction)
    direction == :left ? move_left : move_right
  end
```

Et tant qu'on y est, on fait pareil avec la méthode `enemies_down`.

Avant:

``` ruby
  def enemies_down
    @enemies.each do |e|
      e.y = e.y + 4
    end
  end
```

Après:

``` ruby
  def enemies_down
    @enemies.map(&:move_down)
  end
```

Et on ajoute ceci à `Enemy`:

``` ruby
  def move_down
    @y += 4
  end
```

Pour terminer cet article,
voici le code des classes `Enemy` et `Enemies`:

``` ruby app/enemy.rb
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

  def move(direction)
    direction == :left ? move_left : move_right
  end

  def move_down
    @y += 4
  end
end
```

``` ruby app/enemies.rb
class Enemies
  include Enumerable
  ENEMIES_PER_ROW = 10

  def initialize
    @enemies = []
    @direction = :right
    build(60, '#0000ff')
    build(120, '#0000dd')
    build(180, '#0000bb')
    build(240, '#000099')
    build(300, '#000077')
  end

  def each(&block)
    @enemies.each(&block)
  end

  def update
    @enemies.each do |e|
      if e.x <= 10 || e.x + e.w >= 690
        change_enemies_direction
        enemies_down
        break
      end
    end
    @enemies.map {|enemy| enemy.move(@direction) }
  end

  private

  def change_enemies_direction
    if @direction == :left
      @direction = :right
    else
      @direction = :left
    end
  end

  def enemies_down
    @enemies.map(&:move_down)
  end

  def build(y, color)
    (1..ENEMIES_PER_ROW).each do |i|
      @enemies << Enemy.new(50 + i * 60, y, 40, 40, color)
    end
  end

end
```

Il reste encore un peu de travail…

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}


