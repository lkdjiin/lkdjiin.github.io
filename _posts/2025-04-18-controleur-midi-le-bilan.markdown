---
layout: post
title: "Contrôleur MIDI : Le bilan"
date: 2025-04-18 8:00
comments: true
tags: [ arduino, midi, cpp ]
---

## 15 jours pour comprendre les contrôleurs MIDI - Jour 15

Dernier jour, c'est l'heure du bilan.
J'ai appris plusieurs choses, j'ai des nouvelles envies, et un tas de nouvelles
questions ;)

<!-- more -->

### Ce que j'ai appris

Je peux envoyer des notes «générées» par l'arduino à un synthé. Ça ouvre beaucoup de perspectives.

J'ai créé un contrôleur MIDI à six potards, dont je peux me servir pour contrôler
n'importe quel synthé hardware ou software. Même si j'ai utilisé une boite en
carton pour le fabriquer, ça devrait tenir le coup quelques mois.

Je peux lire des dizaines de potards et de boutons à l'aide de multiplexeurs.

### Nouvelles envies

Fabriquer un panneau d'une vingtaine de potentiomèters et sliders pour mon Pro VS mini.

Essayer un contrôleur à base de photorésistances et capteurs de proximité pour la jouer à la Jean Michel Jarre :D

Un mini-contrôleur avec un unique slider qui contrôlerait le «last touched parameter» dans Reaper (le DAW que j'utilise).

Séquenceurs, arpégiateurs, générateurs… Plus j'y pense, plus la liste s'allonge.

### Nouvelles questions

Comment récuperer des messages MIDI issus de synthés, de claviers maitres ou de l'ordinateur pour les transformer.

Comment utiliser ou créer de la synchro pour le tempo.

Comment configurer mes contrôleurs (canal, CC) sans charger un nouveau programme dans l'arduino.

{% include serie_002.md %}
