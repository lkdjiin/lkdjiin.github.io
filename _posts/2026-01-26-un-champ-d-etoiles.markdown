---
layout: post
title: "Un champ d'étoile sans nombres aléatoires"
date: 2026-01-26 10:00
comments: true
tags: [ commodore, c64, assembleur, 6502 ]
---

S'il y a bien un truc où j'aurai parier devoir utiliser des nombres aléatoires
en veut-tu en voilà, c'est bien pour la réalisation d'un _star field_.
Vous savez, les petites étoiles qui défilent en arrière-plan dans les vieux
_shoot them up_ du style Galaga.
Et pourtant, en lisant le bouquin «retro game dev» de Derek Morris je me suis
aperçu qu'on pouvait faire un champ d'étoiles sans tirer un seul
nombre au hasard (ou presque).

J'en ai déjà réalisé des _star fields_. En BASIC, en C, en Java, en Ruby, etc.
Si on m'avait demandé comment faire ça il y a 3 jours, j'aurais sûrement répondu
à peu près ceci :

- on tire une position X au hasard
- on tire une couleur au hasard
- on tire une vitesse au hasard
- en on fait bouger cette étoile de haut en bas de l'écran
- finalement on recommence

Mais on peut faire sans l'intervention du hasard.

Vous trouverez [le code sur github](https://github.com/lkdjiin/short-c64-demos/blob/main/starfield.asm).

<!-- more -->


## Une étoile

Tout d'abord il me faut des caractères qui représenterons les étoiles.
Une étoile sera tout bonnement un pixel. Comme les caractères du Commodore 64 ont
une taille de 8x8 pixels, on utilisera 8 caractères, chacun à une hauteur
différente. Autrement dit il y aura un premier caractère comme ceci :

    ...x....
    ........
    ........
    ........
    ........
    ........
    ........
    ........

Un second comme celui-là :

    ........
    ...x....
    ........
    ........
    ........
    ........
    ........
    ........

Et ainsi de suite jusqu'au huitième :

    ........
    ........
    ........
    ........
    ........
    ........
    ........
    ...x....

Ainsi on pourra enchaîner les 8 caractères au même endroit de l'écran avant de
passer à la rangée inférieure. On pourra de cette manière faire passer une étoile
sur chaque pixels de haut en bas de l'écran.

Mais j'ai la flemme de créer un jeu
de caractères complet. Je vais donc aller au plus rapide en créant seulement les 8 _frames_ des étoiles, plus l'espace.
Les 8 caractères pour l'étoile seront aux 8 premières places du jeu de caractères.
Et l'espace sera à sa place standard (la 32ème) pour pouvoir utiliser la
routine CLS du système (effacement de l'écran).


    .const MEMORY_SETUP = $d018
    .const VRAM = $0400
    .const BORDER = $d020
    .const BACKGROUND = $d021
    .const COLOR = $286
    .const CLS = $e544

    BasicUpstart2(start)

    start:
      lda #BLACK
      sta BACKGROUND
      sta BORDER
      lda #WHITE
      sta COLOR
      jsr CLS

      // Ça c'est pour dire où trouver le jeu de caractère.
      lda MEMORY_SETUP
      and #%11110000
      ora #%00001100
      sta MEMORY_SETUP

      // Pour l'exemple, j'affiche les 8 caractères étoile en haut à
      // gauche.
      ldx #0
    loop:
      txa
      sta VRAM,x
      inx
      cpx #8
      bne loop

      jmp *

    // Les 8 caractères sont ici, à partir de l'adresse $3000
    *=$3000
    .byte %00010000,0,0,0,0,0,0,0
    .byte 0,%00010000,0,0,0,0,0,0
    .byte 0,0,%00010000,0,0,0,0,0
    .byte 0,0,0,%00010000,0,0,0,0
    .byte 0,0,0,0,%00010000,0,0,0
    .byte 0,0,0,0,0,%00010000,0,0
    .byte 0,0,0,0,0,0,%00010000,0
    .byte 0,0,0,0,0,0,0,%00010000
    // Et l'espace est ici
    *=$3000+32*8
    .byte 0,0,0,0,0,0,0,0

{% img center /images/starfield01.png %}

## Une étoile animée

Je vais faire défiler les 8 _frames_, en restant toujours sur le
caractère en haut à gauche de l'écran. C'est histoire de s'assurer que mon
"animation" est bonne. Comme c'est de l'assembleur, il y a tout de suite
beaucoup trop de code.


    BasicUpstart2(start)

    .const MEMORY_SETUP = $d018
    .const VRAM = $0400
    .const BORDER = $d020
    .const BACKGROUND = $d021
    .const COLOR = $286
    .const CLS = $e544

    .const OFFSET_MAX = 8
    .const SPEED = 10

    star_x: .byte 0
    star_y: .byte 0
    star_offset: .byte 0
    star_speed: .byte SPEED // plus c'est petit, plus c'est lent

    start:
      jsr init_screen
      jsr init_characters

    loop:
      Wait()
    speed:
      dec star_speed
      bne loop
      lda #SPEED
      sta star_speed
    calculate:
      inc star_offset
      lda star_offset
      cmp #OFFSET_MAX
      bne display
      lda #0
      sta star_offset
    display:
      ldx star_x
      sta VRAM,x

      jmp loop

    // ---------------------------------------------------------------------
    init_screen: {
      lda #BLACK
      sta BACKGROUND
      sta BORDER
      lda #WHITE
      sta COLOR
      jmp CLS // jsr CLS ; rts
    }

    // ---------------------------------------------------------------------
    init_characters: {
      lda MEMORY_SETUP
      and #%11110000
      ora #%00001100
      sta MEMORY_SETUP
      rts
    }

    // ---------------------------------------------------------------------
    .macro Wait() {
    wait:
      lda #255
      cmp $d012 // RASTER_LINE
      bne wait
    }

    *=$3000
    .byte %00010000,0,0,0,0,0,0,0
    .byte 0,%00010000,0,0,0,0,0,0
    .byte 0,0,%00010000,0,0,0,0,0
    .byte 0,0,0,%00010000,0,0,0,0
    .byte 0,0,0,0,%00010000,0,0,0
    .byte 0,0,0,0,0,%00010000,0,0
    .byte 0,0,0,0,0,0,%00010000,0
    .byte 0,0,0,0,0,0,0,%00010000
    *=$3000+32*8
    .byte 0,0,0,0,0,0,0,0

{% img center /images/starfield02.gif %}

## Une étoile qui bouge de haut en bas

On peut maintenant s'occuper de faire tomber une seule étoile. Le code n'est pas
du tout optimisé, mais ce n'est pas son propos puisqu'il est seulement un
"passage" vers la suite.


    BasicUpstart2(start)

    .const MEMORY_SETUP = $d018
    .const VRAM = $0400
    .const BORDER = $d020
    .const BACKGROUND = $d021
    .const COLOR = $286
    .const CLS = $e544

    .const SPACE_CHAR = 32
    .const OFFSET_MAX = 8
    .const SPEED = 2

    screen_rows_lsb:
      .byte <VRAM, <VRAM+40, <VRAM+80, <VRAM+120, <VRAM+160, <VRAM+200
      .byte <VRAM+240, <VRAM+280, <VRAM+320, <VRAM+360, <VRAM+400, <VRAM+440
      .byte <VRAM+480, <VRAM+520, <VRAM+560, <VRAM+600, <VRAM+640, <VRAM+680
      .byte <VRAM+720, <VRAM+760, <VRAM+800, <VRAM+840, <VRAM+880, <VRAM+920
      .byte <VRAM+960
    screen_rows_msb:
      .byte >VRAM, >VRAM+40, >VRAM+80, >VRAM+120, >VRAM+160, >VRAM+200
      .byte >VRAM+240, >VRAM+280, >VRAM+320, >VRAM+360, >VRAM+400, >VRAM+440
      .byte >VRAM+480, >VRAM+520, >VRAM+560, >VRAM+600, >VRAM+640, >VRAM+680
      .byte >VRAM+720, >VRAM+760, >VRAM+800, >VRAM+840, >VRAM+880, >VRAM+920
      .byte >VRAM+960

    .const STAR_PTR = $f0
    star_x: .byte 0
    star_y: .byte 0
    star_offset: .byte 0
    star_speed: .byte SPEED

    start:
      jsr init_screen
      jsr init_characters

    loop:
      Wait()
    speed:
      dec star_speed
      bne loop
      lda #SPEED
      sta star_speed
    calculate:
      inc star_offset
      lda star_offset
      cmp #OFFSET_MAX
      bne display
    delete:
      ldx star_y
      lda screen_rows_lsb,x
      sta STAR_PTR
      lda screen_rows_msb,x
      sta STAR_PTR+1
      ldy star_x
      lda #SPACE_CHAR
      sta (STAR_PTR),y
    reset_offset:
      lda #0
      sta star_offset
      inc star_y
      lda star_y
      cmp #25
      bne display
      lda #0
      sta star_y
    display:
      ldx star_y
      lda screen_rows_lsb,x
      sta STAR_PTR
      lda screen_rows_msb,x
      sta STAR_PTR+1
      ldy star_x
      lda star_offset
      sta (STAR_PTR),y

      jmp loop

    // ---------------------------------------------------------------------
    init_screen: {
      lda #BLACK
      sta BACKGROUND
      sta BORDER
      lda #WHITE
      sta COLOR
      jmp CLS // jsr CLS ; rts
    }

    // ---------------------------------------------------------------------
    init_characters: {
      lda MEMORY_SETUP
      and #%11110000
      ora #%00001100
      sta MEMORY_SETUP
      rts
    }

    // ---------------------------------------------------------------------
    .macro Wait() {
    wait:
      lda #255
      cmp $d012 // RASTER_LINE
      bne wait
    }

    *=$3000
    .byte %00010000,0,0,0,0,0,0,0
    .byte 0,%00010000,0,0,0,0,0,0
    .byte 0,0,%00010000,0,0,0,0,0
    .byte 0,0,0,%00010000,0,0,0,0
    .byte 0,0,0,0,%00010000,0,0,0
    .byte 0,0,0,0,0,%00010000,0,0
    .byte 0,0,0,0,0,0,%00010000,0
    .byte 0,0,0,0,0,0,0,%00010000
    *=$3000+32*8
    .byte 0,0,0,0,0,0,0,0

{% img center /images/starfield03.gif %}

## 40 étoiles qui tombent en même temps

Le bouquin nous dit d'afficher une étoile dans chaque colonne. Quand j'ai lu ça
je me suis dit que c'était impossible que ça semble aléatoire. Et pourtant ça
le fera très bien par la suite, quand nous nous serons occupé d'avoir
différentes vitesses, couleurs, et positions de départ.

En attendant on va faire ça sans trop réfléchir : 40 étoiles, une par colonne.


    BasicUpstart2(start)

    .const MEMORY_SETUP = $d018
    .const VRAM = $0400
    .const BORDER = $d020
    .const BACKGROUND = $d021
    .const COLOR = $286
    .const CLS = $e544

    .const SPACE_CHAR = 32
    .const OFFSET_MAX = 8
    .const SPEED = 1
    .const STAR_PTR = $f0
    .const TOTAL_OF_STARS = 40

    screen_rows_lsb:
      .byte <VRAM, <VRAM+40, <VRAM+80, <VRAM+120, <VRAM+160, <VRAM+200
      .byte <VRAM+240, <VRAM+280, <VRAM+320, <VRAM+360, <VRAM+400, <VRAM+440
      .byte <VRAM+480, <VRAM+520, <VRAM+560, <VRAM+600, <VRAM+640, <VRAM+680
      .byte <VRAM+720, <VRAM+760, <VRAM+800, <VRAM+840, <VRAM+880, <VRAM+920
      .byte <VRAM+960
    screen_rows_msb:
      .byte >VRAM, >VRAM+40, >VRAM+80, >VRAM+120, >VRAM+160, >VRAM+200
      .byte >VRAM+240, >VRAM+280, >VRAM+320, >VRAM+360, >VRAM+400, >VRAM+440
      .byte >VRAM+480, >VRAM+520, >VRAM+560, >VRAM+600, >VRAM+640, >VRAM+680
      .byte >VRAM+720, >VRAM+760, >VRAM+800, >VRAM+840, >VRAM+880, >VRAM+920
      .byte >VRAM+960

    star_current: .byte 0
    stars_row: .fill TOTAL_OF_STARS, 0
    stars_column: .fill TOTAL_OF_STARS, i
    stars_offset: .fill TOTAL_OF_STARS, 0
    // higher is slower
    stars_speed: .fill TOTAL_OF_STARS, SPEED

    start:
      jsr init_screen
      jsr init_characters

    main_loop:
      Wait()
    star_loop:
      // X will hold current star index throughout the algorithm.
      ldx star_current
    speed:
      dec stars_speed,x
      bne next_star
      lda #SPEED
      sta stars_speed,x
    calculate:
      inc stars_offset,x
      lda stars_offset,x
      cmp #OFFSET_MAX
      bne display
    delete:
      ldy stars_row,x
      lda screen_rows_lsb,y
      sta STAR_PTR
      lda screen_rows_msb,y
      sta STAR_PTR+1
      ldy stars_column,x
      lda #SPACE_CHAR
      sta (STAR_PTR),y
    reset_offset:
      lda #0
      sta stars_offset,x
      inc stars_row,x
      lda stars_row,x
      cmp #25
      bne display
      lda #0
      sta stars_row,x
    display:
      ldy stars_row,x
      lda screen_rows_lsb,y
      sta STAR_PTR
      lda screen_rows_msb,y
      sta STAR_PTR+1
      ldy stars_column,x
      lda stars_offset,x
      sta (STAR_PTR),y
    next_star:
      inc star_current
      lda star_current
      cmp #TOTAL_OF_STARS
      bne star_loop
      lda #0
      sta star_current

      jmp main_loop

    // ---------------------------------------------------------------------
    init_screen: {
      lda #BLACK
      sta BACKGROUND
      sta BORDER
      lda #WHITE
      sta COLOR
      jmp CLS // jsr CLS ; rts
    }

    // ---------------------------------------------------------------------
    init_characters: {
      lda MEMORY_SETUP
      and #%11110000
      ora #%00001100
      sta MEMORY_SETUP
      rts
    }

    // ---------------------------------------------------------------------
    .macro Wait() {
    wait:
      lda #255
      cmp $d012 // RASTER_LINE
      bne wait
    }

    *=$3000
    .byte %00010000,0,0,0,0,0,0,0
    .byte 0,%00010000,0,0,0,0,0,0
    .byte 0,0,%00010000,0,0,0,0,0
    .byte 0,0,0,%00010000,0,0,0,0
    .byte 0,0,0,0,%00010000,0,0,0
    .byte 0,0,0,0,0,%00010000,0,0
    .byte 0,0,0,0,0,0,%00010000,0
    .byte 0,0,0,0,0,0,0,%00010000
    *=$3000+32*8
    .byte 0,0,0,0,0,0,0,0

{% img center /images/starfield04.gif %}

## Des nombres aléatoires quand même …

… Oui, mais dans une table ;) On va mettre des positions de départ différentes
pour chaque étoile. Soit vous le faites sans outils, mais il faut bien être
conscient que le cerveau humain est très mauvais pour produire de l'aléatoire.
Soit vous utilisez un langage quelconque pour sortir 40 nombres compris entre 0 et 24.
Voici par exemple un _one liner_ en ruby :

{% highlight ruby %}
40.times { print "#{(0..24).to_a.sample},"}
{% endhighlight %}

Et notre table conservant les rangées des 40 étoiles devient :

    stars_row: .byte 2,20,22,23,0,14,3,7,8,22,18,15,15,17,19,14,15,0,2,7,8,5,15,3,13,15,8,13,1,21,2,0,11,5,9,22,17,13,2,2

Ça devient intéressant à l'écran, même si on repère facilement des patterns qui reviennent.

{% img center /images/starfield05.gif %}


## Les dernières touches

Ce qui m'a achevé dans ce bouquin, c'est la manière de gérer la vitesse et la couleur
des étoiles. D'abord, c'est la même chose. Un même nombre (de 1 à 4) représente **et** la
couleur, **et** la vitesse. C'est simple. C'est intelligent. C'est pratique.
Et à chaque tour, la vitesse/couleur est modifiée avec un simple incrément.
Encore une fois je me suis dit en lisant ça qu'il était _impossible_ que ça
paraisse aléatoire. Et pourtant, dans le feu de l'action, quand vous devez
exploser les vaisseaux ennemis, ça fonctionne parfaitement.


D'abord des vitesses différentes :

    // higher is slower
    stars_speed: .byte 2,3,1,1,2,4,2,4,2,1,2,4,4,1,2,4,3,4,3,3,4,2,3,1,4,4,1,4,1,1,4,2,4,1,4,4,4,4,2,3
    stars_delay: .byte 2,3,1,1,2,4,2,4,2,1,2,4,4,1,2,4,3,4,3,3,4,2,3,1,4,4,1,4,1,1,4,2,4,1,4,4,4,4,2,3

    speed:
      dec stars_delay,x
      bne next_star
      lda stars_speed,x
      sta stars_delay,x

{% img center /images/starfield06.gif %}


Puis on ajoute la couleur :

    display:
      [ ... ]
      // Ajouter $d4 pour mémoire couleur
      clc
      lda STAR_PTR+1
      adc #$d4
      sta STAR_PTR+1
      // Écrire la couleur
      lda stars_speed,x
      sta (STAR_PTR),y
    next_star:

{% img center /images/starfield07.gif %}

Et finalement on fait varier à chaque tour :


    .const SPEED_MIN = 1
    .const SPEED_MAX = 4

    reset_offset:
      [ ... ]
      inc stars_speed,x
      lda stars_speed,x
      cmp #(SPEED_MAX+1)
      bne no_speed_reset
      lda #SPEED_MIN
    no_speed_reset:
      sta stars_speed,x
    display:

Avec un rendu plus proche des écrans CRT d'époque :

{% img center /images/starfield08.gif %}
