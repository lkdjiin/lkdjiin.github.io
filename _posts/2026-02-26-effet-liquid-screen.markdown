---
layout: post
title: "L'effet liquid screen sur Commodore 64"
date: 2026-02-26 8:00
comments: true
tags: [ assembleur, 6502, C64 ]
---

{% img center /images/liquid-screen0.gif %}

J'aurais donné cher pour savoir faire ça en 1985. Mais il n'est jamais
trop tard ;)

L'essentiel est de définir au mieux l'algorithme compte tenu des limitations
techniques du Commodore 64. Je ne vais pas commenter le programme en entier.
Ce serait trop fastidieux. Je vais seulement tenter de mettre en lumière les
points-clé. Au besoin vous pouvez consulter le [code sur github](https://github.com/lkdjiin/short-c64-demos).

<!-- more -->

## Commencer doucement

Je commence par une seule colonne qui descend de un seul rang à chaque itération.

{% img center /images/liquid-screen1.gif %}

[main_g1_c1.asm](https://github.com/lkdjiin/short-c64-demos/blob/main/liquid-screen-extra/main_g1_c1.asm)

On se souvient que l'écran du C64 mesure 40 colonnes sur 25 lignes,
notées de 0 à 39 et de 0 à 24.
On s'occupe uniquement de la colonne `current_column`, peu importe celle que
vous choisissez. La recette est la suivante :

- Le caractère de la ligne 23 remplace celui de la ligne 22.
- Le caractère de la ligne 22 remplace celui de la ligne 21.
- [...]
- Le caractère de la ligne 0 remplace celui de la ligne 1.
- Pour finir on efface le caractère de la ligne 0.

Je démarre par quelques constantes.

{% highlight asm %}
.const SOURCE = $f7
.const DEST = $f9
.const VRAM = $0400
.const SCREEN_WIDTH = 40
.const SCREEN_HEIGHT = 25
{% endhighlight %}

Un mot à propos de `SOURCE` et `DEST` :
ce sont des emplacements mémoire en page zéro qui recevront l'adresse du caractère
à copier et l'adresse où il faudra le coller.

Voici la routine principale d'un programme qui ferait descendre un à un les
caractères d'une seule colonne.
Quelques explications préalables : `init_text` affiche du texte à l'écran pour nous
permettre de faire la mise au point du programme, alors que `get_char` attend
l'appui sur une touche pour démarrer l'effet. La routine `wait` est un timer.
`rows_lsb` et `rows_msb` sont des tables précalculées qui contiennent les
adresses VRAM de chaque début de ligne, respectivement octet de poid faible et
octet de poid fort (**l**east **s**ignificant **b**yte, **m**ost **s**ignificant **b**yte).

{% highlight asm %}
// Gravity 1 - Single column -------------------------------------------
start:
  jsr init_text
  jsr get_char

do_current_column:
  ldx #SCREEN_HEIGHT-2 // On commencera au rang 23
  ldy current_column   // Ici ce sera toujours une seule et même colonne
  jsr wait
next_char:
  lda rows_lsb,x // Adresse VRAM du caractère à copier, poid faible
  sta SOURCE     // L'enregistrer
  lda rows_msb,x // Adresse VRAM du caractère à copier, poid fort
  sta SOURCE+1   // L'enregistrer
  inx            // Rangée suivante
  lda rows_lsb,x // Adresse VRAM de destination, poid faible
  sta DEST
  lda rows_msb,x // Adresse VRAM de destination, poid fort
  sta DEST+1
  lda (SOURCE),y // Charger le caractère à copier
  sta (DEST),y   // Le copier
  dex            // Revenir à la rangée précédente
  dex            // Et encore la précédente
  cpx #255       // Regarder si on est passé au rang -1 (255 == $ff == -1)
  bne next_char  // Si non, il y a encore un caractère à descendre

  lda #32        // Si oui, charger le caractère espace
  sta $0400,y    // Et l'afficher au premier rang (ce qui revient à effacer)

  // Quand on aura fait ça 24 fois de suite il ne restera plus de caractères sur
  // la colonne.
  inc counter
  lda counter
  cmp #SCREEN_HEIGHT
  bne do_current_column
done:
  rts
{% endhighlight %}


## Toutes les colonnes

La suite logique a été d'étendre l'effet d'une seule colonne à l'écran entier.
Les 40 colonnes descendent d'un rang à chaque itération.

{% img center /images/liquid-screen2.gif %}

[main_g1_callsametime.asm](https://github.com/lkdjiin/short-c64-demos/blob/main/liquid-screen-extra/main_g1_callsametime.asm)

Il suffit d'ajuster la colonne en cours après l'effacement du caractère du haut
pour faire les 40 colonnes à la suite.

{% highlight asm %}
  inc current_column
  lda current_column
  cmp #SCREEN_WIDTH
  bne do_current_column
  lda #0
  sta current_column
{% endhighlight %}


## Un effet d'escalier

C'est maintenant que ça commence à devenir intéressant.
On commence par la 1ère colonne et on ajoute les autres au fur et à mesure.

{% img center /images/liquid-screen3.gif %}

[main_g1.asm](https://github.com/lkdjiin/short-c64-demos/blob/main/liquid-screen-extra/main_g1.asm)

D'abord la colonne n°0. Ensuite les colonnes n°0 et n°1. Puis les colonnes n°0,
n°1 et n°2. Etc… J'ajoute aussi un fenêtrage. En effet, quand arrive le moment
d'inclure la colonne n°24, il se trouve que la colonne n°0 est vide. Elle ne
contient plus que des espaces et ne doit plus être mise à jour pour ne pas
ralentir l'animation. Ainsi on travaille toujours sur une fenêtre/largeur de 24
colonnes au maximum.

{% highlight asm %}
  inc current_column
  lda current_column
  cmp width
  bne do_current_column
  lda start_column
  sta current_column
  inc width
  lda width
  cmp #SCREEN_HEIGHT
  bcc skip
  inc start_column
  lda start_column
  cmp #SCREEN_WIDTH+1
  beq done
skip:
  lda width
  cmp #SCREEN_WIDTH+1
  bne do_current_column
  dec width
  jmp do_current_column
done:
{% endhighlight %}

## Une histoire de gravité

L'effet est déjà cool en l'état, mais
la façon dont les lettres chutent semble contraire aux lois de la physique.
Dans la nature la vitesse d'un objet en chute libre augmente avec le temps.
Je suis parti sur l'idée de doubler la vitesse à chaque chute d'une colonne.
C'est à dire qu'une colonne chutera de 1 caractère la première fois, de 2
caractères la seconde fois, de 4 caractères la troisième fois, et ainsi de suite.
Il serait sûrement plus réaliste d'augmenter la vitesse de chute de 1 caractère à la fois,
mais je trouve l'effet plus "dramatique" en la doublant à chaque fois ;)

## Par 2, par 4, par 8

[main_g2.asm](https://github.com/lkdjiin/short-c64-demos/blob/main/liquid-screen-extra/main_g2.asm)

Avant de m'attaquer à une vitesse qui change dans le temps, je regarde déjà comment faire chuter
les colonnes de 2 caractères.

La grosse évolution est de déplacer le code de copie d'un caractère dans une
routine à part en trouvant le moyen de gérer le fait que la somme des lignes de
l'écran (25) n'est pas divisible par le nombre de caractères déplacés (ici 2).
Si l'on n'y prend pas garde on risque de se retrouver à copier le 25ème caractère
là où devrait se trouver un hypothétique 26ème. Mais cet endroit est au-delà de la mémoire
vidéo et on va donc corrompre la mémoire. Et ce sera encore pire quand on
voudra déplacer les caractères par 4 ou par 8.

Cette fois on ne copie pas le caractère à la ligne suivante, mais deux lignes
plus bas :

{% highlight asm %}
// ---------------------------------------------------------------------
// X - screen row (0-24)
// Y - current column
copy_paste_char: {
  lda rows_lsb,x
  sta SOURCE
  lda rows_msb,x
  sta SOURCE+1
  inx
  inx
  lda rows_lsb,x
  sta DEST
  lda rows_msb,x
  sta DEST+1

  // Ne rien faire si l'adresse est 0
  lda DEST+1
  beq skip
  lda (SOURCE),y
  sta (DEST),y
skip:
  dex
  rts
}
{% endhighlight %}

Dans les tables précalculées `rows_lsb` et `rows_msb` je fais comme si la 26ème
ligne existait. Mais sa valeur est de zéro, ce qui me fait beaucoup penser au pointeur
nul du langage C.

{% highlight asm %}
rows_msb:
.byte >VRAM+40*0, >VRAM+40*1, >VRAM+40*2, >VRAM+40*3, >VRAM+40*4, >VRAM+40*5
.byte >VRAM+40*6, >VRAM+40*7, >VRAM+40*8, >VRAM+40*9, >VRAM+40*10, >VRAM+40*11
.byte >VRAM+40*12, >VRAM+40*13, >VRAM+40*14, >VRAM+40*15, >VRAM+40*16, >VRAM+40*17
.byte >VRAM+40*18, >VRAM+40*19, >VRAM+40*20, >VRAM+40*21, >VRAM+40*22, >VRAM+40*23
.byte >VRAM+40*24
.byte 0 // <=============== Adresse d'une 26ème ligne fictive
{% endhighlight %}


## L'effet final

{% img center /images/liquid-screen0.gif %}

[liquid-screen.asm](https://github.com/lkdjiin/short-c64-demos/blob/main/liquid-screen.asm)

Pour finir il faut trouver le moyen de généraliser des parties du code pour accepter
une gravité de 1, 2, 4, ou 8.
Et enfin on pourra mettre en oeuvre un pattern de gravité :

{% highlight asm %}
pattern: .byte 1, 2, 4, 8, 8, 2
columns_gravity_index:
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
{% endhighlight %}

J'aurais pu avoir un pattern `1,2,4,8,16` mais j'ai eu la flemme de tester la
gravité de 16 ;) Le 2 à la fin est pour faire un compte rond. Dans ce cas, rond
signifie égal à la hauteur d'une colonne : 1 + 2 + 4 + 8 + 8 + 2 = 25.

`columns_gravity_index` est une table de 40 valeurs, soit une par colonne. C'est
l'index a utiliser pour savoir où en est la colonne en terme de gravité. À chaque
itération on incrémente l'index.

J'ai tenté de représenter visuellement l'évolution de ces valeurs pour les 8
premières colonnes lors des 8 premières itérations. Au début tout les index sont
à 0. Entre parenthèses, à côté de chaque index, est indiqué la valeur de la
gravité correspondante dans le pattern. Un `X` signifie que la colonne est vidée,
on n'a plus besoin d'y revenir.
Les signes `^^^` montrent la "fenêtre"
d'animation. Seules les colonnes dans la fenêtre sont animées. Celles qui sont
avant sont vides, celles qui sont après n'ont pas encore été atteinte par l'effet.

~~~
Itération 1 : 0(1) , 0(1) , 0(1) , 0(1) , 0(1) , 0(1) , 0(1) , 0(1)
              ^^^^

Itération 2 : 1(2) , 0(1) , 0(1) , 0(1) , 0(1) , 0(1) , 0(1) , 0(1)
              ^^^^^^^^^^^

Itération 3 : 2(4) , 1(2) , 0(1) , 0(1) , 0(1) , 0(1) , 0(1) , 0(1)
              ^^^^^^^^^^^^^^^^^^

Itération 4 : 3(8) , 2(4) , 1(2) , 0(1) , 0(1) , 0(1) , 0(1) , 0(1)
              ^^^^^^^^^^^^^^^^^^^^^^^^^

Itération 5 : 4(8) , 3(8) , 2(4) , 1(2) , 0(1) , 0(1) , 0(1) , 0(1)
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Itération 6 : 5(2) , 4(8) , 3(8) , 2(4) , 1(2) , 0(1) , 0(1) , 0(1)
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Itération 7 : 6(X) , 5(2) , 4(8) , 3(8) , 2(4) , 1(2) , 0(1) , 0(1)
                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Itération 8 : 6(X) , 6(X) , 5(2) , 4(8) , 3(8) , 2(4) , 1(2) , 0(1)
                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
~~~

J'ai bien conscience que cette représentation est alambiquée et ne passera pas à
la postérité :D Mais qui sait, elle pourrait être utile à quelqu'un.

Il reste 36 manières d'améliorer ou d'étendre ce petit programme. Si jamais vous
en faites quelque chose, n'hésitez pas à me le dire ;)
