---
layout: post
title: "Fabriquer un sablier à thé électronique 2"
date: 2015-12-12 16:51
comments: true
categories: [arduino, maker]
---

Après avoir appris à programmer un ATtiny45 avec l'IDE Arduino, il fallait
maintenant s'en passer. Pour cela je suis passé du langage Arduino au
langage C, avec le cross compilateur `avr-gcc` et l'outil `avrdude`.

Je vais profiter de vous montrer cela pour comparer la taille d'un même
programme, écrit une fois en langage Arduino et l'autre en C.

<!-- more -->

[Lire la partie 1](/blog/2015/10/29/fabriquer-un-sablier-a-the-electronique/)

[Lire la partie 2](/blog/2015/12/12/fabriquer-un-sablier-a-the-electronique-2/)

Le programme, c'est deux boutons/deux LEDs. Le bouton A s'occupe de la LED A.
Le bouton B s'occupe de la LED B. Quand un bouton est pressé puis relâché, sa
LED respective change d'état. Si elle était éteinte elle s'allume, et vice-versa.
C'était un peu mon *hello world!*

Voilà le programme en langage Arduino:

```c sketch/sketch.ino
void setup() {
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  digitalWrite(3, HIGH);
  digitalWrite(4, HIGH);
  pinMode(0, INPUT_PULLUP);
  pinMode(1, INPUT_PULLUP);
}

void loop() {
  if(digitalRead(0) == LOW) {
    delay(10);
    while(digitalRead(0) != HIGH) ;
    delay(10);
    digitalWrite(3, bitRead(PORTB, 3) ^ HIGH);
  }
  if(digitalRead(1) == LOW) {
    delay(10);
    while(digitalRead(1) != HIGH) ;
    delay(10);
    digitalWrite(4, bitRead(PORTB, 4) ^ HIGH);
  }
}
```

Le dossier contient juste deux sous dossiers:

    $ dirtree
    .
    ├── build
    └── sketch

Je compile avec l'IDE (en ligne de commande mais avec l'IDE quand même):

    $ ~/local/bin/arduino-1.6.5/arduino --verify sketch/sketch.ino
    --pref build.path=build
    Picked up JAVA_TOOL_OPTIONS: 
    Loading configuration...
    Initializing packages...
    Preparing boards...
    Verifying...

    Le croquis utilise 972 octets (23%) de l'espace de stockage de programmes.
    Le maximum est de 4 096 octets.
    Les variables globales utilisent 9 octets de mémoire dynamique.

La taille du programme a déjà était annoncée, mais on peut la vérifier avec
`avr-size`, 972 octets:

    $ avr-size -d build/sketch.cpp.hex 
       text	   data	    bss	    dec	    hex	filename
          0	    972	      0	    972	    3cc	build/sketch.cpp.hex

Maintenant voici le même programme, cette fois directement en C. Donc sans
toutes les aides et fioritures de l'Arduino:

```c main.c
#include <avr/io.h>
#define F_CPU 1000000UL
#include <util/delay.h>

int main(void)
{
  DDRB |= 1 << 4 | 1 << 3;
  PORTB |= 1 << 4 | 1 << 3;
  DDRB &= ~(1 << 0 | 1 << 1);
  PORTB |= (1 << 0 | 1 << 1);

  while(1) {
    if(!(PINB & (1 << 0))) {
      _delay_ms(10);
      while(!(PINB & (1 << 0))) ;
      _delay_ms(10);
      PORTB ^= (1 << 3);
    }
    if(!(PINB & (1 << 1))) {
      _delay_ms(10);
      while(!(PINB & (1 << 1))) ;
      _delay_ms(10);
      PORTB ^= (1 << 4);
    }
  }
}
```

La chaîne de compilation est cette fois un peu plus longue:

    $ avr-gcc -O -mmcu=attiny45 -c main.c
    $ avr-gcc -mmcu=attiny45 -o main.elf main.o
    $ avr-objcopy -O ihex main.elf main.hex

Même avec une option d'optimisation au minimum, la différence de taille est… sidérale:

    $ avr-size -d main.hex 
       text	   data	    bss	    dec	    hex	filename
          0	    158	      0	    158	     9e	main.hex

Pour transférer le code vers le micro processeur il n'y a plus besoin de l'IDE
Arduino. Je place l'ATtiny45 sur le [shield programmateur](/blog/2015/10/29/fabriquer-un-sablier-a-the-electronique/) et j'utilise le
programme avrdude :

```
avrdude -p attiny45 -P /dev/ttyUSB0 -c arduino -U flash:w:main.hex -b 19200
```

Rendez vous une prochaine fois pour le code du sablier électronique avec son
Makefile et tout et tout.

{% connexe %}
