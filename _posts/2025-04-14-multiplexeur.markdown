---
layout: post
title: "Multiplexeur"
date: 2025-04-14 8:00
comments: true
tags: [ arduino ]
---

## 15 jours pour comprendre les contrôleurs MIDI - Jour 11 

Comment faire pour utiliser plus de potentiomètres que votre micro-contrôleur ne possède
d'entrées analogiques ? En prenant un micro-contrôleur mieux fourni en entrées ?
Ou en utilisant des multiplexeurs, ce qui vous reviendra moins cher et prendra moins de place.
En attendant la mise en pratique dans le prochain article, c'est parti pour un
peu de théorie.

<!-- more -->

## Le mux

Le multiplexeur, _mux_ en abrégé, est un dispositif électronique très simple,
et pourtant si utile à notre vie moderne. Sans lui, pas d'ordinateurs.
Les multiplexeurs sont indispensables, entre autre, pour gérer la mémoire (RAM, registres).
Ce sont eux qui permettent de sélectionner un octet précis parmi des gigas.

On peut voir les multiplexeurs comme une boite noire avec plusieurs entrées de données et une
seule sortie. Et on va pouvoir à tout moment sélectionner quelle entrée spécifique
sera reproduite sur la sortie.

On trouvera des muxs à 2, 4, 8 ou 16 entrées. La sélection se fait à l'aide de
quelques bits. Pour un mux à 2 entrées, un seul bit de sélection est suffisant.
Alors que pour un mux à 4 entrées, deux bits de sélection seront nécessaires, etc.

## Le CD4051

J'utiliserai un CD4051, qui est un mux à 8 entrées.
J'expliquerai rapidement l'utilisation des 16 broches :

{% img center /images/cd4051.png %}

La broche n°16 sera reliée au 5 volts.

Les broches 6, 7 et 8 seront reliées au ground. La n°6 est la broche d'_inhibition_ ;
elle permet de n'avoir pas de sortie si besoin et elle n'aura pas d'utilité dans notre cas.

La broche n°3 est la sortie.

Les broches 1, 2, 4, 5, 12, 13, 14 et 15 sont les 8 entrées.

Les broches 9, 10 et 11 sont les 3 bits de sélection.

C'est tout pour la théorie. À demain pour mettre en pratique la récupéreration de deux potentiomètres sur
une seule entrée de l'arduino.

## Références

1. [Datasheet CD4051](https://www.ti.com/lit/ds/symlink/cd4051b.pdf)

{% include serie_002.md %}
