---
layout: post
title: "Apprendre Ruby en faisant des maths 2"
date: 2013-10-23 09:54
legacy: true
tags: [ruby]
---



On a vu, [précédemment](http://lkdjiin.github.io/blog/2013/10/21/apprendre-ruby-en-faisant-des-maths/),
comment savoir si un nombre d est un diviseur de n avec `8 % 2` et
comment obtenir une liste de nombre avec `1..8`. Maintenant on peut
apprendre à sélectionner les nombres qui nous intéressent dans cette liste.

<!-- more -->

Pour cela, nous allons utiliser la méthode `select`:

{% highlight irb %}
>> (1..8).select {|int| 8 % int == 0 }
=> [1, 2, 4, 8]
{% endhighlight %}

Et voilà, nous avons nos diviseurs de 8. La méthode `select` utilise un
bloc d'instructions (ce qui se trouve entre les `{}`). Cette (ou ces)
instruction va être exécutée sur chaque éléments de `1..8`, c'est à dire
sur 1, 2, 3, 4, 5 ,6, 7 puis enfin 8. Ici, l'instruction exécutée sur les
éléments est `8 % int == 0`. En clair on teste si le reste de la division
de 8 par `int` égal zéro. Qu'est-ce que c'est que ce `int` ? Et bien c'est
l'élément en cours de traitement, c'est à dire 1, puis 2, et ensuite 3, etc
jusqu'à 8. `int` est simplement un nom qu'on a donné pour pouvoir se
référer à l'élément en cours, ce nom est indiqué entre deux caractères `|`,
comme dans `|int|`. On peut lui donner le nom qu'on veut, par exemple:

{% highlight irb %}
>> (1..8).select {|xavier| 8 % xavier == 0 }
=> [1, 2, 4, 8]
{% endhighlight %}

Pour information, *int* est le diminutif de integer, qui signifie
nombre entier en anglais.

Comment Ruby sait qu'il doit sélectionner 2 et pas 3 ? Regardons cela de
plus près:

{% highlight irb %}
>> 8 % 2 == 0
=> true
>> 8 % 3 == 0
=> false
{% endhighlight %}

Le résultat d'un test, ici l'égalité avec `==` est soit vrai (true), soit
faux (false). Lorsque l'instruction dans le bloc (`{}`) renvoie true, l'élément
est sélectionné, lorsqu'elle renvoie false, l'élément est éliminé.

Vous devriez vérifier maintenant que ça fonctionne bien avec n'importe
quel nombre entier positif:

{% highlight irb %}
>> (1..1).select {|int| 1 % int == 0 }
=> [1]
>> (1..41).select {|int| 41 % int == 0 }
=> [1, 41]
>> (1..417).select {|int| 417 % int == 0 }
=> [1, 3, 139, 417]
>> (1..4179).select {|int| 4179 % int == 0 }
=> [1, 3, 7, 21, 199, 597, 1393, 4179]
{% endhighlight %}

La prochaine fois, on verra comment créer nos propres méthodes.





À demain.



