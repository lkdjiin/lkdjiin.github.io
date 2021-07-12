---
layout: post
title: "Ruby - extend self"
date: 2014-03-28 21:16
legacy: true
tags: [ruby, débutant, self, module, utilitaire, orienté objet]
---



Vous débutez en Ruby et vous vous demandez ce que peut bien signifier
ce `extend self` qu'on rencontre parfois dans un module utilitaire ?

<!-- more -->

Voici un exemple:

{% highlight ruby %}
module M
  extend self

  def foo
    puts 'foo'
  end
end

M.foo
#=> foo
{% endhighlight %}

La ligne `extend self` nous permet de définir toutes les méthodes du
module comme étant des méthodes de classe. C'est pas plus compliqué que
ça.

On aurait pu écrire à la place:

{% highlight ruby %}
module M
  def self.foo
    puts 'foo'
  end
end
{% endhighlight %}

Ou bien encore:

{% highlight ruby %}
module M
  class << self
    def foo
      puts 'foo'
    end
  end
end
{% endhighlight %}

Il y a quand même une subtilité qui fait toute la différence !
Sinon ça ne serait pas drôle. En utilisant la syntaxe `extend self`,
**toutes les méthodes sont des méthodes de classe**, ou de module si
vous préférez ;) La différence est importante puisqu'ainsi on ne pourra
pas mélanger méthodes utilitaires et méthodes à inclure dans une classe.
Ce qui est parfois tentant, mais c'est mal. Mais tentant. Mais mal…



À demain.



