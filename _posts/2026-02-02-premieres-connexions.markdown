---
layout: post
title: "Premières connexions sur le 65C02"
date: 2026-02-02 8:00
comments: true
tags: [ retro, 8bits ]
---

C'est enfin le moment d'installer le processeur 65C02 sur une _breadboard_
et de faire quelques branchements.

<!-- more -->

## Connexion avec l'horloge

Des LEDs attachées aux pins 9 à 13 clignotent au rythme de l'horloge.
Ces pins correspondent aux bits 0 à 4 du bus d'adresses.
À chaque fois que l'horloge passe de 1 à 0, le motif sur les
LEDs changent. Je ne sais pas encore ce que ça signifie, mais c'est ce qui
est attendu. Je peux aussi vérifier que l'horloge fonctionne en automatique
et en manuelle.
C'est un premier contact en douceur.

{% img center /images/ordi8bits-001.jpg %}

## Connexion à un arduino mega

L'objectif est maintenant de connecter les 16 pins du bus d'adresse du processeur, ses
8 pins du bus de données, et le pin de lecture/écriture à un arduino mega pour
lire en temps réel les valeurs. Et accessoirement essayer de comprendre ce qu'il
se passe et pourquoi ;)

{% img center /images/ordi8bits-002.jpg %}

Comme d'habitude, c'est un joyeux bordel de cables :D

J'apprend qu'à l'allumage (ou après un reset) le processeur va chercher le nombre 16 bits
stocké aux adresses $fffc et $fffd. Ce nombre est l'adresse de début du programme
qui va être exécuté à la suite du reset.

Prochaine étape : connecter une EEPROM puisqu'on en sait maintenant assez
pour amorcer un petit programme depuis une ROM, même si on ne pourra pas aller bien loin
en l'abscence de RAM ;)

{% include serie_ordi_8bits.md %}
