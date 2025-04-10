---
layout: post
title: "Surveiller la consommation"
date: 2025-04-10 8:00
comments: true
tags: [ arduino, électronique ]
---

## 15 jours pour comprendre les contrôleurs MIDI - Jour 9

Peut-on vraiment utiliser n'importe quelle valeur de résistance pour les
potentiomètres ? Ou doit-on faire attention ?

<!-- more -->

## Le potard comme diviseur de tension

Le contrôleur MIDI utilise les potentiomètres comme des diviseurs de tension.
Autrement dit, n'importe quelle valeur de résistance des potentiomètres
fonctionnera de la même manière qu'une autre.

De ce point de vue, oui, utiliser un potard de 1k ou de 500k aura le même effet :
on balaiera en continu de 0v à 5v et on aura une mesure précise sur une entrée
analogique de l'arduino.

## Mais aussi comme résistance

Mais un potard peut aussi se voir comme une résistance globale entre le 0v et le 5v de
l'arduino. Et là, attention à rester dans les clous pour ne pas le faire
sur-consommer, et donc possiblement sur-chauffer, et pire si affinité.

Savoir ce que peut encaisser un arduino UNO comme courant n'est pas si simple
que ça. Il y a des limitations globales, pour des groupes de broches, pour les
broches individuelles, etc. Pour jouer la carte de la sécurité, disons que
le courant entre le 0V et le 5V doit être limité à un maximum de 100 mA.

Cette fois il va falloir faire quelques calculs.

### Rappel de la loi d'Ohm

La tension U (en volts) est égale à la résistance R (en ohms) multiplié par
le courant I (en ampères).

{% math %}
  U = RI
{% endmath %}

Ou, si l'on cherche le courant :

{% math %}
  I= \frac{U}{R}
{% endmath %}

Concretement, si on a une résistance de 10k entre le ground et le 5 volts on
connaitra le courant avec :

{% math %}
  I= \frac{5}{10 000}
{% endmath %}

C'est à dire 0,0005 A. Ou, avec une unité plus simple à manipuler : 0,5 mA.

Vous pouvez passer directement à la conclusion si vous voulez vous épargner
les calculs liés à la conductance, qui ne sont pas nécessaires pour notre
application.

### Quand il y a résistance, il y a conductance

Les résistances en série (placée les unes après les autres) s'additionnent. Mais
ce n'est pas le cas ici.

Nos potentiomètres sont placés en parallèle. Cela
signifie qu'ils ne sont pas les uns après les autres, mais les uns à côté des
autres : chaque patte de gauche est reliée au 0V et chaque patte de droite est
reliée au 5V.

Lorsque que des résistances sont en série, l'électricité n'a qu'un seul chemin
à suivre, traversant les résistances les unes après les autres. Mais lorsque des résistances sont placées en
parallèle, l'électricité suit TOUT les chemins en même temps.

Des résistances placées en parallèle n'additionnent pas leur résistance, mais
leur conductance. La conductance étant définie simplement comme l'inverse de la
résistance.

### Il y a 6 potentiomètres

Quelle sera la consommation avec 6 potentiomètres de 10k en parallèle ?

La conductance d'un potard est de 0,0001 Siemens.

{% math %}
  \frac{1}{10 000}=0.0001
{% endmath %}

Nous avons 6 potards en parallèle, on peut donc additionner leur conductance.
Soit 0,0006 Siemens (\\(6 \times 0.0001\\)).

Bien, maintenant que nous avons la conductance totale, nous pouvons prendre
l'inverse pour retrouver notre bonne vieille résistance en Ohm. À peu près
1667 Ohms.

{% math %}
  \frac{1}{0.0006}=1666.67
{% endmath %}

Ouf, c'est presque fini. On peut maintenant calculer la consommation de nos
6 potards de 10k :

{% math %}
  I= \frac{5}{1667}
{% endmath %}

Soit environ 3 mA. Donc six fois plus que la conso avec un seul potard. Tout
ça pour ça ? On pouvait s'épargner tout ces calculs et en finir avec une simple
multiplication par six ! Mais ça aurait été moins fun.

## Conclusion

Y a pas de miracle, y a pas de mystère. La conso des 6 potards est bien entendu
l'addition de la conso individuelle de chaque potard. Cette consommation est
très faible pour un potard de 10k, sans parler d'un potard de 100k.

Tant qu'on reste dans des valeurs raisonnables, disons une trentaine de potards
d'au moins 5k, il n'y a pas lieu de s'inquiéter.

Ceci dit, il n'y a pas que les potards montés de cette manière dans la vie. Et
chaque nouveau composant ajoutera sa propre consommation. C'est toujours une
bonne idée d'être en mesure de la calculer pour éviter les mauvaises surprises.



## Références

1. [Diviseur de tension](https://fr.wikipedia.org/wiki/Diviseur_de_tension)
1. [Conductance](https://fr.wikipedia.org/wiki/Conductance_%C3%A9lectrique)

{% include serie_002.md %}

{% include mathjax.html %}
