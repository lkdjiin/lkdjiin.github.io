---
layout: post
title: "Six potentiomètres - Code objet"
date: 2025-04-08 8:00
comments: true
tags: [ arduino, midi, cpp ]
---

## 15 jours pour comprendre les contrôleurs MIDI - Jour 7

J'ai en tête de fabriquer plusieurs contrôleurs MIDI différents, mais qui
auront tous quelques potentiomètres. Avoir une classe réutilisable pour gérer ces
potards me semble une bonne idée.

<!-- more -->

## La classe Pot

Un objet _Pot_ gardera la mémoire de ses deux dernières mesures (`last` et
`penultimate`). Il saura à quelle broche de l'arduino il est attaché (`pin`).
Il saura aussi quel numéro de contrôleur MIDI il manipule (`cc`).

Enfin, il devra pouvoir prendre une mesure avec `update()`.

{% highlight cpp %}
// Fichier Pot.hpp

#ifndef Pot_hpp
#define Pot_hpp

#include <Arduino.h>

class Pot {
  public:
    int last;
    int penultimate;
    int pin;
    int cc;
    Pot();
    Pot(int pin, int cc);
    int update();
};

#endif
{% endhighlight %}

### Le constructeur

Pendant sa construction, l'objet est initialisé avec la valeur courante du
potard, et non pas à zéro comme précédemment. Ça permet d'éviter d'envoyer
systématiquement un message MIDI au branchement du contrôleur. Théoriquement
(ou plutôt : «hors fluctuation»), le
premier message devrait être envoyé quand on manipule le potard pour la première
fois.

{% highlight cpp %}
// Fichier Pot.cpp

Pot::Pot(int pin, int cc) {
  this->pin = pin;
  this->cc = cc;
  last = analogRead(pin) >> 3;
  penultimate = last;
}
{% endhighlight %}

### Mise à jour de la mesure

C'est la même logique que depuis le début de cette série. Il y a pourtant un
petit ajout : la fonction renvoie la valeur magique 128 pour signifier que la
valeur du potard n'a pas changée (128 est invalide pour notre message MIDI).

{% highlight cpp %}
int Pot::update() {
  int current = analogRead(pin) >> 3;

  if (last != current) {
    if (penultimate + last != last + current) {
      penultimate = last;
      last = current;
      return current;
    }
  }

  return 128;
}
{% endhighlight %}

### Le fichier principal

Il ressemble fortement à la version sans la classe Pot d'hier. Remarquez dans
la fonction `loop()` comme on envoie le message MIDI seulement si la valeur du
contrôleur est valide (`if (newValue < 128)`).

{% highlight cpp %}
#include <MIDI.h>
#include "Pot.hpp"

const int total_pots = 6;
const int filter_reso = 71;
const int filter_cutoff = 74;
const int amp_attack = 81;
const int amp_release = 84;
const int filter_attack = 85;
const int filter_release = 88;

MIDI_CREATE_DEFAULT_INSTANCE();

Pot pots[total_pots];
int pin[] = {A0, A1, A2, A3, A4, A5};
int CC[] = {filter_cutoff,
            filter_reso,
            filter_attack,
            filter_release,
            amp_attack,
            amp_release};

void setup() {
  MIDI.begin(MIDI_CHANNEL_OFF);
  for (int i = 0; i < total_pots; i++) {
    pots[i] = Pot(pin[i], CC[i]);
  }
}

void loop() {
  for (int i = 0; i < total_pots; i++) {
    int newValue = pots[i].update();
    if (newValue < 128) {
      MIDI.sendControlChange(pots[i].cc, newValue, 2);
      delay(5);
    }
  }
}
{% endhighlight %}

## Références

1. [Le code de cet article est sur github](https://github.com/lkdjiin/15-jours-pour-comprendre-les-controleurs-MIDI/tree/main/jour07)

{% include serie_002.md %}
