---
layout: post
title: "Écrire dans la mémoire vidéo VGA"
date: 2026-10-03 8:00
comments: true
tags: [ blonk! ]
---

Dans cet article on regarde comment on peut écrire directement dans la mémoire
vidéo du mode VGA, sans passer par le BIOS.

<!-- more -->

## Un point sur la situation

Prenons deux secondes pour regarder ce qu'on a fait jusqu'ici :

- charger des secteurs du disque dur vers la mémoire
- écrire des chaînes de caractères à l'écran

Tout cela, on l'a réalisé à l'aide du BIOS.  Mais lorsqu'on passera dans un
futur proche en 32 bits (mode protégé) nous n'aurons plus accès au BIOS.
On va donc devoir trouver d'autres moyens pour continuer à réaliser ces actions.
Une chose à la fois, aujourd'hui on regarde le fonctionnement de base de la
mémoire vidéo du VGA.

## Mode texte couleur

Quand le PC démarre, il est en mode texte, 80 colonnes sur 25 lignes, en couleur.
En couleur seulement si le moniteur est lui-même couleur, mais on va supposer que
c'est le cas et oublier les moniteurs monochromes. La mémoire vidéo texte couleur
est mappée à l'adresse 0xb8000. Chaque lettre/case/cellule est codée sur
deux octets : un octet pour le code ASCII et un second pour la couleur.

| Adresse | Fonction |
|---------|----------|
|0xb8000 | code ASCII rangée supérieure, première colonne (coin en haut à gauche)
|0xb8001 | couleur rangée supérieure, première colonne
|0xb8002 | code ASCII rangée supérieure, deuxième colonne
|0xb8003 | couleur rangée supérieure, deuxième colonne

Pour l'octet de couleur, voici comment il est codé :

- les bits 0 à 3 définissent la couleur de premier plan (16 possibles)
- les bits 4 à 6 définissent la couleur d'arrière-plan (8 possibles)

Et le bit 7 ? On ne va pas l'utiliser car il dépend du matériel. Mais sur Qemu
il permettra d'accéder à 16 couleurs pour l'arrière-plan.

La liste des couleurs :

- 0 noir
- 1 bleu
- 2 vert
- 3 cyan
- 4 rouge
- 5 rose
- 6 marron
- 7 gris clair
- 8 gris foncé
- 9 bleu clair
- 10 vert clair
- 11 cyan clair
- 12 rouge clair
- 13 rose clair
- 14 jaune
- 15 blanc

## Du code

On modifie message.nasm :

{% highlight nasm %}
org 0x9000
bits 16

xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7c00

mov ebx, 0xb8000      ; (1)
mov byte [ebx], 'B'
inc ebx               ; (2)
mov byte [ebx], 0x34

cli ; (3)
hlt

times 512-($-$$) db 0
{% endhighlight %}

{% img center /images/blonk-005-01.png %}


(1) `mov ebx, 0xb8000`

    mov byte [ebx], 'B'

On charge EBX avec l'adresse de début de la mémoire vidéo, 0xb8000. Puis on met
le code ASCII de la lettre B à cette adresse. Notez au passage qu'on peut très
bien utiliser comme ici un registre 32 bits (EBX) alors qu'on est en mode 16
bits.


(2) `inc ebx`

    mov byte [ebx], 0x34

On passe à l'adresse suivante, 0xb8001, pour y mettre la couleur. 0x34 nous
donne du rouge sur fond cyan.


(3) `cli`

    hlt

Rien à voir avec le VGA et la mémoire vidéo.
J'ai remplacé l'ancien `jmp $` par `cli` et `hlt`. Je trouve ça plus propre.
L'instruction `hlt` met le processeur en pause jusqu'à la prochaine interruption.
C'est pourquoi on désactive d'abord les interruptions avec `cli`.


## Jeu de caractères

Normalement, le PC devrait avoir le jeu de caractères dit _code page 437_. Un
ASCII étendu avec des accents et quelques caractères semi-graphiques. On peut
tester :

{% highlight nasm %}
org 0x9000
bits 16

xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7c00

mov ebx, 0xb8000
mov byte [ebx], 3    ; un coeur
inc ebx
mov byte [ebx], 0x0f ; blanc sur fond noir
inc ebx
mov byte [ebx], 66   ; la lettre B
inc ebx
mov byte [ebx], 0xe4 ; rouge sur fond jaune
inc ebx
mov byte [ebx], 130  ; la lettre é
inc ebx
mov byte [ebx], 0x0f ; blanc sur fond noir

cli
hlt

times 512-($-$$) db 0
{% endhighlight %}

Résultat dans Qemu : {% img center /images/blonk-005-02.png %}

Mes trois ordinateurs de test affichent bien les caractères. Mais la lettre B est
en rouge clignotant sur fond marron ; c'est le problème avec le bit 7 de la
couleur.


## Conclusion

On est prêt à affronter le mode 32 bits en ce qui concerne l'affichage. Même si
pour être honnête, on est encore loin de gérer tout le bazar nécessaire :

- afficher une chaîne
- gérer le curseur
- gérer le scrolling

Malgré tout, l'affichage d'un unique caractère à un endroit précis sans passer
par le BIOS était le premier pas indispensable. Et on l'a fait.


## Glossaire

**ASCII** — American Standard Code for Information Interchange

_Jeu de codage des caractères sur 7 bits (codes 0 à 127), défini en 1963._

**VGA** — Video Graphic Array

_Standard d'affichage qui date de 1987._

## Références

- [VGA text mode](https://en.wikipedia.org/wiki/VGA_text_mode)
- [Le standard VGA](https://fr.wikipedia.org/wiki/Video_Graphics_Array)
- [Page de code 437](https://fr.wikipedia.org/wiki/Page_de_code_437)


{% include serie_blonk.md %}