---
layout: post
title: "Régler le problème de fluctuation"
date: 2025-04-03 8:00
comments: true
tags: [ arduino ]
---

## 15 jours pour comprendre les contrôleurs MIDI - Jour 4

Je règle [le problème, rencontré précédement,](/blog/2025/04/02/lire-un-potentiometre-ii/)
de la fluctuation de la valeur du potentiomètre.

<!-- more -->

## Le code

L'idée principale est de comparer des moyennes de valeurs, plutôt que des valeurs ponctuelles.
Pour faire une moyenne il faut une division. Mais je n'ai pas envie d'introduire de
division dans le code si je peux l'éviter, pour le garder le plus rapide possible.
C'est pourquoi je me contente de comparer l'addition des deux anciennes valeurs
d'un côté, avec l'addition de la valeur courante et de la dernière d'un autre
côté (`penultimate + last != last + current`).

{% highlight cpp %}
int penultimate = 0;
int last = 0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  int current = analogRead(A0) >> 3;

  if (last != current) {
    if (penultimate + last != last + current) {
      Serial.println(current);
      penultimate = last;
      last = current;
    }
  }

  delay(10);
}
{% endhighlight %}

Grâce à cela, les fluctuations sont maintenant très rares.

## Références

1. [Le code de cet article est sur github](https://github.com/lkdjiin/15-jours-pour-comprendre-les-controleurs-MIDI/tree/main/jour04)

{% include serie_002.md %}
