---
layout: post
title: "Moniteur MIDI"
date: 2025-04-17 8:00
comments: true
tags: [ midi ]
---

## 15 jours pour comprendre les contrôleurs MIDI - Jour 14

Quand j'ai réalisé [le contrôleur MIDI](/blog/2025/04/09/prototype-en-carton/) j'ai eu la chance qu'il fonctionne du
premier coup. Mais je ne suis pas naïf, d'habitude ce n'est pas aussi simple. Chaque fois
que je modifiais le code ou le montage je pensais «Comment je vais débugger si
ça ne fonctionne pas ?».

<!-- more -->

## Monitoring MIDI

Une solution pour aider au débuggage, c'est de voir
les messages MIDI entrants et sortants de l'ordinateur.
Pour ça il existe tout un tas d'utilitaires. Pour linux je suis tombé sur
`midisnoop` dans le gestionnaire de paquet qui me semble être tout ce dont j'ai besoin pour l'instant.

Je branche mon contrôleur sur l'ordinateur via un cable MIDI. Je le sélectionne
dans l'application. Et je vois les évenements qu'envoie mon arduino : numéro de canal,
numéro de contrôleur, valeur.

{% img center /images/moniteur-midi-1.png %}

Quelle que soit votre plate-forme et vos exigences, vous devriez trouver un
moniteur MIDI qui vous convient. Si j'ai le temps j'aimerais aussi tester
[drumstick](https://kmidimon.sourceforge.io/) et
[ShowMIDI](https://github.com/gbevin/ShowMIDI/releases).

{% include serie_002.md %}
