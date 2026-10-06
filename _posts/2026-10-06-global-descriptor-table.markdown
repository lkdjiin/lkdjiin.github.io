---
layout: post
title: "Global Descriptor Table"
date: 2026-10-06 8:00
comments: true
tags: [ blonk! ]
---

On attaque un très gros morceau : le passage en mode protégé. Mais je vais
devoir faire ça en plusieurs articles parce qu'il y a beaucoup de matière.
Aujourd'hui je n'ai pas trop le choix que de faire pas mal de théorie pour
parler de la _Global Descriptor Table_ (GDT) qui est la structure de données au
coeur du mode protégé du x86.

<!-- more -->

## Les descripteurs

On se rappelle qu'en mode réel (16 bits) une adresse est en fait un couple
segment:offset. `jmp 0x1234` ne sautera à l'adresse 0x1234 que si CS vaut zéro,
puisque l'instruction complète est `jmp CS:0x1234`.

En mode protégé (32 bits) l'usage des segments reste, mais d'une manière
différente.  Ces segments sont décrits au niveau du processeur dans une table de
données, la GDT.  Elle contiendra des descripteurs de segment.  Un descripteur
pour le segment de code du kernel.  Un descripteur pour le segment de données
du kernel.  Un descripteur pour le segment de code utilisateur.  Un descripteur
pour le segment de données utilisateur.  Et possiblement d'autres encore…
Ces trucs sont tellement importants pour la sécurité du système que la GDT
possède son propre registre dans le processeur : GDTR, et même sa propre
instruction : `lgdt`.

## Ce que contient un descripteur de segment

La réalité théorique d'un descripteur de segment est assez simple. C'est un ensemble de 8
octets qui, ensemble, décrivent :

- une base : un nombre de 32 bits qui indique où commence le segment
- une limite : un nombre de 20 bits qui indique la taille du segment
- des droits d'accès : kernel ? utilisateur ? code ? données ? lecture ? écriture ? etc…
- des réglages (_flags_) : définissent si la limite se compte en octet ou en bloc
  de 4 Ko, et si le segment est 16, 32, ou 64 bits

La réalité physique du descripteur est autrement plus complexe, les données sont
éclatées en plusieurs morceaux (8 octets = 64 bits) :

| Bits    | Fonction |
|---------|----------|
|  0 - 15 | Bits 0 à 15 de la limite
| 16 - 31 | Bits 0 à 15 de la base
| 32 - 39 | Bits 16 à 23 de la base
| 40 - 47 | Droits d'accès
| 48 - 51 | Bits 16 à 19 de la limite
| 52 - 55 | Réglages
| 56 - 63 | Bits 24 à 31 de la base

Voilà le bordel !

Décortiquons les bits de l'octet d'accès. Si tout n'est pas clair, c'est
carrément normal ;) et ça viendra en temps utile :

| Bit | Nom | Fonction |
|-----|-----|----------|
| 47 | **P** (_present_) | 1 = le segment est présent en mémoire. Pour nous, toujours 1. |
| 45-46 | **DPL** | Niveau de privilège. 0 = kernel, 3 = utilisateur. |
| 44 | **S** (_system_) | 1 = segment de code ou de données, 0 = segment système (portes, TSS, …). |
| 43 | Type | 1 = segment de code, 0 = segment de données. |
| 42 | **C/E** | Code : _conforming_. Données : sens de croissance. |
| 41 | **R/W** | Code : lisible. Données : en écriture. |
| 40 | **A** (_accessed_) | Mis à 1 par le processeur au premier accès au segment. |

Voyons les quatre bits de réglage (_flags_) :

| Bit | Nom | Fonction |
|-----|-----|----------|
| 55 | **G** (_granularity_) | 0 = limite en octets, 1 = limite en blocs de 4 Ko. |
| 54 | **D/B** | Taille par défaut : 0 = segment 16 bits, 1 = segment 32 bits. |
| 53 | **L** (_long mode_) | Segment 64 bits. On le laissera à 0. |
| 52 | **AVL** (_available_) | Réservé |

Un exemple va être très utile :

{% highlight nasm %}
; Code descriptor
dw 0xffff     ;  0 - 15
dw 0          ; 16 - 31
db 0          ; 32 - 39
db 0b10011010 ; 40 - 47
db 0b11001111 ; 48 - 55
db 0          ; 56 - 63
{% endhighlight %}

Décortiquons ce descripteur :

- la limite : 0xffff (bits 0-15) complétée par 1111 (bits 48-51), soit 0xfffff ;
- la base : 0 sur les trois morceaux, soit 0 ;
- l'octet d'accès 0b10011010 : P=1, DPL=00, S=1, type=1010, un segment de code
  lisible, réservé au kernel ;
- les réglages 1100 : G=1, D=1, L=0, AVL=0.

Avec G=1, la limite se compte en blocs de 4 Ko : 0xfffff × 4096 = 4 Go, tout
l'espace adressable en 32 bits. Base à zéro, limite maximale, le segment couvre
donc toute la mémoire : c'est le modèle _flat_ (plat). Notez le D=1 alors qu'on
tourne encore en 16 bits : ce bit ne prendra effet qu'après l'activation du mode
protégé.

_Note : la numérotation des bits_

_Je m'aperçois qu'il y a un gros piège dans ce qui précède si on ne sait pas
comment sont numéroté les bits d'un octet. Le bit n°0 est le bit de poid faible,
celui le plus à droite, inversement le bit n°7 est celui le plus à gauche. Dans
l'octet d'accès présenté plus haut (`11001111`), les bits sont numérotés de 48 à
55 :_

    n° du bit | 55 | 54 | 53 | 52 | 51 | 50 | 49 | 48 |
    ----------|----|----|----|----|----|----|----|----|
    bit       |  1 |  1 |  0 |  0 |  1 |  1 |  1 |  1 |

