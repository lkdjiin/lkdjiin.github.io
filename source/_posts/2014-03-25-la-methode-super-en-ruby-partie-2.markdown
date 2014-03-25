---
layout: post
title: "La méthode super en Ruby - partie 2"
date: 2014-03-25 19:53
comments: true
categories: [ruby, débutant, super, héritage, orienté objet]
---

{% level 1 %}

Comme me le faisait remarquer ce matin un lecteur, il manque un cas à
mon article d'hier sur l'utilisation de `super` en Ruby. C'est d'autant
plus impardonnable que c'est un cas où, pour une fois, les parenthèses
sont **obligatoires** à la fin d'une méthode.

<!-- more -->

Voici donc une classe de base et une classe fille:

``` ruby
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
```

Et maintenant on essaye le tout:

``` ruby
child = Child.new
child.foo
#=> ArgumentError: wrong number of arguments (0 for 1)
```

Boum ! Comme on l'a vu hier, `super` passe automatiquement tous les
paramètres de la méthode dans laquelle il est appelé vers la classe
de base. Et là, notre méthode `foo` dans la classe de base est sans
argument.

Pour résoudre ce problème, on est obligé de mettre des parenthèses
à la suite de `super`:

``` ruby
class Child < Base
  def foo(bar)
    super()
    puts "Child#foo with #{bar}"
  end
end
```

``` ruby
child = Child.new
child.foo('ok')
Base#foo
Child#foo with ok
```

Voilà, oubli réparé.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

