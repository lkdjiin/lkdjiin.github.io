---
layout: post
title: "Du nouveau dans Ruby 2.1: Argument nommé et requis"
date: 2013-11-27 18:14
comments: true
categories: [ruby, argument, débutant, ruby 2.1]
---

{% level 1 %}

Ruby 2.0 a introduit les arguments nommés, appelés *keyword argument*
dans la langue de Shakespeare, soit: «argument mot-clé». Ruby 2.1 ajoute
la notion d'argument nommé **et** requis.

Voilà à quoi ça ressemble, un argument nommé:

<!-- more -->

``` ruby
def foo(arg: "hello")
  puts arg
end

foo #=> "hello"
```

Avant Ruby 2.1
-----
Mais en Ruby 2.0, vous êtes obligé de donner une valeur par défaut:

    [~]⇒ rvm use 2.0.0
    [~]⇒ irb

``` irb
>> def foo(arg:)
>>   puts arg
>> end
SyntaxError: (irb):10: syntax error, unexpected ')'
```

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

``` irb
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
```

**Source (pdf)** [toruby](http://www.atdot.net/~ko1/activities/toruby05-ko1.pdf)



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
