---
layout: post
title: "Ruby est un peu paresseux"
date: 2015-07-02 17:17
legacy: true
tags: [ruby, intermédiaire, optimisation]
---



Voici un mécanisme interne du langage Ruby démontré le temps d'une petite session irb.

D'abord, créons la variable `a`, qui va contenir la chaîne `"one"` :

{% highlight irb %}
$ irb
>> a = "one"
"one"
{% endhighlight %}

Créons ensuite la variable `b`, qui va contenir ce que contient la variable `a`,
c'est à dire aussi `"one"` :

{% highlight irb %}
>> b = a
"one"
{% endhighlight %}

Question : est ce que les variables `a` et `b` partagent le même emplacement en
mémoire ? 

<!-- more -->

Et bien oui, `b = a` n'a pas copié la *valeur* de `a` dans `b`, mais a assigné
à `b` la même case mémoire que `a` :

{% highlight irb %}
>> a.object_id == b.object_id
true
>> a.object_id
81895060
>> b.object_id
81895060
{% endhighlight %}

Mais alors si on change la valeur de la variable `a`, ça va changer aussi celle
de `b` ? Et non :

{% highlight irb %}
>> a = "two"
"two"
>> a.object_id == b.object_id
false
>> b
"one"
{% endhighlight %}

L'emplacement mémoire a été modifié. On a maintenant deux variables bien
distinctes :

{% highlight irb %}
>> a.object_id
81648680
>> b.object_id
81895060
{% endhighlight %}

Tant qu'il n'y a pas de modification de l'une ou de l'autre des variables, Ruby
agit en quelque sorte comme si il n'y en avait qu'une seule. J'imagine que c'est
pour soulager l'utilisation de la mémoire.

Mais dès que l'une ou l'autre est modifiée, les deux variables deviennent bien
distinctes.

{% highlight irb %}
>> exit
{% endhighlight %}


