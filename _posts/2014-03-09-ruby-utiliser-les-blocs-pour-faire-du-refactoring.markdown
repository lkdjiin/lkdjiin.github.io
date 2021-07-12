---
layout: post
title: "Ruby - Utiliser les blocs pour faire du refactoring"
date: 2014-03-09 15:50
legacy: true
tags: [ruby, refactoring, bloc, débutant]
---



Suivant le(s) langage(s) que vous pratiquiez avant de vous mettre à Ruby,
les blocs peuvent vous sembler plus ou moins obscurs. Voici un
exemple d'utilisation possible, lorsque vous faites du refactoring.

<!-- more -->

Prenons le programme suivant:

{% highlight ruby %}
class Bidule
  def un
    puts 'Début de la méthode un'
    puts 'Au milieu de la méthode un'
    puts 'Fin de la méthode un'
  end

  def deux
    puts 'Début de la méthode deux'
    puts 'Au milieu de la méthode deux'
    puts 'Fin de la méthode deux'
  end
end

bidule = Bidule.new
bidule.un
bidule.deux
{% endhighlight %}

Voici ce que ça donne quand on le lance:

{% highlight bash %}
$ ruby test1.rb 
Début de la méthode un
Au milieu de la méthode un
Fin de la méthode un
Début de la méthode deux
Au milieu de la méthode deux
Fin de la méthode deux
{% endhighlight %}

Le problème de la classe `Bidule` est que ses méthodes `un` et `deux`
sont identiques (ou presque). On aura donc intérêt à extraire une
méthode helper:

{% highlight ruby %}
class Bidule
  def un
    helper('un')
  end

  def deux
    helper('deux')
  end

  private

  def helper(argument)
    puts "Début de la méthode #{argument}"
    puts "Au milieu de la méthode #{argument}"
    puts "Fin de la méthode #{argument}"
  end
end
{% endhighlight %}

Voilà, c'était du refactoring classique.

Maintenant imaginons que la classe `Bidule` soit ainsi:

{% highlight ruby %}
class Bidule
  def un
    puts 'Début de la méthode un'
    puts 'Au milieu de la méthode un'
    puts 'Fin de la méthode un'
  end

  def deux
    puts 'Début de la méthode deux'
    puts 'Ceci est le milieu de la méthode deux'
    puts 'Fin de la méthode deux'
  end
end
{% endhighlight %}

Vous avez remarqué la différence:

{% highlight ruby %}
  def un
    #
    puts 'Au milieu de la méthode un'
    #
  end

  def deux
    #
    puts 'Ceci est le milieu de la méthode deux'
    #
  end
{% endhighlight %}

Cette fois les méthodes `un` et `deux` se distinguent un peu plus, bien
que la logique reste identique. On peux donc tirer avantage des blocs:

{% highlight ruby %}
class Bidule
  def un
    helper('un') { puts 'Au milieu de la méthode un' }
  end

  def deux
    helper('deux') do
      puts 'Ceci est le milieu de la méthode deux'
    end
  end

  private

  def helper(argument, &block)
    puts "Début de la méthode #{argument}"
    block.call
    puts "Fin de la méthode #{argument}"
  end
end
{% endhighlight %}



À demain.



