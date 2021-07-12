---
layout: post
title: "Bien débuter avec Vim: la touche Escape"
date: 2013-08-15 10:45
legacy: true
tags: [vim]
---



Vim a été développé sur des machines dont les claviers avaient une
disposition des touches autres que celle de nos claviers modernes. Comme par
exemple le terminal ADM-3A:

{% img /images/KB_Terminal_ADM3A.png %}

<!-- more -->

Le plus frappant c'est l'endroit de la touche *Escape* à l'époque. On pouvait
y accéder avec une simple extension du petit doigt gauche, sans avoir à
bouger la main. De nos jours, cette touche a été reléguée aux confins de
l'univers. Sachant que c'est une touche qu'on utilise sans cesse, y a de
quoi choper une tendinite. Je vais vous donner 3 trucs pour remédier à ce
problème, choisissez celui qui vous conviendra le mieux.

Control c
-----------
C'est le truc le plus simple, rien à configurer. La combinaison `<Ctrl-c>`
fonctionne naturellement comme une touche *Escape*. Il y a bien
quelques différences, et vous vous en rendrez compte à l'occasion, mais
la plupart du temps ça fonctionne. Commencez donc par là avant de vous
attaquer à d'autres trucs, celui-ci est peut être amplement suffisant.

Une combinaison personnalisée
-----------------------------
Il semble que `jj` soit une combinaison de remplacement populaire en
mode insertion:

{% highlight vim %}
inoremap jj <Esc>
{% endhighlight %}

L'idée c'est d'utiliser une combinaison de deux caractères qui n'existe
pas dans votre langue/langage, et qui bien sûr soit simple et rapide a
taper. J'ai essayé pendant un moment ce genre de chose, mais je n'ai
jamais réussi à m'y faire.

Échanger caps lock et esc
-------------------------
Si pour vous la touche *caps lock* (verrou majuscule) est un mystère, voici
le truc qu'il vous faut. Mettez donc votre système d'exploitation à
contribution pour:

* soit échanger la touche *caps lock* et *esc*
* soit faire de *caps lock* une touche *esc* supplémentaire

Quelque soit votre OS, vous devriez trouver ça dans un menu du genre
Système > Préférences > Clavier.

Pour conclure
-------------
Vous trouverez plein d'autres trucs sur internet, n'hesitez pas à en
essayer plusieurs avant d'adopter celui qui vous ressemblera.





À demain.


