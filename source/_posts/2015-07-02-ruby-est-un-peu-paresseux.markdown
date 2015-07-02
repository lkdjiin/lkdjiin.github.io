---
layout: post
title: "Ruby est un peu paresseux"
date: 2015-07-02 17:17
comments: true
categories: [ruby, intermédiaire, optimisation]
---

{% level 2 %}

Voici un mécanisme interne du langage Ruby démontré le temps d'une petite session irb.

D'abord, créons la variable `a`, qui va contenir la chaîne `"one"` :

``` irb
$ irb
>> a = "one"
"one"
```

Créons ensuite la variable `b`, qui va contenir ce que contient la variable `a`,
c'est à dire aussi `"one"` :

``` irb
>> b = a
"one"
```

Question : est ce que les variables `a` et `b` partagent le même emplacement en
mémoire ? 

<!-- more -->

Et bien oui, `b = a` n'a pas copié la *valeur* de `a` dans `b`, mais a assigné
à `b` la même case mémoire que `a` :

``` irb
>> a.object_id == b.object_id
true
>> a.object_id
81895060
>> b.object_id
81895060
```

Mais alors si on change la valeur de la variable `a`, ça va changer aussi celle
de `b` ? Et non :

``` irb
>> a = "two"
"two"
>> a.object_id == b.object_id
false
>> b
"one"
```

L'emplacement mémoire a été modifié. On a maintenant deux variables bien
distinctes :

``` irb
>> a.object_id
81648680
>> b.object_id
81895060
```

Tant qu'il n'y a pas de modification de l'une ou de l'autre des variables, Ruby
agit en quelque sorte comme si il n'y en avait qu'une seule. J'imagine que c'est
pour soulager l'utilisation de la mémoire.

Mais dès que l'une ou l'autre est modifiée, les deux variables deviennent bien
distinctes.

``` irb
>> exit
```

{% connexe %}
