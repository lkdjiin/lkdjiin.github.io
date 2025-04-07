---
layout: post
title: "Six potentiomètres"
date: 2025-04-07 8:00
comments: true
tags: [ arduino, midi ]
---

## 15 jours pour comprendre les contrôleurs MIDI - Jour 6

Cette fois j'utilise six potentiomètres pour faire varier six paramètres du
son en même temps. Il suffira d'adapter un peu le code.

<!-- more -->

## Les potentiomètres

Vous pouvez utiliser n'importe quels potentiomètres linéaires (les logarithmiques
ne répondront pas comme il faut pour cet usage). Ici j'ai des 10k, 50k, 100k et 1M.

{% img center /images/six-potards.jpg %}

## Le code

Je commence par inclure la bibliothèque MIDI et définir quelques constantes.
Le nombre de potentiomètres, le canal MIDI sur lequel seront envoyés les
messages, et plusieurs numèros de contrôleurs qui correspondent aux composantes
du son que je veux modifier avec les potards.

{% highlight cpp %}
#include <MIDI.h>

const int total_pots = 6;
const int channel = 2;
const int filter_reso = 71;
const int filter_cutoff = 74;
const int amp_attack = 81;
const int amp_release = 84;
const int filter_attack = 85;
const int filter_release = 88;
{% endhighlight %}

Viennent ensuite quelques tableaux, pour les valeurs nécessaires
des six potards. `last` et `penultimate` pour conserver les dernières et
avant-dernières mesures. `pin`, pour associer chaque potard à une broche de
l'arduino. Et `CC`, pour savoir quel potard s'occupe de quel contrôle.

{% highlight cpp %}
int last[] = {0, 0, 0, 0, 0, 0};
int penultimate[] = {0, 0, 0, 0, 0, 0};
int pin[] = {A0, A1, A2, A3, A4, A5};
int CC[] = {filter_reso,
            filter_cutoff,
            filter_attack,
            filter_release,
            amp_attack,
            amp_release};
{% endhighlight %}

Puis on trouve la fonction `update()` qui fait exactement la même chose que
dans [le code précédent](/blog/2025/04/04/envoyer-le-message-control-change), mais en utilisant les tableaux. Je l'ai extraite
de `loop()` pour un peu plus de clarté.

{% highlight cpp %}
MIDI_CREATE_DEFAULT_INSTANCE();

void update(int index) {
  int current = analogRead(pin[index]) >> 3;

  if (last[index] != current) {
    if (penultimate[index] + last[index] != last[index] + current) {
      MIDI.sendControlChange(CC[index], current, channel);
      penultimate[index] = last[index];
      last[index] = current;
    }
  }
}
{% endhighlight %}

Le classique `setup()` :

{% highlight cpp %}
void setup() {
  MIDI.begin(MIDI_CHANNEL_OFF);
}
{% endhighlight %}

Et finalement la boucle qui lit les 6 potards encore et encore :

{% highlight cpp %}
void loop() {
  for (int i = 0; i < total_pots; i++) {
    update(i);
    delay(10);
  }
}
{% endhighlight %}

## Références

1. [Le code de cet article est sur github](https://github.com/lkdjiin/15-jours-pour-comprendre-les-controleurs-MIDI/tree/main/jour06)

{% include serie_002.md %}
