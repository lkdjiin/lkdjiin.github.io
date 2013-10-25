---
layout: post
title: "Apprendre Ruby en faisant des maths 3"
date: 2013-10-25 10:02
comments: true
categories: [ruby, débutant, tutoriel]
---

{% level 1 %}

La [dernière fois](http://lkdjiin.github.io/blog/2013/10/23/apprendre-ruby-en-faisant-des-maths-2/), on a vu comment calculer la liste des diviseurs
d'un nombre avec `(1..8).select {|int| 8 % int == 0 }`. On va aujourd'hui
faire en sorte que ça fonctionne avec n'importe quel nombre, en écrivant
notre propre méthode.

<!-- more -->

Résumons : pour trouver les diviseurs de 8, j'écris:

``` ruby
(1..8).select {|int| 8 % int == 0 }
```

et pour trouver les diviseurs de 4, j'écris:

``` ruby
(1..4).select {|int| 4 % int == 0 }
```

Ce que je veux, c'est une façon de faire plus *générale*: je veux trouver
les diviseurs pour tout entier *n*. Essayons donc de remplacer le
nombre recherché par n:

``` irb
>> (1..n).select {|int| n % int == 0 }
NoMethodError: undefined method `n' on an instance of Object.
```

Ruby n'est pas content et nous signale qu'il ne connait pas n. Ok, essayons
alors de définir n d'abord:

``` irb
>> n = 8
=> 8
>> (1..n).select {|int| n % int == 0 }
=> [1, 2, 4, 8]
```

Cette fois c'est bon. Maintenant vous êtes prêt à définir une méthode:

``` ruby
def divisors(n)
  (1..n).select {|int| n % int == 0 }
end
```

**Pour information, divisors est le mot anglais pour diviseurs.**

Une définition de méthode commence par le mot-clé `def` et se termine par
le mot-clé `end`. La méthode ci-dessus s'appelle `divisors` et elle prend
un argument qui est nommé `n`.

On lance/appelle/exécute une méthode simplement par son nom, sans oublier
son (ses) argument(s). Par exemple `divisors 8` va calculer et renvoyer la
liste des diviseurs de 8. Voici un exemple d'utilisation lors d'une session
irb:

``` irb
>> def divisors(n)
>>   (1..n).select {|int| n % int == 0 }
>> end
>> divisors 8
=> [1, 2, 4, 8]
>> divisors 4
=> [1, 2, 4]
>> divisors 417
=> [1, 3, 139, 417]
```

La prochaine fois nous verrons comment se servir de la méthode `divisors`
comme d'une base pour construire une autre méthode.

À demain.

{% connexe %}

