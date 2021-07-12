---
layout: post
title: "Ruby 2.0: Les arguments nommés"
date: 2013-10-14 19:04
legacy: true
tags: [ruby]
---



Les arguments nommés étaient absents de Ruby jusqu'à sa version 2.0, curieux
pour un langage qui fait tellement penser à Smalltalk.

<!-- more -->

Il était bien sûr possible de les *simuler* en utilisant un hash, un peu
comme ce qu'on fait en Javascript:

{% highlight ruby %}
def person(opts = {})
  defaults = {name: "toto", age: 99}
  opts = defaults.merge opts
  puts opts[:name]
  puts opts[:age]
end
{% endhighlight %}

Mais bof. Ça ressemble à tout sauf à du Ruby. C'est un *hack*, un truc, une
astuce, tout ce qu'on veut mais ça ne s'intègre pas au langage.
Voici la même méthode, avec cette fois-ci des arguments nommés:

{% highlight ruby %}
def person(name: "toto", age: 99)
  puts name
  puts age
end
{% endhighlight %}

Et voici comment différentes manières d'appeler cette méthode:

{% highlight ruby %}
person
person name: "oscar"
person age: 18
person name: "oscar", age: 18
person age: 18, name: "oscar"
{% endhighlight %}

Cool, ça fonctionne dans tous les sens. Par contre, pas question d'oublier
le nom de l'argument:

{% highlight irb %}
person "oscar", 18
ArgumentError: wrong number of arguments (2 for 0)
{% endhighlight %}

On peut aussi mélanger arguments normaux et nommés, à condition que les
arguments nommés viennent après. Le code suivant est valide:

{% highlight ruby %}
def person(name, age: 99)
  puts name
  puts age
end

person "oscar"
{% endhighlight %}

Mais pas celui-ci:

{% highlight irb %}
>> def person(age: 99, name)
>> end
SyntaxError: (irb):1: syntax error, unexpected tIDENTIFIER
def person(age: 99, name)
                        ^
{% endhighlight %}





À demain.



