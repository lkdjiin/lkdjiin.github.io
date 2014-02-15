---
layout: post
title: "Simuler une honnête pièce de monnaie à partir d'une truquée"
date: 2014-02-15 12:20
comments: true
categories: [intermédiaire, traduction, ruby, python, probabilité]
---

{% level 2 %}

*Ce qui suit est une traduction assez libre de l'article original
[Simulating a Fair Coin with a Biased Coin](http://jeremykun.com/2014/02/08/simulating-a-fair-coin-with-a-biased-coin/),
j'ai laissé le code python original et ajouté du code Ruby.*

<!-- more -->

**Problème** : Simuler une honnête pièce de monnaie, alors qu'on a uniquement
accès à une pièce truquée.

**Solution** :

En Python

``` python
def fairCoin(biasedCoin):
   coin1, coin2 = 0,0
   while coin1 == coin2:
      coin1, coin2 = biasedCoin(), biasedCoin()
   return coin1
```

En Ruby

``` ruby
def fair_coin
  coin1, coin2 = 0, 0
  coin1, coin2 = biased_coin, biased_coin while coin1 == coin2
  coin1
end
```

**Discussion** : C'est à l'origine une idée brillante de
[von Neumann](http://en.wikipedia.org/wiki/John_von_Neumann). Si nous avons
une pièce truquée (c'est à dire une pièce qui tombe sur face avec une
probabilité différente de 1/2), on peut simuler une pièce non truquée
en lançant deux pièces jusqu'à ce que les deux résultats (pile ou face)
soient différents. Comme on a des résultats différents, la probabilité que
la première pièce donne face et que la seconde donne pile est la même que
la probabilité d'obtenir le résultat inverse (pièce 1 donnant pile et pièce 2
donnant face). Donc, si on retourne simplement le résultat de la première
pièce, on aura pile ou face avec une probabilité de 1/2.

Notez que l'on a pas besoin de connaître ni d'assumer quoique ce soit de
la fonction `biasedCoin`/`biased_coin`, mis à part qu'elle renvoit 1 ou 0
à chaque appel et que les résultats sont indépendant les uns des autres.
En particulier, nous n'avons pas besoin de connaître la probabilité
d'obtenir 1. De plus, nous n'utilisons pas le hasard directement (seulement
à travers la fonction `biasedCoin`/`biased_coin`).
 
Voici une simulation simple :

En python

``` python
from random import random
def biasedCoin():
   return int(random() < 0.2)
```

En Ruby

``` ruby
def biased_coin
  rand < 0.2 ? 1 :  0
end
```

Cette fonction renvoie 1 avec une probabilité de 0.2. Si nous essayons
maintenant:

En Python

``` python
sum(biasedCoin() for i in range(10000))
```

En Ruby

``` ruby
(1..10_000).reduce {|sum| sum + biased_coin }
```

Nous devrions obtenir un nombre proche de 2000. J'ai obtenu 2058.

D'un autre coté, si nous faisons:

En Python

``` python
sum(fairCoin(biasedCoin) for i in range(10000))
```

En Ruby

``` ruby
(1..10_000).reduce {|sum| sum + fair_coin }
```

Nous devrions obtenir approximativement 5000. Et quand j'ai essayé, j'ai
obtenu 4982, ce qui est la preuve que `fairCoin`/`fair_coin` renvoie bien
1 avec une probabilité de 1/2 (même si j'ai déjà fourni cette preuve !).

Pour plus d'informations sur ce sujet, regardez
[ces notes](http://www.eecs.harvard.edu/~michaelm/coinflipext.pdf) par Michael Mitzenmacher de l'université de Harvard.


<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

