---
layout: post
title: "Multiplexeur III"
date: 2025-04-16 8:00
comments: true
tags: [ arduino ]
---

## 15 jours pour comprendre les contrôleurs MIDI - Jour 13

Suite logique de [l'article d'hier](/blog/2025/04/15/multiplexeur-ii/), voyons comment généraliser le contrôle de
plusieurs potentiomètres sur une seule entrée de l'arduino.

<!-- more -->

## Le montage

C'est [le même qu'hier](/blog/2025/04/15/multiplexeur-ii/) mais on ajoute des potards et on utilise tout les bits de
sélection.

Reliez jusqu'à 8 potards au CD4051. Pour ce test je me contente de trois potards
sur les broches n°13, 14, et 15 du CD4051.

Pour les bits de sélection, reliez la broche n°8 de l'arduino à la broche n°11 du CD4051 (bit de poid faible), puis la
broche n°9 de l'arduino à la broche n°10 du CD4051, et enfin la broche n°10 de l'arduino à la
broche n°9 du CD4051 (bit de poid fort).

## Sélection des potentiomètres

On pourra penser à plusieurs manière d'allumer/éteindre les bits de sélection du
CD4051, mais
l'arduino nous fournit la fonction `bitRead(value, position)` qui est idéale
pour mettre à jour ces trois bits. Cette fonction renvoie la valeur
du bit (0 ou 1) dans le nombre _value_ qui se trouve à la position _position_.

{% highlight cpp %}
const int total_pots = 3;

void setup() {
  pinMode(8, OUTPUT);
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  for(int i = 0; i < total_pots; i++) {
    digitalWrite(8, bitRead(i, 0));
    digitalWrite(9, bitRead(i, 1));
    digitalWrite(10, bitRead(i, 3));
    int value = analogRead(A0);
    Serial.println("Pot_" + String(i) +  ":" + String(value));
    delay(500);
  }
}
{% endhighlight %}

La lecture des 3 potards en image :

{% img center /images/multiplexeur-iii-1.png %}

## Références

1. [Le code de cet article est sur github](https://github.com/lkdjiin/15-jours-pour-comprendre-les-controleurs-MIDI/tree/main/jour13)
1. [Datasheet CD4051](https://www.ti.com/lit/ds/symlink/cd4051b.pdf)
1. [Langage Arduino](https://docs.arduino.cc/language-reference/)

{% include serie_002.md %}
