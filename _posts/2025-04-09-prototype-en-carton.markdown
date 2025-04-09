---
layout: post
title: "Prototype en carton"
date: 2025-04-09 8:00
comments: true
tags: [ arduino, midi, prototype ]
---

## 15 jours pour comprendre les contrôleurs MIDI - Jour 8

Après une phase de R&D passée à tester différents codes et à tenter de faire tenir des potards
de qualité douteuse sur des breaboards fatiguées, le moment est venu de sortir
le fer à souder pour fabriquer un contrôleur MIDI éphémère, mais assez solide.

<!-- more -->

## L'objectif

D'un côté, je veux un objet qui soit maintenant concret et utilisable en situation réelle pour «valider
le concept». D'un autre côté je veux qu'il reste rapidement modifiable au
besoin. Je ne veux pas passer plusieurs jours à le concevoir. Et si en plus il pouvait me
coûter 0 centimes, ce serait vraiment parfait.

Pour toutes ces raisons, l'utilisation d'une boite en carton de récup me parait
la solution idéale.

## La réalisation

Le montage combine une sortie MIDI (voir [schéma du jour 1](/blog/2025/03/31/envoyer-une-note-par-le-cable-midi/)) et la lecture
analogique de six potentiomètres (voir [schéma du jour 2](/blog/2025/04/01/lire-un-potentiometre/)). Le code utilisé
est celui du [jour 7](/blog/2025/04/08/six-potentiometres-code-objet/).

Je commence par monter les potards sur la boite et à souder le réseau de
ground et 5 volts. Je réalise le montage de la prise DIN sur une chute de
stripboard :

{% img center /images/proto-carton-01.jpg %}

Puis l'ensemble est relié à l'arduino, toujours à l'aide de chutes de stripboard
(l'arduino n'est soudé à rien directement, il pourra resservir pour autre chose). Je fais
quelques ouvertures au cutter dans le carton pour les prises :

{% img center /images/proto-carton-02.jpg %}

Une fois l'arduino alimenté via USB et la prise MIDI reliée au synthé, il est
temps de refermer la boite pour le premier test en condition réelle. Et pour
une fois ça fonctionne du premier coup. Ça m'arrive assez rarement pour que je
le souligne :D

{% img center /images/proto-carton-03.jpg %}

{% include serie_002.md %}
