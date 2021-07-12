---
layout: post
title: "Ruby 2.1: Les nouvelles méthodes de Set"
date: 2013-12-30 19:10
legacy: true
tags: [ruby, set, débutant, ruby 2.1]
---



Avec la sortie de Ruby 2.1, la bibliothèque standard `Set` s'enrichie de 
deux méthodes supplémentaires: `disjoint?` et `intersect?`.

<!-- more -->

`Set` permet de créer un ensemble d'éléments uniques:

{% highlight irb %}
>> require 'set'
>> Set.new [1, 2, 1, 2, 2]
=> #<Set: {1, 2}>
{% endhighlight %}

La nouvelle méthode `intersect?` permet de tester si deux sets ont au moins
un élément en commun:

{% highlight irb %}
>> s1 = Set.new [1, 2, 3]
>> s2 = Set.new [4, 5, 6]
>> s3 = Set.new [1, 8, 9]

>> s1.intersect? s2
=> false
>> s1.intersect? s3
=> true
{% endhighlight %}

La seconde méthode, `disjoint?`, est son opposée. Elle teste si deux sets n'ont
aucuns éléments communs:

{% highlight irb %}
>> s1.disjoint? s2
=> true
>> s1.disjoint? s3
=> false
{% endhighlight %}

Ce genre de méthode n'est pas très compliqué à coder soi-même, comme le
montre le code source de `intersect?`:

{% highlight ruby %}
def intersect?(set)
  set.is_a?(Set) or raise ArgumentError, "value must be a set"
  if size < set.size
    any? { |o| set.include?(o) }
  else
    set.any? { |o| include?(o) }
  end
end
{% endhighlight %}

Mais l'avoir en standard permet de ne pas réinventer la roue…
Quant au code source de `disjoint?`, c'est très exactement comme je
le disais plus haut, l'opposé de `intersect?`:

{% highlight ruby %}
def disjoint?(set)
  !intersect?(set)
end
{% endhighlight %}



À demain.


