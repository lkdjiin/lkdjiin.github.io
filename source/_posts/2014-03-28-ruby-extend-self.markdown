---
layout: post
title: "Ruby - extend self"
date: 2014-03-28 21:16
comments: true
categories: [ruby, débutant, self, module, utilitaire, orienté objet]
---

{% level 1 %}

Vous débutez en Ruby et vous vous demandez ce que peut bien signifier
ce `extend self` qu'on rencontre parfois dans un module utilitaire ?

<!-- more -->

Voici un exemple:

``` ruby
module M
  extend self

  def foo
    puts 'foo'
  end
end

M.foo
#=> foo
```

La ligne `extend self` nous permet de définir toutes les méthodes du
module comme étant des méthodes de classe. C'est pas plus compliqué que
ça.

On aurait pu écrire à la place:

``` ruby
module M
  def self.foo
    puts 'foo'
  end
end
```

Ou bien encore:

``` ruby
module M
  class << self
    def foo
      puts 'foo'
    end
  end
end
```

Il y a quand même une subtilité qui fait toute la différence !
Sinon ça ne serait pas drôle. En utilisant la syntaxe `extend self`,
**toutes les méthodes sont des méthodes de classe**, ou de module si
vous préférez ;) La différence est importante puisqu'ainsi on ne pourra
pas mélanger méthodes utilitaires et méthodes à inclure dans une classe.
Ce qui est parfois tentant, mais c'est mal. Mais tentant. Mais mal…

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

