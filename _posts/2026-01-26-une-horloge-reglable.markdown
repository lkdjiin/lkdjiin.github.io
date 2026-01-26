---
layout: post
title: "Une horloge réglable"
date: 2026-01-26 8:00
comments: true
tags: [ retro, 8bits ]
---

On améliore [l'horloge](/blog/2026/01/25/clignote/) de la dernière fois.
On s'occupera tout d'abord de stabiliser l'alimentation, puis on ajoutera
un potentiomètre pour pouvoir régler la vitesse.

<!-- more -->

{% img center /images/horloge003.png %}

## L'alimentation

Pour éviter les pics et les bosses lors des phases de transition, on ajoute
un condensateur de 10 nano entre le pin 5 du LM555 et le +5v, et un condensateur
de 100 nano entre le ground et le +5v.
Au passage on relie aussi le pin 4 du LM555 au +5v pour éviter de le laisser dans
un état incertain.


## Variation de vitesse

On remplace la résistance de 100k par un potard de 1M (en série avec une résistance
de 1k pour éviter les court-circuits).
Si j'ai bien lu la _datasheet_ et bien effectué les calculs [_1,44/((R2+2(R3+RV1))xC1)_] on
peut faire varier cette horloge d'environ **0,3Hz** à **218Hz**.
Ce qui me semble quand même assez peu, je m'attendais à pouvoir aller plus vite.
D'un autre coté, cette horloge sera seulement utilisé pour la mise au point, alors
pourquoi pas.

{% img center /images/horloge004.jpg %}

On peut voir sur la photo que j'ai oublié d'acheter des petits potentiomètres
pour _breadboard_. J'ai utilisé pour l'instant un seul circuit intégré, et il y
a déjà des fils qui se baladent :D

{% include serie_ordi_8bits.md %}
