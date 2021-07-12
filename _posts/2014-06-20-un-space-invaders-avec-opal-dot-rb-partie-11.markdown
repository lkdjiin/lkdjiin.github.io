---
layout: post
title: "Un space invaders avec Opal.rb - partie 11"
date: 2014-06-20 21:16
legacy: true
tags: [intermédiaire, opal.rb, ruby, javascript, space invaders, jeu]
---



Je continue le refactoring de la méthode `update`:

{% highlight ruby %}
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
{% endhighlight %}

Je n'aime pas la condition multiple après le `if`. Je préfère:

<!-- more -->

{% highlight ruby %}
  def update
    @enemies.each do |enemy|
      if side?(enemy)
        change_enemies_direction
        enemies_down
        break
      end
    end
    @enemies.map {|enemy| enemy.move(@direction) }
  end
{% endhighlight %}

C'est bien mieux. La définition de la méthode `side?` pourrait être:

{% highlight ruby %}
  private

  def side?(enemy)
    enemy.x <= 10 || enemy.x + enemy.w >= 690
  end
{% endhighlight %}

Mais il reste des nombres magiques. En particulier le nombre 690, qui
signifie 10 pixel *avant* la largeur du canvas. J'ai donc besoin d'ajouter
ces notions à la classe `Enemies`:

{% highlight ruby %}
class Enemies
  include Enumerable
  ENEMIES_PER_ROW = 10
  SIDE_MARGIN = 10

  def initialize(world_width)
    @world_width = world_width
    .
    .
    .
{% endhighlight %}

La méthode `side?` devient donc:

{% highlight ruby %}
  def side?(enemy)
    enemy.x <= SIDE_MARGIN || enemy.x + enemy.w >= @world_width - SIDE_MARGIN
  end
{% endhighlight %}

C'est pas encore le top, mais ça ira pour l'instant. On voir pouvoir
ajouter quelques nouvelles fonctionnalités.



À demain.



