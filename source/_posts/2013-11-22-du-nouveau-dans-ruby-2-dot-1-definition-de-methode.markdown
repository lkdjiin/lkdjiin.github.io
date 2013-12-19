---
layout: post
title: "Du nouveau dans Ruby 2.1: Définition de méthode"
date: 2013-11-22 17:40
comments: true
categories: [ruby, méthode, intermédiaire, ruby 2.1, private]
---

{% level 2 %}

Ruby 2.1 devrait être là dans pas longtemps, il est temps de regarder
ce que cette nouvelle version nous offre. Aujourd'hui on va voir un petit
changement dans la définition des méthodes.

<!-- more -->

Ce qui change avec def
----------------------
Jusqu'ici, `def` renvoyait `nil`:

    [~]⇒ rvm use 2.0.0
    [~]⇒ irb
    >> def foo;end
    nil

Dans Ruby 2.1, `def` va renvoyer le nom de la méthode (en tant que symbole):

    [~]⇒ rvm use 2.1.0-preview1
    [~]⇒ irb
    >> def foo;end
    => :foo

Un cas d'utilisation
--------------------
Pour l'instant je ne connais qu'un seul cas d'utilisation:

``` ruby
private def foo ; end
```

On peut utiliser Ruby pendant très longtemps avant de se rendre compte que
`private` est une méthode et non un mot-clé. Avant Ruby 2.1, l'utilisation
typique de `private` est celle-ci:

``` ruby
class Foo
  def foo ; end

  private

  def bar ; end
end
```

Autrement dit: les méthodes publiques avant `private` et les méthodes privées
après. Une autre possibilité intéressante est la suivante:

``` ruby
class Foo
  def foo ; end

  def foo_helper ; end
  private :bar
end
```

Moins utilisée mais pourtant cool, cette façon de faire permet de garder,
par exemple, une méthode helper sous la méthode appellante.

Avec Ruby 2.1 nous aurons donc la possibilité d'écrire ceci:

``` ruby
class Foo
  def foo ; end

  private foo_helper ; end
end
```

Voilà. Si vous connaissez un autre cas d'utilisation, laissez donc un
commentaire.

**Source (pdf)** [toruby](http://www.atdot.net/~ko1/activities/toruby05-ko1.pdf)



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

