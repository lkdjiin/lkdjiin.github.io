---
layout: post
title: "Envoyer une note à un synthé par le cable MIDI"
date: 2025-03-31 8:00
comments: true
tags: [ arduino, midi ]
---

## 15 jours pour comprendre les contrôleurs MIDI - Jour 1

L'objectif de cette série est de fabriquer un (ou plusieurs) contrôleur MIDI,
afin de comprendre comment ça marche. Avant de m'y mettre à fond, j'effectue un
_smoke test_ pour être sûr que mon matériel est fonctionnel. Au lieu de faire
clignoter la LED de l'arduino, on va faire "clignoter" une note sur un synthé.

<!-- more -->

## Le circuit

Attention, la prise DIN est vue de face. Pour ne pas vous planter dans les
broches, n'hésiter pas à regarder la vidéo qui se trouve dans les références.

{% img center /images/envoyer-note-midi-01.jpg %}

## Le code

{% highlight cpp %}
#include <MIDI.h>

MIDI_CREATE_DEFAULT_INSTANCE();

void setup() {
  MIDI.begin(MIDI_CHANNEL_OFF);
}

void loop() {
  MIDI.sendNoteOn(60, 127, 2);
  delay(1000);
  MIDI.sendNoteOff(60, 0, 2);
  delay(1000);
}
{% endhighlight %}

Y a pas grand chose. `MIDI_CREATE_DEFAULT_INSTANCE()` initialise la bibliothèque
qui nous permet de communiquer en MIDI.

`MIDI_CHANNEL_OFF` c'est pour dire qu'on ne veut pas écouter de messages MIDI.
Dans cette appli on se contente d'en envoyer.

On déclenche une note avec `sendNoteOn(x, y, z)`. x est le numéro de note MIDI.
y est le volume (de 0 à 127). z est le canal MIDI (1 à 16). Mon synthé est réglé
pour écouter le canal 2.

## La réalité

{% img center /images/envoyer-note-midi-02.jpg %}

Maintenant je sais que j'ai le matériel nécessaire pour ce que je veux faire.

## Références

1. [Le code de cet article est sur github](https://github.com/lkdjiin/15-jours-pour-comprendre-les-controleurs-MIDI/tree/main/jour01)
1. [Je me base sur cette vidéo](https://www.youtube.com/watch?v=rmfAqg9O_os)
1. [Smoke test](https://en.wikipedia.org/wiki/Smoke_testing_(software))
1. [Numéros de note MIDI](https://computermusicresource.com/midikeys.html)
1. [La bibliothèque MIDI](https://github.com/FortySevenEffects/arduino_midi_library)
1. [Specs d'une prise MIDI](https://midi.org/5-pin-din-electrical-specs)
