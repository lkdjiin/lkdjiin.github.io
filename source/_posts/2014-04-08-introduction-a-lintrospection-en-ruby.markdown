---
layout: post
title: "Introduction à l'introspection en Ruby"
date: 2014-04-08 21:23
comments: true
categories: [ruby, débutant, introspection]
---

{% level 1 %}

L'introspection consiste à obtenir des informations sur un objet au
moment de l'exécution d'un programme. Voyons à quoi ça ressemble.

<!-- more -->

Créons une classe `Inspector` qui va extraire certaines informations
des objets qu'on lui donnera:

``` ruby introspection.rb
class Inspector
  class << self
    def classname(o)
      o.class.name
    end

    def methods(c)
      c.instance_methods(false)
    end

    def parameters(o, m)
      o.method(m).parameters
    end
  end
end
```

Dans cet exemple nous allons récupérer le nom de la classe, le nom des
méthodes et certaines informations sur les arguments des méthodes.

Voyons comment ça marche en récupérant le nom de la classe `Object`:

``` irb
>> load './introspection.rb'
>> p Inspector.classname(Object.new)
"Object"
```

Maintenant ajoutons une classe `C` avec quelques méthodes:

``` ruby introspection.rb
class Inspector
  class << self
    def classname(o)
      o.class.name
    end

    def methods(c)
      c.instance_methods(false)
    end

    def parameters(o, m)
      o.method(m).parameters
    end
  end
end

class C
  def foo
  end

  def bar(arg1, arg2)
  end

  def baz(arg1, *args, &block)
  end
end
```

Les méthodes de la classe `C` ne font rien. C'est normal, ce qui nous
intéresse ici c'est leur signature. D'abord le nom de la classe:

``` irb
>> load './introspection.rb'
>> p Inspector.classname(C.new)
"C"
```

Facile. Maintenant récupérons les méthodes:

``` irb
>> p Inspector.methods(C)
[:foo, :bar, :baz]
```

Pas mal. Encore plus fort, inspectons les arguments de chacune des
méthodes:

``` irb
>> Inspector.methods(C).each do |m|
?>   p Inspector.parameters(C.new, m)
>> end
[]
[[:req, :arg1], [:req, :arg2]]
[[:req, :arg1], [:rest, :args], [:block, :block]]
```

Voilà, c'était une rapide mise en bouche du *comment faire ?*.
Pour le *à quoi ça sert ?*, il faudra attendre un prochain article ;)

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
