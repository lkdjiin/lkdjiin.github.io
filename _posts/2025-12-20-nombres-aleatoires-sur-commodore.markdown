---
layout: post
title: "Nombres aléatoires en assembleur sur le Commodore 64"
date: 2025-12-20 8:00
comments: true
tags: [ commodore, c64, assembleur, aléatoire, 6502, 6510 ]
---

Comment obtenir un nombre aléatoire en assembleur sur une machine rétro 8 bits ?
En l'occurence ici, un Commodore 64 et son processeur 6510.
Et aléatoire ou pseudo-aléatoire ? C'est quoi la différence ?

Certaines des méthodes abordées seront spécifiques au C64, d'autres s'appliqueront à
tout les systèmes à base de 6502/6510.

## Aléatoire et pseudo-aléatoire

La différence existe.

Aléatoire : l'image classique est la radio-activité. On n'a aucun moyen de
prédire quand un atome se désintègrera. On sait seulement que ça arrivera.
Il n'y a pas de relation entre deux désintegrations successives.

Pseudo-aléatoire : on veut que ça ressemble le plus possible à de l'aléatoire.
Mais ce serait bien aussi si c'était reproductible, parce que c'est utile pour
débuguer ou mettre au point des programmes. Une même «graine» produira toujours
la même suite de nombres. Cette suite semblera aléatoire pour nous autres
humains. Mais si on connait l'algorithme, on trouve le nombre suivant.

<!-- more -->

## Critères

Je vais donner une note aux méthodes que je présenterais. Mais gardez en tête
que je ne suis pas du tout expert dans ce domaine. Je peux me tromper, alors
n'hésitez pas à me corriger si nécessaire.

Pour rappel, je ne m'intéresse qu'à la production de nombres 8 bits.

**Vitesse (Nombre de cycles pour obtenir un nombre)**

Les ordinateurs 8 bits sont lents. Pour écrire des jeux d'actions on a besoin de
résultats rapides.

**Taille (Nombre d'octets en mémoire de la routine)**

L'ordinateur sur lequel j'écris ces lignes possède 524 288 fois plus de RAM que
le Commodore 64. Et le C64 était bien fourni en comparaison d'autres machines
de son époque. Quand certains ordinateurs n'affichait que quelques kilo-octets,
on pouvait dire que «chaque octet compte».

**Qualité**

C'est sur la qualité que j'aurai le plus de mal à juger. Est-ce qu'une suite de
nombre me semble aléatoire ou pas. Il y aura une part de subjectivité, mais je
ferai avec.

Vitesse, taille, et qualité, seront notées sur 5, pour une note globale sur 15.
Parce que, pourquoi pas ;)

Pour alléger les listings, je vais omettre systématiquement les 4 premières lignes :

~~~
BasicUpstart2(start)
.const LINPRT = $bdcd // X - Low byte // A - High byte
.const CHROUT = $ffd2
counter: .byte 10
~~~

Explications :

`BasicUpstart2(start)` — C'est une macro fournit par l'assembleur KickAssembler
et qui permet de sortir un programme directement utilisable par le C64.

`LINPRT` — C'est une fonction du BASIC du C64 qui affiche un nombre 16 bits (il
n'y a rien pour afficher un nombre 8 bits). Il faut donner l'octet de poid fort
dans le registre A et l'octet de poid faible dans le registre X.

`CHROUT` — Une autre fonction du BASIC. Celle-ci affiche un caractère donné dans
le registre A. On l'utiliser avec le caractère n°13, le retour à la ligne.

`counter` — Il sera utilisé pour afficher 10 nombres dans une boucle.



## Lecture du registre Jiffy

    Vitesse : 5
    Taille  : 5
    Qualité : 0
    Total   : 10

Le jiffy est une horloge du C64 qui compte le temps qui passe. Donc pour que ça
semble aléatoire, on repassera.

~~~
start:
  lda #0
  ldx $a2    // JIFFY

  jsr LINPRT
  lda #13
  jsr CHROUT
  dec counter
  bne start
  rts
~~~

**Résultat : 68, 69, 69, 70, 70, 71, 71, 72, 73, 73**

Si vous avez besoin d'un nombre aléatoire toutes les quelques minutes, pourquoi
pas.

## Lecture du registre Raster

    Vitesse : 5
    Taille  : 5
    Qualité : 0
    Total   : 10

Sur le Commodore 64 une interruption est générée chaque fois que le matériel a
affiché une ligne de pixel sur l'écran. Il y a 256 lignes, et le tout est fait
50 ou 60 fois par minute.

~~~
start:
  lda #0
  ldx $d012  // RASTER LINE

  jsr LINPRT
  lda #13
  jsr CHROUT
  dec counter
  bne start
  rts
~~~

**Résultat : 5, 154, 40, 128, 22, 109, 4, 95, 244, 70**

Pourquoi 0 en qualité alors que ça semble bien ? Parce que dans un
programme réel on lira souvent le registre _raster_ depuis une interruption.
Alors même que cette interruption aura était générée quand le _raster_ a
atteint un nombre précis. On risque alors d'obtenir des nombres aléatoires qui
seront toujours plus ou moins les mêmes.

## Kernal RND

    Vitesse : 0
    Taille  : 5
    Qualité : 5
    Total   : 10

La fonction BASIC qui génère un nombre aléatoire se trouve à l'adresse `$e097`
et on peut tout à fait l'utiliser en assembleur.

~~~
start:
  jsr $e097 // RND
  lda #0
  ldx $008e // Une partie du résultat est ici

  jsr LINPRT
  lda #13
  jsr CHROUT
  dec counter
  bne start
  rts
~~~

