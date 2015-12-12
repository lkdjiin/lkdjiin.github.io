---
layout: post
title: "Fabriquer un sablier à thé électronique"
date: 2015-10-29 14:59
comments: true
categories: [arduino, maker]
---

Voici un projet que j'avais en route depuis quelques semaines.  L'objectif était de
fabriquer mon premier «objet» grâce à l'arduino, en l'occurrence un *sablier à
thé électronique*.

{% img center /images/hourglass.jpg %}

Un quoi ? En fait il s'agit tout simplement d'un minuteur. Mais je trouve le
nom *sablier à thé électronique* bien plus évocateur ;) Quand je me fais du thé
je laisse passer 9 fois sur 10 le temps d'infusion et je me retrouve avec un
breuvage imbuvable. J'avais donc envie d'un minuteur simple avec deux boutons,
un buzzer et une LED. Un des boutons lance un décompte de 3 minutes pour le thé
vert, l'autre c'est 5 minutes pour le thé noir. À la fin ça bip bip et ça
clignote jusqu'à ce qu'on l'arrête. Du vraiment simple, quoi. Sauf que je ne
voulais pas mettre un arduino entier dans ce projet alors qu'un petit micro
contrôleur à 60 centimes pourrait faire l'affaire.

<!-- more -->

J'allais donc devoir apprendre à programmer les micro contrôleurs ATtiny de
chez Atmel. Pourquoi ceux-là ? Parce qu'ils sont proches du micro contrôleur
utilisé par l'arduino (le ATmega 328). Bref je gardais quand même un pied en
terrain connu.

J'ai d'abord créé un prototype de ce *sablier sonore* avec l'arduino, pour être
sûr que je savais comment faire. Niveau schéma ça pourrait donner quelque chose
comme ça:

{% img center /images/attiny45-step4.png %}

Au final je n'utilise qu'une seule LED, mais dans le prototype original il y en
avait deux. Et c'est en utilisant ce premier prototype que je me suis aperçu
qu'une seule LED était suffisante.

L'étape suivante fut de réaliser ce montage, et le code, pour un ATtiny45.
Pourquoi ce micro contrôleur précisément ? Parce que 1) j'en avais un dans un
tiroir, et 2) on trouve une pléthore de tutoriels pour programmer un ATtiny45
en se servant d'un arduino. Si vous n'êtes pas familier du terme,
**programmer** un micro contrôleur c'est, en gros, lui transférer son programme
depuis un ordinateur. Pour que les deux cotés communiquent, on utilise un
**programmateur**. Il y a plusieurs façons de faire ça, je voulais utiliser un
arduino comme base de programmateur pour ne rien avoir à acheter de nouveau.
Vous pouvez trouver un bon tutoriel ici:
[Program an ATtiny44/45/84/85 with Arduino](http://www.instructables.com/id/Program-an-ATtiny44458485-with-Arduino/).

Finalement, on peut se créer le programmateur assez facilement pour l'ATtiny45:

{% img center /images/hello_world_bb.png %}

Comme j'allais programmer un certain nombre de micro contrôleurs, j'ai préféré
fabriquer un shield. D'abord un temporaire:

{% img center /images/arduino-temp-shield.jpg %}

Puis finalement un définitif:

{% img center /images/arduino-shield-attiny45.jpg %}

Trop pressé de le réaliser, je me suis trompé de sens pour le socket, ce qui
explique les câbles qui passent d'un coté à l'autre, puisque je n'ai pas
voulu le dessouder. C'est pas grave et il fonctionne très bien ;)

J'étais donc capable de programmer un ATtiny45 (4K de ROM) en utilisant
l'arduino **ET** l'IDE Arduino. C'était un bon début, mais ça n'était pas
suffisant. D'abord je ne voulais pas utiliser l'IDE Arduino, mais plutôt des
outils en ligne de commande, pour des raisons de reproductibilité et d'automatisation, et ensuite
je soupçonnais que le code de mon *sablier sonore* pouvait tenir sur un
ATtiny13 qui ne posséde que 1K de ROM et est pratiquement deux fois moins cher
que l'ATtiny45.

[Lire la partie 2](/blog/2015/12/12/fabriquer-un-sablier-a-the-electronique-2/)

À suivre…

{% connexe %}
