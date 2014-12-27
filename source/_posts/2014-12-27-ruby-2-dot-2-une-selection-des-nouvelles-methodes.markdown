---
layout: post
title: "Ruby 2.2 - Une sélection des nouvelles méthodes"
date: 2014-12-27 15:40
comments: true
categories: [ruby, débutant, ruby 2.2]
---

{% level 1 %}

Ça y est, noël est passé et Ruby 2.2.0 est arrivé.
Je vous ai préparé une sélection (personnelle) des nouveautés de cette dernière
version de Ruby.

Vous pouvez voir la liste exhaustive des changements ici:
[ruby v2.2.0 NEWS](https://github.com/ruby/ruby/blob/v2_2_0/NEWS)

<!-- more -->

Les symboles pour les clés d'un Hash peuvent être entre guillemets
------------------------------------------------------------------

Ce qui autorise l'utilisation des espaces.

``` irb
>> hash = { "foo bar": "baz" }
=> {:"foo bar"=>"baz"}

>> hash[:"foo bar"]
=> "baz"
```

Enumerable#slice_when
---------------------

J'ai le tableau suivant:

``` irb
>> a = [1, 2, 4, 9, 10, 11, 12, 15, 16, 19, 20, 21]
```

Je veux rassembler ensemble les séries de nombre qui se suivent. Autrement dit,
je veux obtenir ceci:

    [ [1, 2], [4], [9, 10, 11, 12], [15, 16], [19, 20, 21] ]

`slice_when` me fait ça facilement:

``` irb
>> a.slice_when {|i, j| i+1 != j }.to_a
=> [[1, 2], [4], [9, 10, 11, 12], [15, 16], [19, 20, 21]]
```

max et min peuvent retourner plusieurs valeurs
----------------------------------------------

Plutôt que d'obtenir la seule et unique valeur limite, on peut maintenant
obtenir une liste.

``` irb
>> [1, 2, 3].max
=> 3

>> [1, 2, 3].max(2)
=> [3, 2]

>> [1, 2, 3, 3].max(2)
=> [3, 3]
```

Method#curry
------------

Tout d'abord, voici une méthode `add`, qui prend 3 arguments:

``` ruby
def add(a, b, c)
  a + b + c
end
```

On *currifie* cette méthode:

``` irb
>> proc = self.method(:add).curry
=> #<Proc:0x8f945a4 (lambda)>
```

Je peux maintenant l'appliquer partiellement:

``` irb
>> proc = proc.call(1, 2)
=> #<Proc:0x9407dfc (lambda)>

>> proc.call(3)
=> 6

>> proc.call(10)
=> 13
```

La lib Etc
----------

Pour finir, voici deux nouvelles méthodes de la bibliothèque standard `Etc`.

``` irb
>> require 'etc'

>> Etc.uname
=> {:sysname=>"Linux", ... }

>> Etc.nprocessors
=> 2
```

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

{% connexe %}
