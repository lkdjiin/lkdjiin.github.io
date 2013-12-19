---
layout: post
title: "Ruby: Les méthodes du module Kernel 2"
date: 2013-09-28 13:59
comments: true
categories: [ruby, débutant, kernel]
---

{% level 1 %}

On continue l'exploration du module Kernel avec quatre
autres méthodes de conversions, pour les nombres:

* Complex
* Float
* Integer
* Rational

<!-- more -->

Voyons d'abord `Integer`. On peut lui passer une chaîne de caractère:

``` irb
>> Integer("123")
123
```

Ça fonctionne avec les préfixes. En octal, hexadécimal et binaire:

``` irb
>> Integer("0123")
83
>> Integer("0x123")
291
>> Integer("0b111")
7
```

On peut aussi spécifier la base:

``` irb
>> Integer("0123", 10)
123
```

On peut aussi passer en argument un objet répondant à `to_int` ou `to_i`:

``` irb
>> class Foo
>>   def to_i
>>     123
>>   end
>> end
nil
>> Integer(Foo.new)
123
```

Passons maintenant à `Float(arg)` qui convertit un argument en type `Float`.
Soit l'argument est de type `Numeric`:

``` irb
>> Float(123)
123.0
>> Float(Rational("1/2"))
0.5
```

Soit la méthode fait appel à `to_f`:

``` irb
>> class Foo
>>   def to_f
>>     1.23
>>   end
>> end
nil
>> Float(Foo.new)
1.23
```

Au tour de la méthode `Rational` qui convertit son (ses) argument(s) en un
nombre rationnel (de classe `Rational`), autrement dit une fraction:

``` irb
>> Rational("1/3")
1/3
>> Rational(1, 3)
1/3
>> x = Rational("1/3")
1/3
>> x + x
2/3
```

Reste la méthode `Complex`, qui convertit son (ses) argument(s) en un nombre
complexe. Je la signale pour être exhaustif, mais les nombres complexes
dépassent largement mes compétences en mathématique.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

