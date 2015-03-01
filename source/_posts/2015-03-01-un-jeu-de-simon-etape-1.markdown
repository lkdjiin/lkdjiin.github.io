---
layout: post
title: "Un jeu de Simon - Étape 1"
date: 2015-03-01 21:00
comments: true
categories: [arduino, jeu, c, éléctronique, matériel, débutant]
---

{% level 1 %}

Lors d'un projet du dimanche avec ma fille, j'ai commencé un
[jeu de Simon](http://fr.wikipedia.org/wiki/Simon_%28jeu%29) sur l'Arduino.
Nous avons simplifié les règles au maximum (ma fille n'a pas 3 ans) et obtenu
ce que je vous propose dans cet article.

C'est seulement un point de départ, j'ai bien envie d'implémenter le jeu en
entier et d'en faire un objet réel. Il devrait donc y avoir d'autres articles…

{% img center /images/simon-1.jpg %}

<!-- more -->

## Les règles

J'ai réduit les règles du jeu au plus simple : Il y a deux couleurs, rouge et
vert. La machine donne une couleur en allumant une LED et le joueur répond en
appuyant sur un bouton de couleur. Si la réponse est juste le joueur gagne et
une nouvelle partie commence. Si la réponse est fausse les LEDs clignotent
quelque temps pour signaler que le jeu est perdu et une nouvelle partie
commence.

Difficile de faire plus simple, hein ?

## Les composants

Nous aurons besoin de :

- 2 LEDs, une rouge et une verte
- 2 boutons momentanés, si possible un rouge et un vert (sinon les gris
  moches ça marche aussi)
- 2 résistances de 220 Ohms pour les LEDs
- 2 résistances de 10 kilo Ohms pour les boutons
- du câble

## L'assemblage

{% img center /images/simon-etape1-bb.png %}

## Le code

Rien de spécial à dire pour le code, si ce n'est qu'il a été écrit sous la
pression de ma fille et la patience n'est pas son fort. Ça pourrait expliquer
pourquoi le code n'est pas très joli.

``` c
const byte RED = 0;
const byte GREEN = 1;

byte buttonRed = 8;
byte buttonGreen = 9;
byte ledRed = 2;
byte ledGreen = 3;
byte computerTurn = 1;
byte lastPly;

void setup() {
  pinMode(buttonRed, INPUT);
  pinMode(buttonGreen, INPUT);
  pinMode(ledRed, OUTPUT);
  pinMode(ledGreen, OUTPUT);

  randomSeed(analogRead(0));
}

void loop() {
  if(computerTurn) {
    lastPly = random(2);
    allLedsOff();
    if(lastPly == RED) {
      digitalWrite(ledRed, HIGH);
    } else {
      digitalWrite(ledGreen, HIGH);
    }
    delay(300);
    allLedsOff();
    computerTurn = 0;
  } else {
    int stateRed = digitalRead(buttonRed);
    int stateGreen = digitalRead(buttonGreen);
    if(stateRed || stateGreen) {
      if(stateRed) {
        lightTheLed(ledRed);
      } else {
        lightTheLed(ledGreen);
      }
      if(stateRed && lastPly == RED) {
        delay(2000);
      } else if(stateGreen && lastPly == GREEN) {
        delay(2000);
      } else if((stateRed && lastPly == GREEN) || (stateGreen && lastPly == RED)) {
        blinkLeds();
        delay(2000);
      }
      computerTurn = 1;
    }
    delay(1);
  }
}

void allLedsOff() {
  digitalWrite(ledRed, LOW);
  digitalWrite(ledGreen, LOW);
}

void lightTheLed(byte led) {
  digitalWrite(led, HIGH);
  delay(200);
  digitalWrite(led, LOW);
}

void blinkLeds() {
  for(int i = 0; i < 10; i++) {
    digitalWrite(ledRed, HIGH);
    digitalWrite(ledGreen, HIGH);
    delay(100);
    allLedsOff();
    delay(100);
  }
}
```

## La suite

Il reste beaucoup de choses à faire… Ajouter le bleu et le jaune ; ajouter du son ;
enregistrer les séquences de couleur ; le vrai jeu de Simon, quoi.
Et ensuite il faudra en faire un objet autonome, sans Arduino.

Alors à la prochaine.

