---
layout: post
title: "Le duck typing avec Ruby"
date: 2014-04-07 21:19
legacy: true
tags: [ruby, débutant, orienté objet, duck typing]
---

Vous faites du Ruby depuis peu ? Vous venez d'un langage
orienté objet plus *classique*, comme par exemple Java ?
Vous entendez parler de **duck typing** régulièrement sans
trop voir de quoi il retourne ?
Aujourd'hui on voit ce qu'est le duck typing.

<!-- more -->

Pour la petite histoire, nous allons faire marcher (*walk*) des
rats (*Rat*) et des souris (*Mice*). Rat et souris étants des
mammifères (*Mammal*).

En mimant un langage comme Java, nous allons d'abord créer
une classe de base qui implémente une méthode `walk`:

{% highlight ruby %}
class Mammal
  def walk
    raise NotImplementedError
  end
end

Mammal.new.walk
{% endhighlight %}

Vous remarquez que cette méthode `walk` soulève une
exception si elle est appelée. Elle n'est ici que pour nous
rappeler que les classes filles devront l'implémenter:

{% highlight raw %}
$ ruby duck.rb 
duck.rb:3:in `walk': NotImplementedError (NotImplementedError)
{% endhighlight %}

Poursuivons le mimétisme Java en créant les classes `Rat` et
`Mice` qui héritent de `Mammal`, et qui donc implémentent
conciencieusement la méthode `walk`

{% highlight ruby %}
class Mammal
  def walk
    raise NotImplementedError
  end
end

class Rat < Mammal
  def walk
    "I am a Rat and I walk"
  end
end

class Mice < Mammal
  def walk
    "I am a Mice and I walk"
  end
end

puts Rat.new.walk
puts Mice.new.walk
{% endhighlight %}

Le résultat est celui qu'on attend:

{% highlight raw %}
$ ruby duck.rb 
I am a Rat and I walk
I am a Mice and I walk
{% endhighlight %}

Maintenant ajoutons une classe `Laboratory` qui a pour rôle
de manipuler nos animaux, en les faisant marcher à la
demande:

{% highlight ruby %}
class Mammal
  def walk
    raise NotImplementedError
  end
end

class Rat < Mammal
  def walk
    "I am a Rat and I walk"
  end
end

class Mice < Mammal
  def walk
    "I am a Mice and I walk"
  end
end

class Laboratory
  def self.make_walk(pet)
    pet.walk
  end
end

puts Laboratory.make_walk(Rat.new)
puts Laboratory.make_walk(Mice.new)
{% endhighlight %}

{% highlight raw %}
$ ruby duck.rb 
I am a Rat and I walk
I am a Mice and I walk
{% endhighlight %}

Et là, si vous venez d'un langage orienté objet dit
*classique*, vous devriez avoir tiqué, fait la grimace,
vous être gratté la barbe, etc. Et oui, la classe
`Laboratory` n'a *aucune connaissance* de la classe
`Mammal`. Et pourtant la ligne `pet.walk` fonctionne
comme un charme. C'est parce que nous sommes en Ruby,
un langage *dynamique*. On pourrait dire un langage qui
n'a que faire des *types* (bon c'est exagéré, hein).

Si `Laboratory` n'utilise pas `Mammal`, on pourrait
peut-être carrément la supprimer ?
On essaye :

{% highlight ruby %}
class Rat
  def walk
    "I am a Rat and I walk"
  end
end

class Mice
  def walk
    "I am a Mice and I walk"
  end
end

class Laboratory
  def self.make_walk(pet)
    pet.walk
  end
end

puts Laboratory.make_walk(Rat.new)
puts Laboratory.make_walk(Mice.new)
{% endhighlight %}

{% highlight raw %}
$ ruby duck.rb 
I am a Rat and I walk
I am a Mice and I walk
{% endhighlight %}

C'est ça le duck typing. On ne s'intéresse pas à ce
**qu'est** l'objet mais à ce **qu'il sait faire**.

Alors ça ne veut pas dire pour autant que l'héritage est
inutile ou inutilisé avec Ruby. Mais simplement qu'on
va l'utiliser moins qu'ailleurs parce que 1) on peut le
faire et 2) parce qu'on va se concentrer sur le
comportement et pas sur l'être.

Voilà, c'était une explication parmi d'autres du
duck typing.



À demain.





