---
layout: post
title: "Ruby: Les méthodes du module Kernel 2"
date: 2013-09-28 13:59
legacy: true
tags: [ruby]
---



On continue l'exploration du module Kernel avec quatre
autres méthodes de conversions, pour les nombres:

* Complex
* Float
* Integer
* Rational

<!-- more -->

Voyons d'abord `Integer`. On peut lui passer une chaîne de caractère:

{% highlight irb %}
>> Integer("123")
123
{% endhighlight %}

Ça fonctionne avec les préfixes. En octal, hexadécimal et binaire:

{% highlight irb %}
>> Integer("0123")
83
>> Integer("0x123")
291
>> Integer("0b111")
7
{% endhighlight %}

On peut aussi spécifier la base:

{% highlight irb %}
>> Integer("0123", 10)
123
{% endhighlight %}

On peut aussi passer en argument un objet répondant à `to_int` ou `to_i`:

{% highlight irb %}
>> class Foo
>>   def to_i
>>     123
>>   end
>> end
nil
>> Integer(Foo.new)
123
{% endhighlight %}

Passons maintenant à `Float(arg)` qui convertit un argument en type `Float`.
Soit l'argument est de type `Numeric`:

{% highlight irb %}
>> Float(123)
123.0
>> Float(Rational("1/2"))
0.5
{% endhighlight %}

Soit la méthode fait appel à `to_f`:

{% highlight irb %}
>> class Foo
>>   def to_f
>>     1.23
>>   end
>> end
nil
>> Float(Foo.new)
1.23
{% endhighlight %}

Au tour de la méthode `Rational` qui convertit son (ses) argument(s) en un
nombre rationnel (de classe `Rational`), autrement dit une fraction:

{% highlight irb %}
>> Rational("1/3")
1/3
>> Rational(1, 3)
1/3
>> x = Rational("1/3")
1/3
>> x + x
2/3
{% endhighlight %}

Reste la méthode `Complex`, qui convertit son (ses) argument(s) en un nombre
complexe. Je la signale pour être exhaustif, mais les nombres complexes
dépassent largement mes compétences en mathématique.





À demain.



