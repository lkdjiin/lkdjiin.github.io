---
layout: post
title: "Fabriquer un sablier à thé électronique 3"
date: 2016-02-02 15:05
comments: true
categories: [arduino, maker]
---

Comme promis, voici le code de mon *sablier à thé électronique*. C'est le
premier *objet* que j'ai pensé et fabriqué de A à Z, en me servant d'un
arduino pour réaliser d'abord un prototype. Ce qui fait que, même si le
résultat est moche, j'en suis fier ;)

{% img center /images/tea_timer.jpg %}

<!-- more -->

Tout d'abord le code C qui doit être envoyé dans un micro contrôleur Attiny13,
à l'aide d'un [programmateur](/blog/2015/10/29/fabriquer-un-sablier-a-the-electronique/).

```c main.c
#include <avr/io.h>
#include <util/delay.h>

#define LED PB0
#define BUZZER PB2
#define BUTTON3 PB3 // For 3 minutes
#define BUTTON5 PB4 // For 5 minutes

#define THREE_MINUTES_IN_SECONDS 180
#define FIVE_MINUTES_IN_SECONDS  300

int main(void)
{
  DDRB |= 1 << LED | 1 << BUZZER; // Outputs declarations.
  PORTB |= 1 << LED;              // Switch on the LED.
  PORTB &= ~(1 << BUZZER);        // Switch off the buzzer.

  DDRB &= ~(1 << BUTTON3 | 1 << BUTTON5); // Inputs declarations.
  PORTB |= (1 << BUTTON3 | 1 << BUTTON5); // Pull up for inputs.

  // Number of seconds for the timer to buzz.
  int g_timer = 0;

  // Give enough time to enable pull ups.
  _delay_ms(100);

  while(1) {

    // Button for 3 minutes pressed?
    if(!(PINB & (1 << BUTTON3))) {
      _delay_ms(10);
      g_timer = THREE_MINUTES_IN_SECONDS;
      break;
    }

    // Button for 5 minutes pressed?
    if(!(PINB & (1 << BUTTON5))) {
      _delay_ms(10);
      g_timer = FIVE_MINUTES_IN_SECONDS;
      break;
    }
  }

  // Each cycle is approximately 1 second, but this is not really
  // accurate.
  while(g_timer > 0) {
    PORTB ^= 1 << LED; // LED off cause it was set up to on.
    _delay_ms(500);
    PORTB ^= 1 << LED; // LED on.
    _delay_ms(500);
    g_timer--;
  }

  // Now it's time to bip and blink forever.
  while(1) {

    int i;

    for(i = 0; i < 3; i++) {
      PORTB |= 1 << BUZZER;
      _delay_ms(100);
      PORTB &= ~(1 << BUZZER);
      _delay_ms(100);
    }

    for(i = 0; i < 3; i++) {
      PORTB |= 1 << LED;
      _delay_ms(100);
      PORTB &= ~(1 << LED);
      _delay_ms(100);
    }
  }
}
```

Et voici le contenu du Makefile, qui simplifie les phases de compilation et
d'installation.

    DEVICE = attiny13
    CLOCK  = 1000000
    PROGRAMMER = -P /dev/ttyUSB0 -c arduino
    BAUDRATE   = -b 19200

    help:
      @echo 'check => check connection with ATtiny13'
      @echo 'hex   => compile hex file'
      @echo 'flash => install hex file'
      @echo 'clean => delete unnecessary files'

    check:
      avrdude -p $(DEVICE) $(PROGRAMMER) $(BAUDRATE)

    hex:
      avr-gcc -Wall -Os -DF_CPU=$(CLOCK) -mmcu=$(DEVICE) -c main.c
      avr-gcc -mmcu=$(DEVICE) -o main.elf main.o
      avr-objcopy -O ihex main.elf main.hex

    flash:
      avrdude -p $(DEVICE) $(PROGRAMMER) -U flash:w:main.hex $(BAUDRATE)

    clean:
      rm main.o
      rm main.elf

Vous pouvez retrouver ce code sur [gitub](https://github.com/lkdjiin/tea-timer), ainsi que le schéma avec les
composants électroniques.

J'espère me faire bientôt une deuxième version plus jolie et plus sophistiquée.

[Lire la partie 1](/blog/2015/10/29/fabriquer-un-sablier-a-the-electronique/)

[Lire la partie 2](/blog/2015/12/12/fabriquer-un-sablier-a-the-electronique-2/)

{% connexe %}
