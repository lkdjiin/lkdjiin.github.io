---
layout: post
title: "Lire un potentiomètre"
date: 2025-04-01 10:27
comments: true
tags: [ arduino ]
---

## 15 jours pour comprendre les contrôleurs MIDI - Jour 2

Avant de contrôler mon synthé avec plusieurs potentiomètres, je dois déjà
pouvoir en lire un.

<!-- more -->

## Le montage

La valeur du potentiomètre n'a aucune importance. 2k, 10k, 100k, 500k,
utilisez ce que vous avez sous la main.

{% img center /images/lire-un-potentiometre.png %}

## Lecture sur 10 bits

Les entrées analogiques de l'ardunio convertissent le voltage (0 à 5 volts)
en un nombre de 10 bits, soit de 0 à 1023. Le programme suivant affiche la
valeur du potentiomètre branché sur la broche A0 sur le moniteur série.

{% highlight cpp %}
void setup() {
  Serial.begin(9600);
}

void loop() {
  int currentValue = analogRead(A0);
  Serial.println(currentValue);
  delay(10);
}
{% endhighlight %}

## Conversion en 7 bits

Les messages MIDI auront une valeur comprise entre 0 et 127, soit 7 bits.
Pour passer de 10 bits à 7 bits on peut diviser par 8. (Diviser par 2 revient
à "retirer" un bit). Ou alors on peut faire plus rapide
en décalant de 3 bits vers la droite.

{% highlight cpp %}
Serial.println(currentValue >> 3);
{% endhighlight %}

## Références

1. [Le code de cet article est sur github](https://github.com/lkdjiin/15-jours-pour-comprendre-les-controleurs-MIDI/tree/main/jour02)
1. Le potard est ici utiliser comme un [diviseur de tension](https://fr.wikipedia.org/wiki/Diviseur_de_tension)