_C'est pourquoi il est dit plus haut que les bits 48-51 sont `1111` et non pas
`1100`. Ne faites pas l'erreur courante d'inverser le sens de la numérotation._


## Le code

On place la définition de la GDT dans le fichier message.nasm. Nous aurons
besoin de 3 descripteurs. Le premier est nul, que des zéros, c'est obligatoire.
La raison : le descripteur nul est une sécurité du processeur. Un sélecteur de
segment (le numéro chargé dans un registre de segment) est en fait un index dans
la GDT. Un sélecteur à zéro pointe sur le descripteur nul, et toute tentative
d'accès à la mémoire via ce sélecteur déclenche une exception. Ainsi, si un bug
laisse un registre de segment à zéro, on obtient une erreur explicite au lieu
d'une lecture ou d'une écriture silencieuse au mauvais endroit. Ensuite on aura
besoin du descripteur de code pour le kernel, et enfin du descripteur de données
pour le kernel. Pas besoin d'autres descripteurs pour le moment, tout tournera
en mode kernel par défaut.

{% highlight nasm %}
org 0x9000
bits 16

xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7c00

mov ebx, 0xb8000
mov byte [ebx], '0'
inc ebx
inc ebx
mov byte [ebx], '0'
inc ebx
inc ebx
mov byte [ebx], '6'

cli
hlt

; ----------------------------------------------------------------------
; Définition de la Global Descriptor Table
;
gdt_start:
  ; Null descriptor
  dd 0, 0

  ; Code descriptor
  dw 0xffff     ;  0 - 15
  dw 0          ; 16 - 31
  db 0          ; 32 - 39
  db 0b10011010 ; 40 - 47
  db 0b11001111 ; 48 - 55
  db 0          ; 56 - 63

  ; Data descriptor
  dw 0xffff
  dw 0
  db 0
  db 0b10010010 ; La seule différence est ici, le bit n°43 : data au lieu de code
  db 0b11001111
  db 0
gdt_end:

gdt_pointer:
  dw gdt_end - gdt_start - 1
  dd gdt_start

times 512-($-$$) db 0
{% endhighlight %}

Voyons la nouveauté du code précédent :

- `gdt_start` et `gdt_end` sont des labels qui bornent la table : la GDT
  mesure 3 × 8 = 24 octets ;
- le premier descripteur est nul (`dd 0, 0`, 8 octets à zéro), on a vu pourquoi ;
- les deux suivants sont le descripteur de code et le descripteur de données du
  kernel, identiques à ceux de l'exemple ;
- `gdt_pointer` est la structure qu'on chargera avec `lgdt` au prochain article.
  Elle fait 6 octets : 2 de limite, 4 d'adresse. La limite vaut
  `gdt_end - gdt_start - 1`, soit 23 : la limite du GDTR désigne le dernier
  octet de la table, pas sa taille. L'adresse est `gdt_start`, soit 0x9027,
  puisque `org 0x9000` et que la table débute à l'offset 0x27 du fichier.

L'ensemble doit compiler comme d'habitude :

    nasm boot.nasm -f bin -o boot
    nasm message.nasm -f bin -o message
    cat boot message > kernel

Il n'y a pas grand chose à voir sur l'écran pour cette version 0.0.6, mais juste
par curiosité regardons le binaire message. On y voit à quelle adresse débute
la description de la GDT, c'est ce qui est présent à `gdt_start`. C'est
l'adresse 0x9027 :

    00000000: 31c0 8ed8 8ec0 8ed0 bc00 7c66 bb00 800b  1.........|f....
    00000010: 0067 c603 3066 4366 4367 c603 3066 4366  .g..0fCfCg..0fCf
    00000020: 4367 c603 36fa f400 0000 0000 0000 00ff  Cg..6...........
    00000030: ff00 0000 9acf 00ff ff00 0000 92cf 0017  ................
    00000040: 0027 9000 0000 0000 0000 0000 0000 0000  .'..............
                ^^ ^^

Avec un peu d'habitude vous pourriez retrouver et décoder mentalement toute la
table. Mais pour le plaisir du geste et pour finir, affichons la dans le moniteur de
Qemu comme preuve ultime de notre travail :

    QEMU 10.2.1 monitor - type 'help' for more information
    (qemu) x/24b 0x9027
    00009027: 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
    0000902f: 0xff 0xff 0x00 0x00 0x00 0x9a 0xcf 0x00
    00009037: 0xff 0xff 0x00 0x00 0x00 0x92 0xcf 0x00


## Conclusion

C'était un gros pavé théorique sur la GDT, mais il fallait en passer par là. On
est prêt pour la suite, qui consistera à activer cette GDT pour enfin se
retrouver en 32 bits.


## Glossaire

**GDT** — Global Descriptor Table

_Table du processeur qui décrit les segments de mémoire.
Elle est obligatoire en mode protégé._

**Sélecteur** — index d'un descripteur dans la GDT

_Numéro chargé dans un registre de segment (CS, DS, …) qui désigne un
descripteur de la GDT._

## Références

- [Global Descriptor Table (OSDev)](https://wiki.osdev.org/Global_Descriptor_Table)
- [Global Descriptor Table (wikipédia)](https://fr.wikipedia.org/wiki/Global_Descriptor_Table)
- [Segment descriptor](https://en.wikipedia.org/wiki/Segment_descriptor)


{% include serie_blonk.md %}
