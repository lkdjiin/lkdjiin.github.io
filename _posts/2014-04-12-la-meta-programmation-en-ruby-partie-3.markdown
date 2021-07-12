---
layout: post
title: "La méta programmation en Ruby - partie 3"
date: 2014-04-12 19:30
legacy: true
tags: [ruby, intermédiaire, meta, programmation]
---



Aujourd'hui une explication de `method_missing`, utilisée hier pour
écrire le constructeur de requête.

<!-- more -->

Tout d'abord un peu de pratique:

{% highlight ruby %}
class Foo
  def method_missing(met)
    puts 'Inside method_missing ---'
    puts met
  end
end

Foo.new.foo
Foo.new.foobarbaz
{% endhighlight %}

    $ ruby meta3.rb 
    Inside method_missing ---
    foo
    Inside method_missing ---
    foobarbaz

Et maintenant la théorie. Lorsque vous passez un message a un objet, comme
`Foo.new.foo` et que ce message (cette méthode) n'existe pas, Ruby regarde
si l'objet possède la méthode `method_missing` et dans ce cas, l'appelle.
L'argument passé à `method_missing` est le nom de la *méthode manquante*.

Maintenant on ajoute un argument à `method_missing`, c'est l'argument de
la *méthode manquante*:

{% highlight ruby %}
class Foo
  def method_missing(met, arg)
    puts 'Inside method_missing ---'
    puts met
    puts arg
  end
end

Foo.new.foo('bar')
{% endhighlight %}

    $ ruby meta3.rb 
    Inside method_missing ---
    foo
    bar

Alors que ce passe-t-il si on passe plusieurs arguments ? Essayons:

{% highlight ruby %}
Foo.new.foo('bar', 'baz')
{% endhighlight %}

    meta3.rb:13:in `method_missing': wrong number of arguments (3 for 2) 

Et oui, ça ne fonctionne pas. Comme on ne peut pas connaître à l'avance
le nombre d'arguments de la *méthode manquante*, il est bon de tous les
récupérer dans un tableau:

{% highlight ruby %}
class Foo
  def method_missing(met, *arg)
    puts 'Inside method_missing ---'
    puts met
    puts arg.inspect
  end
end

Foo.new.foo
Foo.new.foo('bar')
Foo.new.foo('bar', 'baz')
{% endhighlight %}

Et dans ce cas là, il n'y a plus de problèmes, on peut gérer n'importe
quel nombre d'arguments:

    $ ruby meta3.rb 
    Inside method_missing ---
    foo
    []
    Inside method_missing ---
    foo
    ["bar"]
    Inside method_missing ---
    foo
    ["bar", "baz"]

Pour finir, il faut noter qu'on peut comme toujours passer un bloc:

{% highlight ruby %}
class Foo
  def method_missing(met, *arg, &block)
    puts 'Inside method_missing ---'
    puts met
    puts arg.inspect
    puts block.call if block_given?
  end
end

Foo.new.foo('bar') do
  'return from a block'
end
{% endhighlight %}

    $ ruby meta3.rb 
    Inside method_missing ---
    foo
    ["bar"]
    return from a block




À demain.



