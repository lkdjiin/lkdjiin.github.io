---
layout: post
title: "Multiplexeur II"
date: 2025-04-15 8:00
comments: true
tags: [ arduino ]
---

## 15 jours pour comprendre les contrôleurs MIDI - Jour 12 

Aujourd'hui on voit en pratique comment brancher deux potentiomètres sur une
unique entrée analogique de l'arduino.

<!-- more -->

## Le montage

Les potentiomètres sont branchés aux entrées 0 et 1 du CD4051 (respectivement
broches 13 et 14).

La sortie du CD4051 est branchée sur l'entrée analogique A0 de l'arduino.

Un condensateur de 100 nF relie la broche 16 du CD4051 au ground. Il n'est pas
indispensable, mais recommandé.

Comme il n'y a que deux potentiomètres, je n'ai branché qu'une seule ligne de
sélection : la broche 8 de l'arduino contrôle le bit de sélection A (broche 11)
du CD4051.

Les deux autres bits de sélection B et C du CD4051 sont inutilisés dans ce 
montage et sont donc reliés au ground pour être mis à 0.

{% img center /images/multiplexeur-ii-1.png %}

## Le code

La broche 8 de l'arduino est utilisée pour contrôler le CD4051 et est donc
déclarée en `OUTPUT`. Je met aussi en route le moniteur série pour pouvoir
afficher les mesures des deux potards.

{% highlight cpp %}
const int total_pots = 2;

void setup() {
  pinMode(8, OUTPUT);
  Serial.begin(9600);
}
{% endhighlight %}

Avec `digitalWrite(8, i)` on sélectionne tour à tour l'entrée n°13 du mux (quand `i == 0`)
et l'entrée n°14 (quand `i == 1`).

{% highlight cpp %}
void loop() {
  for(int i = 0; i < total_pots; i++) {
    digitalWrite(8, i);
    int value = analogRead(A0);
    Serial.println("Pot_" + String(i) +  ":" + String(value));
    delay(50);
  }
}
{% endhighlight %}

On peut maintenant utiliser deux potards sur une seule entrée de l'arduino.

{% img center /images/multiplexeur-ii-2.png %}

## Références

1. [Le code de cet article est sur github](https://github.com/lkdjiin/15-jours-pour-comprendre-les-controleurs-MIDI/tree/main/jour12)
1. [Datasheet CD4051](https://www.ti.com/lit/ds/symlink/cd4051b.pdf)

{% include serie_002.md %}
