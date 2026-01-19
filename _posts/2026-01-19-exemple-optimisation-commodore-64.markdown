---
layout: post
title: "Exemple d'optimisation assembleur sur Commodore 64"
date: 2026-01-19 8:00
comments: true
tags: [ commodore, c64, assembleur, optimisation, 6502, 6510 ]
---

En cherchant des bouts de code à propos de tout et de rien pour Commodore 64, je suis tombé sur un tutoriel
montrant l'effet _color wash_. Je ne sais pas si c'est le nom usuel, ni même si
cet effet à un nom spécial, mais c'est comme ça que l'auteur du tutoriel l'appelle.
C'est donc comme ça que je vais l'appeler.

Vous pouvez voir l'effet en question sur youtube : https://www.youtube.com/watch?v=iUVFHxnvabM
Et vous trouverez le code original sur github :
https://github.com/actraiser/dust-tutorial-c64-first-intro/blob/master/code/sub_colorwash.asm

Je voulais étudier cet effet en détail, mais la lecture du code ne m'a
pas été très utile pour comprendre du mieux possible comment ça fonctionnait.
J'ai donc chercher à le refaire par moi-même et ensuite à l'optimiser si possible.
Et ça a été possible ;)

Mon code sur github (seulement l'effet visuel, pas de musique) : [colorwash](https://github.com/lkdjiin/short-c64-demos/blob/main/colorwash.asm)

<!-- more -->



## Dans un sens…

Dans un premier temps je me concentre sur une seule ligne de texte, l'effet se déplaçant
de droite à gauche. Pour comprendre ce qu'il faut faire, je trouve
souvent qu'un peu de pseudo-code m'est d'une grande aide.
On a donc un tableau rempli de **N** couleurs. On a aussi **LIGNE**, qui est l'adresse
du texte dans la _color RAM_ du C64 :

    couleur = [1,1,2,9,7,2,...,N]

Le but est de faire une rotation de chaque case du tableau couleur, et une
rotation identique en _color RAM_ :

    temp = couleur[0]
    pour i = 1 à N-1
        c = lire couleur[i]
        couleur[i-1] = LIGNE[i-1] = c
    couleur[N-1] = temp

Après m'être convaincu que ça marche en faisant tourner ce pseudo-code dans ma tête,
je le transforme en assembleur 6502 :

      lda color
      sta temp
      ldx #0
    loop:
      lda color+1,x
      sta color,x
      sta COLOR_LINE_1,x
      inx
      cpx #39
      bne loop
      lda temp
      sta color+39

Pour bien comprendre, sachez que `COLOR_LINE_1` est l'adresse de la première
ligne de texte en _color RAM_, et que `color` est le tableau de 40 couleurs :

    .const COLOR_LINE_1 = $d990

    color:
    .byte 9,9,2,2,8,8,10,10,15,15,7,7,1,1,1,1,1,1,1,1
    .byte 1,1,1,1,1,1,1,1,7,7,15,15,10,10,8,8,2,2,9,9

## …puis dans l'autre

Maintenant je travaille sur l'effet de gauche à droite.
L'idée est de faire l'inverse du premier algo.
Voici le pseudo-code :

    longueur = longueur du tableau de couleur
    temp = couleur[39]
    pour i = longueur-1 à 1
        c = lire couleur[i-1]
        couleur[i] = LIGNE[i] = c
    couleur[0] = temp

Et le voici en assembleur :

      lda color2+39
      sta temp2
      ldx #39
    first_line:
      lda color2-1,x
      sta color2,x
      sta COLOR_LINE_2,x
      dex
      cpx #0 // inutile, mais fait le parallèle avec l'autre
      bne first_line
      lda temp2
      sta color2

Techniquement l'instruction `cpx #0` est inutile dans ce sens de rotation. Mais
je la fait apparaître pour accentuer la similarité des deux algorithmes.

J'ai donc fini par obtenir plus ou moins la même chose que le code original. J'ai
le même nombre d'instructions, même si j'utilise deux variables temporaires qui
ne sont pas nécessaire dans la version d'origine de l'auteur. Mais j'avais ma petite idée derrière la
tête pour faire cela et on va le voir tout de suite.

## Maintenant je vais tenter de combiner les deux boucles

Les deux algos n'utilisent que deux registres du 6502. On pourrait donc remplacer
le registre X par le registre Y dans l'un ou l'autre des algos, ce qui
va grandement faciliter la combinaison.

      lda color+39
      sta temp
      lda color2
      sta temp2

      ldy #39
      ldx #0
    lines:
      lda color-1,y
      sta color,y
      sta COLOR_LINE_1,y
      lda color2+1,x
      sta color2,x
      sta COLOR_LINE_2,x
      inx
      dey
      bne lines

      lda temp
      sta color
      lda temp2
      sta color2+39

On a gagné 2 ou 3 instructions, mais surtout, on a économisé pas mal de temps de
boucle.


## Finalement on utilise directement la COLOR RAM

Plutôt que d'utiliser des tables pour faire la rotation des couleurs, ne pourrait-on
pas faire tourner ces couleurs directement dans la _color ram_ ?
Histoire de gratter encore quelques instructions.

D'abord on initialise la _color ram_. On a toujours besoin d'une table pour cette
initialisation (mais une seule, non plus deux) :

      ldx #0
    lines:
      lda color,x
      sta COLOR_LINE_1,x
      sta COLOR_LINE_2,x
      inx
      cpx #40
      bne lines

Une fois cette mise en couleur initiale du texte, on peut alors intervenir
directement dans la mémoire couleur en faisant l'économie de deux instructions au passage :

      lda COLOR_LINE_1+39
      sta temp
      lda COLOR_LINE_2
      sta temp2

      ldy #39
      ldx #0
    lines:
      lda COLOR_LINE_1-1,y
      sta COLOR_LINE_1,y
      lda COLOR_LINE_2+1,x
      sta COLOR_LINE_2,x
      inx
      dey
      bne lines

      lda temp
      sta COLOR_LINE_1
      lda temp2
      sta COLOR_LINE_2+39

## Conclusion

Comme je ne me suis pas tapé tout ça juste pour le "ressenti" que c'est
effectivement optimisé, je compte les cycles utilisés dans chaque version pour
avoir une mesure objective.

Dans la version initiale on compte 836 cycles dans un sens et 758 dans l'autre
sens (car il y a un `cpx` en moins), pour un total de **1594 cycles**.

Dans ma version finale je compte seulement **1012 cycles**. Pas mal ;)

Si vous trouvez comment faire encore plus rapide, surtout n'hésitez pas à me contacter.
