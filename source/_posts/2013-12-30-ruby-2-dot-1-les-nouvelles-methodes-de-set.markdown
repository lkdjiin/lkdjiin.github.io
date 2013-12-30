---
layout: post
title: "Ruby 2.1: Les nouvelles méthodes de Set"
date: 2013-12-30 19:10
comments: true
categories: [ruby, set, débutant, ruby 2.1]
---

{% level 1 %}

Avec la sortie de Ruby 2.1, la bibliothèque standard `Set` s'enrichie de 
deux méthodes supplémentaires: `disjoint?` et `intersect?`.

<!-- more -->

`Set` permet de créer un ensemble d'éléments uniques:

``` irb
>> require 'set'
>> Set.new [1, 2, 1, 2, 2]
=> #<Set: {1, 2}>
```

La nouvelle méthode `intersect?` permet de tester si deux sets ont au moins
un élément en commun:

``` irb
>> s1 = Set.new [1, 2, 3]
>> s2 = Set.new [4, 5, 6]
>> s3 = Set.new [1, 8, 9]

>> s1.intersect? s2
=> false
>> s1.intersect? s3
=> true
```

La seconde méthode, `disjoint?`, est son opposée. Elle teste si deux sets n'ont
aucuns éléments communs:

``` irb
>> s1.disjoint? s2
=> true
>> s1.disjoint? s3
=> false
```

Ce genre de méthode n'est pas très compliqué à coder soi-même, comme le
montre le code source de `intersect?`:

``` ruby
def intersect?(set)
  set.is_a?(Set) or raise ArgumentError, "value must be a set"
  if size < set.size
    any? { |o| set.include?(o) }
  else
    set.any? { |o| include?(o) }
  end
end
```

Mais l'avoir en standard permet de ne pas réinventer la roue…
Quant au code source de `disjoint?`, c'est très exactement comme je
le disais plus haut, l'opposé de `intersect?`:

``` ruby
def disjoint?(set)
  !intersect?(set)
end
```

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
