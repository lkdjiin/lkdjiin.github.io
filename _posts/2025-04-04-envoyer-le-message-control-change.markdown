---
layout: post
title: "Envoyer le message MIDI Control Change"
date: 2025-04-04 8:00
comments: true
tags: [ arduino, midi ]
---

## 15 jours pour comprendre les contrôleurs MIDI - Jour 5

Je rassemble ce que j'ai appris depuis le début pour enfin envoyer un message
MIDI contrôlé par un potentiomètre à un synthé.

<!-- more -->

## Le message MIDI Control Change

Souvent abrégé en CC, ce message sert à modifier en temps réel un paramètre du
son. Ça peut être n'importe quoi et c'est spécifique au synthé. On retrouve
couramment les paramètres de l'envellope de l'ampli ou des filtres, la fréquence de
coupure, la fréquence d'un LFO, etc.

## Le code

Je teste avec la fréquence de coupure (`FILTER_CUTOFF`). La seule nouveauté
parmi les codes précédents est la ligne suivante :

      MIDI.sendControlChange(FILTER_CUTOFF, current, 2);

Elle indique à la bibliothèque MIDI d'envoyer le message CC numéro 74, avec la
valeur du potentiomètre (`current`) sur le canal 2.

{% highlight cpp %}
#include <MIDI.h>

const int FILTER_CUTOFF = 74;

int penultimate = 0;
int last = 0;

MIDI_CREATE_DEFAULT_INSTANCE();

void setup() {
  MIDI.begin(MIDI_CHANNEL_OFF);
}

void loop() {
  int current = analogRead(A0) >> 3;

  if (last != current) {
    if (penultimate + last != last + current) {
      MIDI.sendControlChange(FILTER_CUTOFF, current, 2);
      penultimate = last;
      last = current;
    }
  }

  delay(10);
}
{% endhighlight %}

## Références

1. [Le code de cet article est sur github](https://github.com/lkdjiin/15-jours-pour-comprendre-les-controleurs-MIDI/tree/main/jour05)
1. [MIDI 1.0 Detailed Specification](https://midi.org/midi-1-0-detailed-specification)

{% include serie_002.md %}
