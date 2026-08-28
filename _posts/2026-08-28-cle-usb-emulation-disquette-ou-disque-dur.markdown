---
layout: post
title: "Clé USB, émulation disquette ou disque dur"
date: 2026-08-28 8:00
comments: true
tags: [ blonk! ]
---

On explore les mystères de l'émulation disquette ou disque dur des clés USB au
démarrage d'un PC, en mode réel (16 bits).

<!-- more -->

## Rappel

On veut comprendre pour quelle raison le message du _boot sector_
développé dans [l'article précédent](/blog/2026/08/27/secteur-de-boot-hello-world/) est tronqué sur une des machines de test, mais
pas sur les autres.
Et bien sûr on veut résoudre le problème.


### Comment le PC démarre sur une clé USB

En mode réèl (16 bits) il n'y a pas vraiment de driver USB dans le BIOS. Il
s'agit en fait d'une émulation. Le BIOS voit la clé USB soit comme une disquette,
soit comme un disque dur.

Pour certains BIOS (c'est le moment où vous devez admettre que chaque PC a un
BIOS différent), une disquette doit avoir un _BIOS Parameter Block_ (BPB) valide.
Sinon, certains de ces BIOS s'accordent la liberté de _patcher_ certains octets de la supposée BPB à zéro.
Certains BIOS sont connus pour faire ça aux offsets 0x1c, 0x1d, 0x1e et 0x1f du
secteur de boot. Et quand je regarde à ces emplacements je vois le morceau "and " du message :

    xxd boot | head -3
    00000000: 31c0 8ed8 8ec0 8ed0 bc00 7cfc be14 7ce8  1.........|...|.
    00000010: 1a00 ebfe 5765 6c63 6f6d 6520 616e 6420  ....Welcome and
                                            ^^^^ ^^^^
    00000020: 6269 656e 7665 6e75 650d 0a00 ac08 c074  bienvenue......t

Le BIOS a réécrit ces octets à zéro. C'est la raison pour laquelle cet ordinateur
affiche seulement "Welcome " au lieu de "Welcome and bienvenue".

Pour corriger ce problème, une solution possible est d'assumer que la clé USB
soit reconnue en tant que disquette.


### La clé USB émulée comme une disquette

Je ne vais pas m'étendre sur cette solution. Je l'ai testée, elle fonctionne,
mais je ne l'utilise pas : les disquettes sont obsolètes et je ne veux pas
m'embêter avec, même émulées. Mais si pour une raison ou pour une autre vous
voulez utiliser l'émulation disquette de la clé USB, ou une vraie disquette
voici ce qu'il faudra faire : insérer une FAT, même fictive, avant le code.
Ainsi tout les BIOS seront contents.

{% highlight nasm %}
org 0x7c00
bits 16

jmp short start
nop

; Fausse FAT BPB
bpb_oem_name:          db 'BLONK   '
bpb_bytes_per_sector:  dw 512
bpb_sectors_per_cluster: db 1
bpb_reserved_sectors:  dw 1
bpb_num_fats:          db 2
bpb_root_entries:      dw 224
bpb_total_sectors_16:  dw 2880
bpb_media:             db 0xf0
bpb_sectors_per_fat:   dw 9
bpb_sectors_per_track: dw 18
bpb_num_heads:         dw 2
bpb_hidden_sectors:    dd 0
bpb_total_sectors_32:  dd 0
eb_drive_number:       db 0x80
eb_reserved:           db 0
eb_boot_signature:     db 0x29
eb_volume_id:          dd 0x12345678
eb_volume_label:       db 'BLONK      '
eb_fs_type:            db 'FAT12   '

start:
mov ax, 0
mov ds, ax
[ Suite du code, c'est le même que plus haut ]
{% endhighlight %}


### La clé USB émulée comme un disque dur

Un PC s'attend à ce qu'un disque dur possède un _Master Boot Record_ (MBR).
Le MBR est le tout premier secteur du disque. Si vous avez suivi [l'article précédent](/blog/2026/08/27/secteur-de-boot-hello-world/),
c'est le moment où vous dites :

_«Non, le premier secteur c'est le boot sector !»_

Et vous auriez raison. C'est les deux en même temps. Un MBR contient la table
des partitions du disque, dont l'une au moins doit être active. Rien
n'empêche un secteur de contenir une table des partitions, une signature de
_boot sector_ et du code d'amorçage. Tant que ça tient en 512 octets...

Comme avec la solution précédente, là encore on peut construire une partition fictive.
Il faut placer cette table à l'offset 446 :

{% highlight nasm %}
times 446-($-$$) nop
db 0x80    ; Partition active
db 0       ; Starting head
db 2       ; Starting sector
db 0       ; Starting cylinder
db 0x20    ; System ID
db 1       ; Ending head
db 0x10    ; Ending sector
db 0x10    ; Ending cylinder
dd 1       ; LBA
dd 131072  ; Total de secteurs (64 MB)
{% endhighlight %}

Vous pourriez vous amuser à modifier certains champs pour voir ce que ça
change.


## Le code complet

Pour référence, voici le code complet.

{% highlight nasm %}
org 0x7c00
bits 16

xor ax, ax 
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7c00
cld

mov si, welcome
call print_string

jmp $

welcome db 'Welcome and bienvenue', 0x0d, 0x0a, 0

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

## Conclusion

Pour que le BIOS traite une clé USB comme si c'était une disquette
il faut insérer une FAT dans le secteur de boot.
Si vous voulez plutôt que le BIOS traite votre clé USB comme un disque dur, vous
y ajouterez une table des partitions.


## Glossaire

**BIOS** — Basic Input Output System

_Système élémentaire d'entrée/sortie présent dans la ROM des ordinateurs_
_compatibles PC._

**BPB** — BIOS Parameter Block

_Structure de données décrivant le disque dur ou la disquette et placée dans_
_le boot sector._

**FAT** — File Allocation Table

_Système de fichiers classique. S'il est loin d'être le meilleur, il possède_
_deux avantages de poids : il est simple et présent partout._

**MBR** — Master Boot Record

_Le premier secteur d'un disque dur. Il contient, entre autre, la table des_
_partitions._

**PC** — Personal Computer

_Ordinateur compatible PC, basé sur les microprocesseurs de la famille x86._


## Références

- [Code complet de BLONK! v0.0.2](https://github.com/lkdjiin/blonk/tree/v0.0.2)
- [BIOS Parameter Block](https://en.wikipedia.org/wiki/BIOS_parameter_block)
- [File Allocation Table](https://fr.wikipedia.org/wiki/File_Allocation_Table)


{% include serie_blonk.md %}
