---
layout: post
title: "Le mode protégé"
date: 2026-10-08 8:00
comments: true
tags: [ blonk! ]
---

Avec une GDT en place, il n'y a plus qu'à s'en servir. Aujourd'hui on bascule
enfin en 32 bits : le mode protégé. Le principe est d'une simplicité presque
décevante — mettre à 1 le bit PE du registre CR0 — mais il faut s'occuper de la
pile, des registres de segment et d'un saut pour "officialiser" le passage.

<!-- more -->

## Le code

Nous sommes prêts à passer en 32 bits, le fameux mode protégé.
Tout se passe dans le fichier message.nasm. Le début reste le même :

{% highlight nasm %}
org 0x9000
bits 16

xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7c00
{% endhighlight %}

Il faut prendre garde à désactiver les interruptions, sinon le processeur
pourrait se mettre à faire n'importe quoi.  On les réactivera plus tard, quand
on en aura besoin.  On peut alors enregistrer la GDT avec l'instruction `lgdt`.

{% highlight nasm %}
cli
lgdt [gdt_pointer]
{% endhighlight %}

On passe en mode protégé en mettant à 1 le bit 0 du registre CR0. C'est presque
trop simple.

{% highlight nasm %}
mov eax, cr0
or eax, 1
mov cr0, eax
{% endhighlight %}

Pour "officialiser" le passage en mode protégé, on effectue un saut qui en
même temps charge CS avec 8. On se souvient que 8 est l'index du descripteur de
segment de code dans la GDT. Le saut nous emmène après la définition de la GDT,
qui est identique à celle de l'article précédent.

{% highlight nasm %}
jmp 8:go_32_bits

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
  db 0b10010010
  db 0b11001111
  db 0
gdt_end:

gdt_pointer:
  dw gdt_end - gdt_start - 1
  dd gdt_start
{% endhighlight %}

À partir de maintenant nous sommes en 32 bits / mode protégé. On le signale à
nasm avec la directive `bits 32`. Vient ensuite le chargement de tous les
registres de segment de données avec la valeur 0x10, qui est l'index du
descripteur du segment de données dans la GDT. C'est quelque chose qu'on veut
faire le plus tôt possible pour éviter les erreurs.

{% highlight nasm %}
bits 32
go_32_bits:
  mov ax, 0x10
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ss, ax
{% endhighlight %}

On n'oublie pas de signaler le haut de la pile. 0x90000 est loin du kernel, ça
laisse de quoi voir venir.

{% highlight nasm %}
  mov esp, 0x90000 ; la pile commence à 0x90000
{% endhighlight %}

Pour finir je me contente d'afficher le numéro de version au centre de l'écran.
Il faut se décaler de ((80×11)+37)×2 octets par rapport au début de la mémoire
vidéo : nombre de colonnes par ligne (80) x 11 (12ème ligne) + 37 (38ème colonne),
le tout x 2 (2 octets par cellule, le code ASCII et la couleur).

{% highlight nasm %}
; Afficher le numéro de version au centre de l'écran
mov ebx, 0xb8000 + 0x72a
mov byte [ebx], '0'
inc ebx
inc ebx
mov byte [ebx], '0'
inc ebx
inc ebx
mov byte [ebx], '7'

cli
hlt

times 512-($-$$) db 0
{% endhighlight %}

## Inspection des registres

Il est intéressant de regarder le contenu des registres dans Qemu.

- ESP pointe sur le haut de la pile : 0x90000
- DS, ES, FS, GS et SS contient l'index 0x10 (le descripteur de données)
- CS contient l'index 0x08 (le descripteur de code)
- GDT positionne son adresse à 0x9020 et sa taille à 0x17 (comme vu dans l'article précédent)
- CR0 a bien son bit n°0 allumé


~~~
QEMU 10.2.1 monitor - type 'help' for more information
(qemu) info registers
CPU#0
EAX=00000010 EBX=000b8004 ECX=00000002 EDX=00000080
ESI=00000000 EDI=00000000 EBP=00000000 ESP=00090000
EIP=00009065 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=1
ES =0010 00000000 ffffffff 00cf9300 DPL=0 DS   [-WA]
CS =0008 00000000 ffffffff 00cf9a00 DPL=0 CS32 [-R-]
SS =0010 00000000 ffffffff 00cf9300 DPL=0 DS   [-WA]
DS =0010 00000000 ffffffff 00cf9300 DPL=0 DS   [-WA]
FS =0010 00000000 ffffffff 00cf9300 DPL=0 DS   [-WA]
GS =0010 00000000 ffffffff 00cf9300 DPL=0 DS   [-WA]
LDT=0000 00000000 0000ffff 00008200 DPL=0 LDT
TR =0000 00000000 0000ffff 00008b00 DPL=0 TSS32-busy
GDT=     00009020 00000017
IDT=     00000000 000003ff
CR0=00000011 CR2=00000000 CR3=00000000 CR4=00000000
~~~

## Conclusion

Voilà, notre code fonctionne maintenant en 32 bits, mode protégé.
Par rapport au monstrueux boxon que représente la compréhension de la GDT
(voir l'article précédent) son activation m'a semblé étonnamment simple.

La prochaine étape importante va être l'utilisation du langage C. Autant j'aime
l'assembleur, autant je sais que le C permettra de booster l'avancement de
BLONK! Mais avant cela, le prochain article se concentrera sur l'organisation du
code et sur l'utilitaire make, car le nombre de fichiers source va certainement
bientôt exploser.

## Glossaire

**CR0** — Registre de contrôle du processeur

_Registre 32 bits dont le bit 0 (PE, _protected enable_) commande le mode
protégé. Le passage de PE à 1 est précisément ce qui bascule le processeur en
32 bits._

**GDT** — Global Descriptor Table

_Table du processeur qui décrit les segments de mémoire.
Elle est obligatoire en mode protégé._

**LGDT** — _Load Global Descriptor Table_

_Instruction qui charge le registre GDTR avec l'adresse de la GDT et sa limite.
À elle seule elle ne suffit pas à entrer en mode protégé, il faut aussi le bit
PE de CR0._

**PE** — _Protected Enable_

_Bit 0 du registre CR0. C'est en le mettant à 1 qu'on active le mode protégé._

**Sélecteur** — index d'un descripteur dans la GDT

_Numéro chargé dans un registre de segment (CS, DS, …) qui désigne un
descripteur de la GDT._

## Références

- [The world of protected mode](http://www.osdever.net/tutorials/view/the-world-of-protected-mode)
- [GDT tutorial](https://wiki.osdev.org/GDT_Tutorial)


{% include serie_blonk.md %}
