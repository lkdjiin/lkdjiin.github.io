---
layout: post
title: "La méthode super en Ruby"
date: 2014-03-24 21:21
comments: true
categories: [ruby, débutant, super, héritage, orienté objet]
---

{% level 1 %}

Aujourd'hui un aperçu de la méthode `super` pour les débutants en Ruby.
C'est une méthode dont le comportement peut surprendre si vous venez
de certains autres langages…

<!-- more -->
Pour étudier le comportement de `super` il va nous falloir utiliser
l'héritage. Voici une classe de base toute simple:

``` ruby
class Base
  def foo(bar)
    puts "#{bar} from Base"
  end
end
```

Et voici comment l'utiliser:

``` ruby
base = Base.new
base.foo("Hello")
#=> Hello from Base
```

Maintenant créons une classe fille qui hérite de `Base` et
*redéfinissons* la méthode `foo`:

``` ruby
class Child < Base
  def foo(bar)
    super
    puts "#{bar} from Child"
  end
end
```

Voici ce que ça donne:

``` ruby
child = Child.new
child.foo("Hello")
#=> Hello from Base
#=> Hello from Child
```

Il faut noter que:

1. La méthode éponyme `foo` de la classe de base n'est pas appelée
   implicitement. Il faut le faire explicitement avec `super`.
2. On est pas limité à un *constructeur*, on peut appeler `super` dans
   une *simple* méthode.
3. Dans ce cas précis, pas besoin de passer l'argument `bar` à la
   méthode `super`, c'est fait **automagiquement**.

Allons plus loin et faisons faire plus de choses à la méthode `foo` de la
classe fille:

``` ruby
class Child < Base
  def foo(bar, baz)
    super
    puts "#{bar} #{baz} from Child"
  end
end
```

Cette fois-ci la magie n'opère plus et nous avons droit à une belle erreur:

``` ruby
child = Child.new
child.foo("Hello", "world")
#=> super.rb:2:in `foo': wrong number of arguments (2 for 1) (ArgumentError)
```

Ruby nous signale que la méthode `foo` de la classe `Base` a reçu 2
arguments, alors qu'elle n'en attendait qu'un seul ! Pourquoi, alors que
nous n'avons même pas passé un seul argument ? Parce que `super`, sans
arguments, prends **tous** les arguments passés à la méthode dans
laquelle il se trouve et les envoient tous vers la méthode éponyme de la
classe de base…

Alors comment on s'en sort ? Très simplement en passant à `super` les
paramètres que l'on veut:

``` ruby
class Child < Base
  def foo(bar, baz)
    super(bar)
    puts "#{bar} #{baz} from Child"
  end
end
```

Et cette fois-ci, ça fonctionne parfaitement:

``` ruby
child = Child.new
child.foo("Hello", "world")
#=> Hello from Base
#=> Hello world from Child
```

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

