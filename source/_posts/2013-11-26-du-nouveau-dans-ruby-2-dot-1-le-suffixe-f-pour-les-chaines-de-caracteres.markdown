---
layout: post
title: "Du nouveau dans Ruby 2.1: Le suffixe f pour les chaînes de caractères"
date: 2013-11-26 20:33
comments: true
categories: [ruby, string, débutant, ruby 2.1]
---

{% level 1 %}

Aujourd'hui c'est au tour du nouveau suffixe `f` (comme frozen) d'être passé
en revue.

<!-- more -->

Avant Ruby 2.1
-----
Les chaînes de caractères en Ruby sont des objets *mutables*. Ce qui
signifie qu'à chaque fois que l'interpréteur rencontre `"foo"`, il crée
un nouvel objet:

    [~]⇒ rvm use 2.0.0
    [~]⇒ irb
    >> "foo".object_id
    74667700
    >> "foo".object_id
    74664050

Ce qui peut influer sur les performances d'un programme quand on compare
beaucoup de chaînes. Voici un exemple trivial:

``` ruby
def foo?(string)
  foo = "foo"
  p foo.object_id
  string == foo
end
```

Encore une fois, on peut constater qu'un nouvel objet est créé à chaque
appel de la méthode:

``` irb
>> foo? "bépo"
76675080
false
>> foo? "bar"
76669680
false
```

Et géler (*freeze*) l'objet n'empêchera pas sa création à chaque appel:

``` irb
>> def foo
>>   foo = "foo".freeze
>>   foo.object_id
>> end
nil
>> foo
82081130
>> foo
82079520
```


Avec Ruby 2.1
------

    [~]⇒ rvm use 2.1.0-preview1
    [~]⇒ irb

Le suffixe `f` permet de géler (*freeze*) les chaînes de
caractères:

``` irb
>> a = "foo"f
=> "foo"
>> a.reverse!
RuntimeError: can't modify frozen String
```

Et surtout, le suffixe `f` les gèlent une fois pour toutes.
L'exemple précédent donne ceci:

``` irb
>> def foo?(string)
>>   foo = "foo"f
>>   p foo.object_id
>>   string == foo
>> end
=> :foo?
>> foo? "bépo"
79029020
=> false
>> foo? "bar"
79029020
=> false
```

**Source (pdf)** [toruby](http://www.atdot.net/~ko1/activities/toruby05-ko1.pdf)

**Edit du 1er décembre 2013** Cette fonctionnalité a été supprimé dans
la version [2.1.0-preview2](https://www.ruby-lang.org/en/news/2013/11/22/ruby-2-1-0-preview2-is-released/).

À demain.

{% connexe %}

