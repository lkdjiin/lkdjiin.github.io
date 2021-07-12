---
layout: post
title: "Utiliser Enumerable en Ruby"
date: 2014-06-09 16:47
legacy: true
tags: [intermédiaire, ruby, module, enumerable]
---



Il y a quelques jours, j'ai testé Opal.rb. Et pour ça, j'ai écris un jeu
du type Space Invaders ;) J'ai une classe `Enemy`, que je peux résumer ainsi:

{% highlight ruby %}
class Enemy
  attr_reader :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end

  def to_s
    "#<Enemy x:#@x y:#@y>"
  end
end
{% endhighlight %}

<!-- more -->

J'ai aussi une classe `Enemies`, pour gérer ce qui se passe au niveau de
tous les ennemies. Inclure le module [Enumerable](http://ruby-doc.org/core-2.1.2/Enumerable.html)
et définir la méthode `each` me permet d'utiliser toutes les méthodes de ce
module.

{% highlight ruby %}
class Enemies
  include Enumerable

  def initialize
    @enemies = []
  end

  def each(&block)
    @enemies.each(&block)
  end

  def <<(item)
    @enemies << item
  end
end
{% endhighlight %}

Créons un groupe de trois ennemies :

{% highlight ruby %}
enemies = Enemies.new
enemies << Enemy.new(10, 15)
enemies << Enemy.new(20, 15)
enemies << Enemy.new(10, 40)
{% endhighlight %}

Voyons si `each` fonctionne bien :

    > enemies.each {|item| puts item }
    #<Enemy x:10 y:15>
    #<Enemy x:20 y:15>
    #<Enemy x:10 y:40>

J'ai donc accès à toutes les autres méthodes de `Enumerable`, comme par
exemple `select`:

    > puts enemies.select {|item| item.x == 10 }
    #<Enemy x:10 y:15>
    #<Enemy x:10 y:40>



À demain.


