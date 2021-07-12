---
layout: post
title: "Du nouveau dans Ruby 2.1: Argument nommé et requis"
date: 2013-11-27 18:14
legacy: true
tags: [ruby]
---



Ruby 2.0 a introduit les arguments nommés, appelés *keyword argument*
dans la langue de Shakespeare, soit: «argument mot-clé». Ruby 2.1 ajoute
la notion d'argument nommé **et** requis.

Voilà à quoi ça ressemble, un argument nommé:

<!-- more -->

{% highlight ruby %}
def foo(arg: "hello")
  puts arg
end

foo #=> "hello"
{% endhighlight %}

Avant Ruby 2.1
-----
Mais en Ruby 2.0, vous êtes obligé de donner une valeur par défaut:

    [~]⇒ rvm use 2.0.0
    [~]⇒ irb

{% highlight irb %}
>> def foo(arg:)
>>   puts arg
>> end
SyntaxError: (irb):10: syntax error, unexpected ')'
{% endhighlight %}

Imaginez que ça soit pareil avec les arguments dit
*normaux*. On ne pourrait pas écrire:

    def foo(arg)

On serait obligé d'écrire à la place:

    def foo(arg="hello")

Un peu bizarre, non ?

Avec Ruby 2.1
-----
On peut maintenant définir un argument nommé sans valeur par défaut, et
donc faire en sorte qu'il soit requis:

    [~]⇒ rvm use 2.1.0-preview1
    [~]⇒ irb

{% highlight irb %}
>> def foo(arg:)
>>   puts arg
>> end
=> :foo
>> foo
ArgumentError: missing keyword: arg
>> foo "hello"
ArgumentError: missing keyword: arg
>> foo arg: "hello"
hello
{% endhighlight %}

**Source (pdf)** [toruby](http://www.atdot.net/~ko1/activities/toruby05-ko1.pdf)





À demain.


