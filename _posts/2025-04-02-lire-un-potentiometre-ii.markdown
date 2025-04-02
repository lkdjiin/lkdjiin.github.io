---
layout: post
title: "Lire un potentiomètre II"
date: 2025-04-02 8:00
comments: true
tags: [ arduino ]
---

## 15 jours pour comprendre les contrôleurs MIDI - Jour 3

Le [code précédent](/blog/2025/04/01/lire-un-potentiometre) affichait la valeur
du potentiomètre **en continu**. Pour
éviter de surcharger le récepteur de messages MIDI, je veux afficher la valeur
du potentiomètre seulement quand elle change.

<!-- more -->

## Le code

On garde en mémoire la dernière valeur envoyée (`lastValue`). À chaque lecture,
on affiche la valeur actuelle (`currentValue`) seulement si elle diffère de l'ancienne.

{% highlight cpp %}
int lastValue = 0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  int currentValue = analogRead(A0) >> 3;

  if (lastValue != currentValue) {
    Serial.println(currentValue);
    lastValue = currentValue;
  }

  delay(10);
}
{% endhighlight %}

## Problème de fluctuation

J'observe souvent la valeur courante osciller régulièrement entre deux valeurs
conjointes, par exemple 29, 30, 29, 30, 29, etc.

Je pense que c'est du en grande partie à la breaboard qui doit être vieille ou
de mauvaise qualité, et les connexions sont un peu lâches. Les potards ont aussi
des pattes un peu grosses pour une breaboard, ce qui n'arrange rien.

Ce problème pourrait se régler de lui-même quand les potards seront soudés. Ceci
dit il est probable que les fluctuations du courant suffisent à modifier la
valeur du potard sans qu'on y touche.


## Références

1. [Le code de cet article est sur github](https://github.com/lkdjiin/15-jours-pour-comprendre-les-controleurs-MIDI/tree/main/jour03)

{% include serie_002.md %}