**Résultat : 126, 200, 4, 11, 29, 163, 179, 16, 54, 151**

Je ne suis pas (encore) parvenu à changer la graine de l'algo. J'ai donc encore et toujours
la même série de nombre qui sort.
Mais le vrai point noir c'est la vitesse. J'ai voulu m'en servir sur un petit jeu sur
lequel je travaille et cela le ralentissait trop. Et en fait c'est normal, la
fonction BASIC fait beaucoup de choses. C'est un nombre à virgule qu'elle produit ;
elle s'occupe aussi de la gestion d'erreurs. Voir [RND()](https://www.pagetable.com/c64ref/c64disasm/#E097).
Il faut aussi penser qu'on
n'a pas toujours accès au BASIC. On peut l'avoir désactiver pour récupérer la
RAM.

## SID voix 3

    Vitesse : 5
    Taille  : 5
    Qualité : 5
    Total   : 15

Le SID est le processeur qui génère de la musique sur le Commodore 64.
On peut se servir d'un générateur de bruit blanc sur la 3ème voix —
_la seule accessible en lecture_ — pour obtenir un générateur de nombre rapide
et de qualité.

~~~
start:
  lda #$ff
  sta $d40f // Voix 3 : octet MSB de la fréquence
  lda #$80
  sta $d412 // Activer le bruit blanc

loop:
  lda #0
  ldx $d41b // Sortie de l'oscillateur
  jsr LINPRT
  lda #13
  jsr CHROUT
  dec counter
  bne loop
  rts
~~~

**Résultat : 254, 201, 31, 151, 184, 62, 254, 16, 143, 177**

Il est malheureusement impossible de reproduire la même série puisque
l'oscillateur produit constamment.
Et surtout, il est quand même très dommage de se priver d'une des trois voix
musicales.

## Générateur de Galois

    Vitesse : 4
    Taille  : 5
    Qualité : 1
    Total   : 10

C'est une méthode bien connue sur les processeurs 8 bits, mais vraiment pas
terrible niveau qualité. Vous trouverez les détails ici
[registre à décalage à rétroaction linéaire](https://fr.wikipedia.org/wiki/Registre_%C3%A0_d%C3%A9calage_%C3%A0_r%C3%A9troaction_lin%C3%A9aire)
et là [6502 8 bit PRNG](http://www.6502.org/users/mycorner/6502/code/prng.html)

~~~
start:
  jsr rand_8
  tax
  lda #0

  jsr LINPRT
  lda #13
  jsr CHROUT
  dec counter
  bne start
  rts

rand_8:
  lda r_seed // get seed
  asl        // shift byte
  bcc no_eor // branch if no carry
  eor #$cf   // else EOR with $cf
no_eor:
  sta r_seed // save number as next seed
  rts

r_seed: .byte 123 // prng seed byte, must not be zero
~~~

**Résultat : 246, 35, 70, 140, 215, 97, 194, 75, 150, 22700**

Cet algo a son utilité si on dispose de très peu de place.
Notez qu'on ne peut jamais obtenir 0.

## Micrornd

    Vitesse : 4
    Taille  : 4
    Qualité : 4
    Total   : 12

Cette autre méthode me convient très bien avec sa balance entre vitesse, taille
et qualité. Vous pouvez lire les explications ici si vous le souhaitez
[Micrornd](https://inglorion.net/software/micrornd/).

~~~
start:
  jsr micrornd
  ldx micrornd_state
  lda #0

  jsr LINPRT
  lda #13
  jsr CHROUT
  dec counter
  bne start
  rts

micrornd:
  lda micrornd_state + 1
  eor micrornd_state + 3
  sta micrornd_state + 1
  inc micrornd_state + 3
  lda micrornd_state + 1
  asl
  eor #$d5
  adc micrornd_state + 2
  sta micrornd_state + 1
  lda micrornd_state + 2
  adc #1
  sta micrornd_state + 2
  lda micrornd_state
  adc micrornd_state + 1
  sta micrornd_state
  rts

micrornd_state: .byte 0, 1, 2, 3
~~~

**Résultat : 211, 82, 119, 15, 1, 42, 199, 204, 160, 18**

C'est la méthode que j'utilise maintenant par défaut.

## Tables pré-calculées

    Vitesse : 5
    Taille  : 0
    Qualité : 4
    Total   : 9

Si on dispose de place, on peut utiliser avantageusement des tables pré-calculées.
On remplit une table de 256 valeurs aléatoires. Puis on va simplement les
chercher dans l'ordre. Quand l'index arrive au bout, à 256, il revient à 0 grâce
à la magie du binaire.

~~~
start:
  ldy index
  ldx table,y
  inc index
  lda #0

  jsr LINPRT
  lda #13
  jsr CHROUT
  dec counter
  bne start
  rts

index: .byte 0
table: .byte 34, 65, 33, 98, 0, 127, 76, 12, 20, 245 // etc, 256 valeurs
~~~

L'inconvénient, bien sûr, est qu'il faut de la mémoire. Peut-être beaucoup
de mémoire car on voudra
parfois disposer de plusieurs tables différentes. La qualité n'est que de 4,
parce qu'arrivé au bout des 256 nombres, on recommence avec les même.

Le gros avantage de cette méthode est la rapidité. Non seulement on obtient une
valeur très vite, mais en plus on peut pré-calculer absolument tout
ce qu'on veut. On n'est pas obligé de s'arrêter aux nombres aléatoires eux-mêmes ;
on peut aussi s'occuper des traitements qui suivent presque toujours.
Par exemple si on veut simuler un lancer de dé, on pourra stocker
uniquement des valeurs de 1 à 6.
