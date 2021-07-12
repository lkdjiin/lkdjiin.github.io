---
layout: post
title: "Ruby 2.2 - Une sélection des nouvelles méthodes"
date: 2014-12-27 15:40
legacy: true
tags: [ruby, débutant, ruby 2.2]
---



Ça y est, noël est passé et Ruby 2.2.0 est arrivé.
Je vous ai préparé une sélection (personnelle) des nouveautés de cette dernière
version de Ruby.

Vous pouvez voir la liste exhaustive des changements ici:
[ruby v2.2.0 NEWS](https://github.com/ruby/ruby/blob/v2_2_0/NEWS)

<!-- more -->

Les symboles pour les clés d'un Hash peuvent être entre guillemets
------------------------------------------------------------------

Ce qui autorise l'utilisation des espaces.

{% highlight irb %}
>> hash = { "foo bar": "baz" }
=> {:"foo bar"=>"baz"}

>> hash[:"foo bar"]
=> "baz"
{% endhighlight %}

Enumerable#slice_when
---------------------

J'ai le tableau suivant:

{% highlight irb %}
>> a = [1, 2, 4, 9, 10, 11, 12, 15, 16, 19, 20, 21]
{% endhighlight %}

Je veux rassembler ensemble les séries de nombre qui se suivent. Autrement dit,
je veux obtenir ceci:

    [ [1, 2], [4], [9, 10, 11, 12], [15, 16], [19, 20, 21] ]

`slice_when` me fait ça facilement:

{% highlight irb %}
>> a.slice_when {|i, j| i+1 != j }.to_a
=> [[1, 2], [4], [9, 10, 11, 12], [15, 16], [19, 20, 21]]
{% endhighlight %}

max et min peuvent retourner plusieurs valeurs
----------------------------------------------

Plutôt que d'obtenir la seule et unique valeur limite, on peut maintenant
obtenir une liste.

{% highlight irb %}
>> [1, 2, 3].max
=> 3

>> [1, 2, 3].max(2)
=> [3, 2]

>> [1, 2, 3, 3].max(2)
=> [3, 3]
{% endhighlight %}

Method#curry
------------

Tout d'abord, voici une méthode `add`, qui prend 3 arguments:

{% highlight ruby %}
def add(a, b, c)
  a + b + c
end
{% endhighlight %}

On *currifie* cette méthode:

{% highlight irb %}
>> proc = self.method(:add).curry
=> #<Proc:0x8f945a4 (lambda)>
{% endhighlight %}

Je peux maintenant l'appliquer partiellement:

{% highlight irb %}
>> proc = proc.call(1, 2)
=> #<Proc:0x9407dfc (lambda)>

>> proc.call(3)
=> 6

>> proc.call(10)
=> 13
{% endhighlight %}

La lib Etc
----------

Pour finir, voici deux nouvelles méthodes de la bibliothèque standard `Etc`.

{% highlight irb %}
>> require 'etc'

>> Etc.uname
=> {:sysname=>"Linux", ... }

>> Etc.nprocessors
=> 2
{% endhighlight %}




