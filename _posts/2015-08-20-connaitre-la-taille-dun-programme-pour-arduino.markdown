---
layout: post
title: "Connaitre la taille d'un programme pour Arduino"
date: 2015-08-20 16:45
legacy: true
tags: [arduino]
---

Si j'ai besoin de connaître la taille et la demande en RAM de mes
programmes Arduino, comment je fais ? Et puis d'abord pourquoi je voudrais
connaître leur taille ?

{% img center /images/640-arduino-avr.jpg %}

<!-- more -->

## Où se cache le programme

Le programme au format elf se trouve dans un dossier caché. Vous pouvez
constater que sa taille est assez conséquente. Ce n'est pas du tout sa taille
finale pour l'Arduino.

{% highlight bash %}
$ \ls -lh .build/uno/firmware.elf 
-rwxr-xr-x 1 xavier xavier 40K août  19 21:01 .build/uno/firmware.elf
{% endhighlight %}

*Un dossier caché est un dossier dont le nom commence par un point. On dit
«caché» car sous Linux et OS X ils sont invisibles par défaut.*

## Comment connaître les besoins en mémoire d'un programme Arduino

C'est le programme `avr-size` qui va tout nous dire:

{% highlight bash %}
$ avr-size -dC .build/uno/firmware.elf 
AVR Memory Usage
----------------
Device: Unknown

Program:    2786 bytes
(.text + .data + .bootloader)

Data:         34 bytes
(.data + .bss + .noinit)
{% endhighlight %}

J'utilise 34 octets de RAM et 2786 octets au total.

Le switch `-d` fournit les valeurs en décimal. Le switch `-C` spécifie le
format du rapport de `avr-size` (`$ avr-size --help` pour voir les autres).

## Pourquoi faire

Les micro contrôleurs ATMEL ont des tailles de mémoire
différentes (mémoire vive et mémoire programme). Par exemple l'ATtiny13 possède 1 Ko pour le programme et 64 octets
de RAM, tandis que le ATtiny85 fait 8 Ko pour le programme et 512 octets pour
la RAM.

Pour les programmes qui sont destinés à quitter la plateforme Arduino pour
rejoindre un micro contrôleur, connaître la taille mémoire permet de savoir
si il est intéressant de passer du temps et de l'énergie à *optimiser* ces
programmes.

