---
layout: post
title: "Apprendre Ruby en faisant des maths"
date: 2013-10-21 21:09
comments: true
categories: [ruby, débutant, tutoriel]
---

{% level 1 %}

J'ai eu récemment à aider quelqu'un en mathématique (niveau 3ème), et ce
quelqu'un connaissait un peu Ruby. On a joué avec le langage pour faire
des maths. C'était drôle et intéressant. Ça m'a donné l'idée de
continuer cette affaire sur mon blog. Cette nouvelle série d'articles
s'adresse à celles et ceux qui débutent Ruby et qui ont un niveau de math de
3ème.

<!-- more -->

Le premier problème auquel on va essayer de répondre en utilisant Ruby est
le suivant:

{% blockquote %}
Afficher toutes les paires de nombres amiables jusqu'à 10.000.
{% endblockquote %}

Si vous avez besoin de vous rafraichir la mémoire sur les nombres
amiables, voici [l'article de wikipédia](http://fr.wikipedia.org/wiki/Nombre_amical).
Et en voici une définition rapide:

si *f*(n) est une fonction qui calcule la
somme des diviseurs stricts de n, alors n et m sont amiables si
*f*(n) = m et *f*(m) = n.

Obtenir les diviseurs d'un nombre
---------------------------------
La première chose à faire est de calculer les diviseurs d'un nombre n.
Pour mémoire, les diviseurs de 8, par exemple, sont 1 ; 2 ; 4 et 8.
Pour les trouver, une méthode consiste à diviser 8 par chaque nombre de 1 à 8
et à regarder le reste de la division. Si il reste 0, c'est un diviseur, sinon
ce n'est pas un diviseur. En Ruby, calculer le reste d'une division se fait
avec l'opérateur `%` (le modulo):

``` irb
[~]⇒ irb
>> 8 % 1
0
>> 8 % 2
0
>> 8 % 3
2
>> 8 % 4
0
>> 8 % 5
3
>> 8 % 6
2
>> 8 % 7
1
>> 8 % 8
0
```

On voit bien que les diviseurs de 8, soit 1, 2, 4 et 8 renvoient bien 0.
Évidemment, il n'est pas question de se taper tout ces chiffres *à la main*,
imaginez un peu que vous vouliez connaitre les diviseurs de 123456789 !
Il nous faut quelque chose pour produire automatiquement les nombres de 1 à
n. En Ruby, on appelle ça un `Range`:

``` irb
>> 1..8
1..8
```

Pour y voir plus clair, on va appeler la méthode `to_a` sur ce `Range`, qui
va nous le transformer en un tableau (`Array`). Vous pouvez pensez à un
tableau comme à une simple liste:

``` irb
>> (1..8).to_a
[1, 2, 3, 4, 5, 6, 7, 8]
```

On a bien une liste des nombres de 1 à 8. Notez que les parenthèses sont ici
nécessaires, sinon la méthode `to_a` serait appelée sur le chiffre 8, et
c'est pas bon:

``` irb
>> 1..8.to_a
NoMethodError: undefined method `to_a' for 8:Fixnum
```

La prochaine fois on verra comment sélectionner dans cette liste seulement
les nombres qui nous intéressent, c'est à dire les diviseurs.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

