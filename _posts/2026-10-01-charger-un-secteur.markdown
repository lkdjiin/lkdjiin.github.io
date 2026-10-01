---
layout: post
title: "Charger un secteur"
date: 2026-10-01 8:00
comments: true
tags: [ blonk! ]
---

Objectif : Charger un secteur du disque dur en mémoire et lui passer la main
pour poursuivre l'exécution.

<!-- more -->

## Sortir du boot sector

Le BIOS charge le secteur 0 et c'est tout. C'est à nous d'assurer la suite.
Une solution : faire deux fichiers et les concaténer pour former une
image disque. Le premier fichier est notre bon vieux _boot sector_, le second
est un programme (rien de plus que l'écriture d'un message pour l'instant).
Le boot sector charge en mémoire le secteur contenant le programme, puis y
saute. On appelle communément ce code chargé par le boot sector le *stage 2*.
Aujourd'hui notre _stage 2_ tient dans un seul secteur, mais plus tard rien ne
l'empêchera d'être aussi volumineux que nécessaire.

## Le programme message

Le programme message est presque un copier/coller du _boot sector_ de
[l'article précédent](/blog/2026/08/27/secteur-de-boot-hello-world/).

{% highlight nasm %}
org 0x9000 ; (1)
bits 16

xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7c00

mov si, message
call print_string

jmp $

message db 'BLONK! 0.0.3', 0

print_string:
  lodsb
  or al, al
  jz .done
  mov ah, 0x0e
  mov bx, 0x0007
  int 0x10
  jmp print_string
.done:
  ret

times 512-($-$$) db 0 ; (2)
{% endhighlight %}

(1) `org 0x9000`

C'est la grosse différence avec notre précédent boot sector. Le programme sera
chargé  en 0x9000 alors que le boot sector est en 0x7c00. Notez que le boot
sector chargé en 0x7c00 n'est pas un choix, c'est une contrainte. C'est comme
ça que fonctionne un PC. Si j'ai choisi 0x9000 pour charger le programme, c'est
avant tout parce que c'est possible. J'aurais pu choisir beaucoup d'autres
adresses.

(2) `times 512-($-$$) db 0`

Je m'assure que le fichier binaire fasse exactement 512 octets.

## La mémoire du PC au démarrage

Au démarrage du PC, en mode réel, le CPU n'a pas accès à plus de 1 Mo de mémoire.
Entre 0x500 inclus et 0x80000 exclus (un peu plus de 500 Ko) la mémoire est
libre, excepté les 512 octets occupés par le boot sector.
En dessous c'est pour le BIOS et le CPU. Au dessus c'est pour le BIOS et la mémoire vidéo.

## Le nouveau boot sector

{% highlight nasm %}
BOOT_ADDRESS  equ 0x7c00 ; (1)
SHELL_ADDRESS equ 0x9000
DRIVE_NUMBER  equ 0x80

org BOOT_ADDRESS
bits 16

xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, BOOT_ADDRESS
cld

drive_reset:              ; (2)
  mov ah, 0
  mov dl, DRIVE_NUMBER
  int 0x13
  jc drive_reset

mov ax, SHELL_ADDRESS / 16 ; (3)
mov es, ax
xor bx, bx
mov ah, 0x02               ; (4)
mov al, 1
mov ch, 0
mov cl, 2
mov dh, 0
mov dl, DRIVE_NUMBER
int 0x13                   ; (5)
jc drive_reset


jmp 0:SHELL_ADDRESS     ; (6)

; ----------------------------------------------------------------------
; Table des partitions
times 446-($-$$) nop
db 0x80    ; Partition active
db 0       ; Starting head
db 2       ; Starting sector
db 0       ; Starting cylinder
db 0x20    ; System ID
db 1       ; Ending head
db 0x10    ; Ending sector
db 0x10    ; Ending cylinder
dd 1       ; LBA ?
dd 131072  ; Total de secteurs (64 MB)

times 510-($-$$) db 0
dw 0xaa55
{% endhighlight %}

(1) `BOOT_ADDRESS  equ 0x7c00`

C'est la définition d'une constante avec nasm.

(2) `drive_reset:`

    mov ah, 0            ; Fonction "RESET DISK SYSTEM" de l'interruption 13h
    mov dl, DRIVE_NUMBER ; Le numéro du drive (chaque disque dur à son numéro)
    int 0x13
    jc drive_reset       ; Si erreur, on retente

Avant de lire on demande au disque dur de faire une remise à zéro de sa (ou ses)
tête de lecture. Pas sûr que ce soit encore nécessaire avec des BIOS moderne, ou
avec l'émulation disque dur d'une clé USB. Mais historiquement les contrôleurs de
disque, ou de disquette, étaient vraiment _cheap_ et ne gardaient pas
forcement la mémoire de la position de la tête de lecture. Il fallait donc toujours
la replacer sur le secteur 0 avant de la déplacer sur le secteur voulu.

(3) `mov ax, SHELL_ADDRESS / 16`

    mov es, ax
    xor bx, bx

On fait en sorte que le couple ES:BX pointe sur l'adresse où on veut loger notre
programme. Pourquoi ? Parce que c'est ce que demande la fonction du BIOS qu'on
va utiliser.

(4) `mov ah, 0x02`

    mov al, 1 ; Nombre de secteurs à lire
    mov ch, 0 ; Cylindre (_cylinder_)
    mov cl, 2 ; Numéro du secteur
    mov dh, 0 ; Tête (_head_)
    mov dl, DRIVE_NUMBER

On continue de charger les registres pour pouvoir utiliser la fonction de chargement de
secteur(s) du BIOS. Voir plus loin les explications pour _cylinder/head/sector_.

(5) `int 0x13`

    jc drive_reset

Quand les registres sont prêts on appelle la fonction de lecture. Et si elle
échoue on reprend à partir du _reset_, c'est plus sûr.

(6) `jmp 0:SHELL_ADDRESS`

Le programme a été chargé, on peut y «sauter». On se rappelle qu'en mode réel toute
adresse est en réalité un couple segment:offset. Cela signifie que `jmp 0x9000` n'ira
pas à l'adresse 0x9000 mais à l'adresse pointée par le couple CS:0x9000. CS étant
le _Code Segment_. On n'a jamais chargé ce registre et le BIOS ne garanti pas sa
valeur. C'est pourquoi on fait `jmp 0:0x9000`. Là on est sûr d'aller à l'adresse
0x9000. De plus, par effet de bord, le processeur va forcer le chargement de CS à 0.

## CHS : Cylinder / Head / Sector

En français : cylinder, tête, secteur.

Les premiers PCs étaient chers. Un moyen de d'abaisser le coût était "d'oublier"
le contrôleur de disquette. Un disque (dur ou disquette) est constitué
physiquement de cylindres partagés en plusieurs secteurs sur plusieurs faces
accéssibles par plusieurs têtes de lecture. Résultat : au lieu de lire
simplement le secteur n° X, on doit lire le secteur S du cylindre C qui se
trouve sur la face/tête H.

## Assemblage et tests

Cette fois on a deux programmes à assembler :

    nasm message.nasm -f bin -o message
    nasm boot.nasm -f bin -o boot

On les réunit ensemble. L'ordre est important, le _boot sector_ doit absolument
être en premier :

    cat boot message > kernel

Le nom `kernel` est un peu prétentieux à ce stade, mais c'est bien vers quoi on
se dirige ;) On peut s'assurer que le kernel fait bien exactement 1024 octets,
la taille de deux secteurs :

    ls -l
    -rw-rw-r-- 1 xavier xavier  512 Aug 12 15:00 boot
    -rw-rw-r-- 1 xavier xavier 1024 Aug 12 15:00 kernel
    -rw-rw-r-- 1 xavier xavier  512 Aug 12 15:00 message

On lance dans Qemu pour un retour rapide :

    qemu-system-i386 -hda kernel

Pour tester sur un véritable ordinateur (ou comme moi sur plusieurs) on copie
d'abord le binaire sur une clé USB :

    sudo fdisk -l           # <<< pour connaître le device
    sudo cp kernel /dev/sdx   # <<< remplacez x par la bonne lettre ;)

_Attention avec sudo. Si vous ne comprenez pas ce
que vous faites, il n'y a pas de mal à se contenter pour l'instant de l'émulateur._

## Conclusion

On a vu comment charger un programme de la taille d'un secteur en mémoire à partir d'une clé USB
et à lancer ce programme. Au passage on en a appris un peu plus sur l'organisation de la
mémoire du PC et sur la géométrie des disques (CHS).


## Glossaire

**CHS** — Cylinder Head Sector

_Méthode historique pour parler à un disque dur ou à un lecteur de disquette_
_en mode réel._

## Références

- [Code complet de BLONK! v0.0.3](https://github.com/lkdjiin/blonk/tree/v0.0.3)
- [x86 Memory Map](https://wiki.osdev.org/Memory_Map_(x86))
- [int 13h/ah=00h](https://www.ctyme.com/intr/rb-0605.htm)
- [int 13h/ah=02h](https://www.ctyme.com/intr/rb-0607.htm)
- [CHS](https://fr.wikipedia.org/wiki/Cylindre/T%C3%AAte/Secteur)
- [Rolling Your Own Bootloader](https://wiki.osdev.org/Rolling_Your_Own_Bootloader)


{% include serie_blonk.md %}
