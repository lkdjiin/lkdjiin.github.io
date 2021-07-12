---
layout: post
title: "La méthode super en Ruby - partie 2"
date: 2014-03-25 19:53
legacy: true
tags: [ruby, débutant, super, héritage, orienté objet]
---



Comme me le faisait remarquer ce matin un lecteur, il manque un cas à
mon article d'hier sur l'utilisation de `super` en Ruby. C'est d'autant
plus impardonnable que c'est un cas où, pour une fois, les parenthèses
sont **obligatoires** à la fin d'une méthode.

<!-- more -->

Voici donc une classe de base et une classe fille:

{% highlight ruby %}
class Base
  def foo
    puts "Base#foo"
  end
end

class Child < Base
  def foo(bar)
    super
    puts "Child#foo with #{bar}"
  end
end
{% endhighlight %}

Et maintenant on essaye le tout:

{% highlight ruby %}
child = Child.new
child.foo
#=> ArgumentError: wrong number of arguments (0 for 1)
{% endhighlight %}

Boum ! Comme on l'a vu hier, `super` passe automatiquement tous les
paramètres de la méthode dans laquelle il est appelé vers la classe
de base. Et là, notre méthode `foo` dans la classe de base est sans
argument.

Pour résoudre ce problème, on est obligé de mettre des parenthèses
à la suite de `super`:

{% highlight ruby %}
class Child < Base
  def foo(bar)
    super()
    puts "Child#foo with #{bar}"
  end
end
{% endhighlight %}

{% highlight ruby %}
child = Child.new
child.foo('ok')
Base#foo
Child#foo with ok
{% endhighlight %}

Voilà, oubli réparé.



À demain.



