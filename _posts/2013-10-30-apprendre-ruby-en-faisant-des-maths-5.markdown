---
layout: post
title: "Apprendre Ruby en faisant des maths 5"
date: 2013-10-30 19:15
legacy: true
tags: [ruby]
---



Jusqu'ici on a écrit une méthode qui calcule les diviseurs d'un nombre et
une seconde méthode qui calcule les diviseurs stricts.
Notre objectif étant de lister les nombres amiables jusqu'à 10 000, il nous
faut maintenant obtenir la *somme* des diviseurs stricts d'un nombre.

<!-- more -->

Il nous faut donc calculer la somme des nombres qui composent une liste.
Allons y, prenons une liste et plaçons la dans une variable nommée `x`:

{% highlight irb %}
>> x = [1,2,4]
=> [1, 2, 4]
{% endhighlight %}

Nous avons déjà vu la méthode `select`, qui sélectionne certains éléments
d'une liste ; nous allons voir maintenant la méthode `reduce`, qui va *réduire*
les éléments d'une liste à *un seul* élément:

{% highlight irb %}
>> x.reduce {|sum, int| sum + int}
=> 7
{% endhighlight %}

Contrairement à la méthode `select` qui ne prenait qu'une seule variable
dans le bloc d'instruction, la méthode `reduce` en prends ici deux:
`sum` et `int`. `sum` joue le rôle d'un accumulateur et contient le résultat
qui sera retourné par la méthode. `int` fait référence à l'élément de la
liste en cours de traitement, exactement comme avec `select`. Pour chaque
élément de la liste `x`, l'instruction `sum + int` est exécutée.

On peut se demander quelle est la valeur initiale de `sum` ? Tout simplement
le premier élément de la liste. Et nous ne sommes pas limité aux nombres,
`reduce` fonctionnera avec ce qu'on veut, par exemple des chaînes de
caractères:

{% highlight irb %}
>> ["f", "o", "o"].reduce {|string, letter| string + letter}
=> "foo"
{% endhighlight %}

Ruby permet aussi de simplifier l'écriture dans un cas trivial comme le
notre:

{% highlight irb %}
>> x.reduce(:+)
=> 7
{% endhighlight %}

En fait, `reduce` ne prend pas obligatoirement un bloc. Ci-dessus,
`reduce` prend
en argument un symbole: `:+`. `+` est le nom d'une méthode. Oui, `+` est
bien une méthode:

{% highlight irb %}
>> 1.+(2)
=> 3
{% endhighlight %}

Je ne vais pas parler plus des symboles aujourd'hui, sachez seulement
que les deux écritures suivantes font la même chose mais que la seconde
est plus dans l'esprit de Ruby:

{% highlight ruby %}
x.reduce {|sum, int| sum + int}
x.reduce(:+)
{% endhighlight %}

Voilà, on est prêt à implémenter la méthode `sum_of_proper_divisors`, ce
qui signifie en français «somme des diviseurs stricts»:

{% highlight ruby %}
def sum_of_proper_divisors(n)
  proper_divisors(n).reduce(:+)
end
{% endhighlight %}

Comme la dernière fois, on se sert d'une méthode plus générale
(`proper_divisors`) pour écrire une méthode plus spécifique.

{% highlight irb %}
>> def divisors(n)
>>   (1..n).select {|i| n % i == 0 }
>> end
>>
>> def proper_divisors(n)
>>   divisors(n)[0..-2]
>> end
>>
>> def sum_of_proper_divisors(n)
>>   proper_divisors(n).reduce(:+)
>> end
>>
>> divisors 8
=> [1, 2, 4, 8]
>> proper_divisors 8
=> [1, 2, 4]
>> sum_of_proper_divisors 8
=> 7
{% endhighlight %}





À demain.



