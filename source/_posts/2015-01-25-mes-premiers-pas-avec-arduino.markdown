---
layout: post
title: "Mes premiers pas avec Arduino"
date: 2015-01-25 18:04
comments: true
categories: [matériel, arduino]
---

{% level 1 %}

Ça faisait un ou deux ans que l'envie me titillait. Jouer avec Arduino,
Raspberry Pi, etc. Mais essentiellement par manque de temps, je n'avais pas
encore franchi le pas. Et puis dernièrement, on m'a offert le
[Starter Kit Arduino](http://arduino.cc/en/Main/ArduinoStarterKit). Plus de faux pretextes, je devais m'y mettre ;)

{% img center /images/projet-1-paral.jpg %}

<!-- more -->

## Les premiers projets du bouquin

Le premier projet pose les très grandes bases de l'éléctricité. Tu apprends
à allumer une LED avec un ou deux boutons, en série puis en parallèle.
Tu révises aussi la [loi d'Ohm](http://fr.wikipedia.org/wiki/Loi_d%27Ohm):

**_V = R x I_**

Avec **V** pour voltage (mesuré en volts), **R** pour résistance (mesuré en ohms)
et **I** pour intensité (mesuré en ampères). J'avais appris cette loi au lycée
sous la forme U = RxI,
en français le **V** devient donc **U**, pour des raisons de normalisation de
l'AFNOR.

Dans le second projet, tu allumes plusieurs LEDs, avec un peu de code pour les
faire clignoter. Pour le troisième projet, toujours des LEDs à allumer mais
cette fois-ci à l'aide d'un détecteur de chaleur.

Le quatrième projet te propose devine quoi ? Gagné ! il te propose d'allumer
une LED, cette fois en la contrôlant avec des photo-résistances:

{% img center /images/projet-4.jpg %}

## L'environnement de développement

Arduino est aussi un IDE, dans lequel tu tapes du code, avec lequel tu compiles
tes programmes arduino, etc. Mais comment te dire, quand tu es habitué à bosser
avec autre chose (Vim dans mon cas), tu n'imagines pas une seconde devoir
utiliser cet IDE Arduino.

J'ai trouvé [ino](http://inotool.org) qui permet de travailler en console, c'est parfait pour moi.
Pour pouvoir installer ino, il faut le gestionnaire de package `pip` pour
Python.

Pour installer (et comprendre) pip:
[Sam et Max - Votre python aime les pip](http://sametmax.com/votre-python-aime-les-pip/).

Pour ensuite installer ino: [inotool.org](http://inotool.org/).

Maintenant vous avez accès à ces commandes:

    ino init
    ino build
    ino upload
    ino serial # C-A C-X pour sortir ?

Le fichier qui nous intéresse, celui où l'on va écrire notre code, est créé
par `ino init`. C'est le fichier `src/sketch.ino`.

    $ tree
    .
    ├── lib
    └── src
        └── sketch.ino

Pour finir, si vous avez besoin d'un fichier de syntaxe pour Vim, c'est ici:
[sudar/vim-arduino-syntax](https://github.com/sudar/vim-arduino-syntax).

Vivement les prochains projets, qui vont me faire contrôler des servo-moteurs,
produire de la musique, etc. Parce que j'en ai un peu marre d'allumer des
LEDs ;)

{% connexe %}
