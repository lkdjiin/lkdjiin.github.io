---
layout: post
title: "Inspecter la mémoire avec Qemu"
date: 2026-10-02 8:00
comments: true
tags: [ blonk! ]
---

On va voir comment inspecter la mémoire avec le moniteur de Qemu.

<!-- more -->

## Sauvegarder le numéro du boot drive

J'ai trouvé un petit pretexte pour aller regarder dans la mémoire de Qemu.
Au lieu de définir en dur le numéro du drive sur lequel l'ordinateur démarre, on
va le prendre du BIOS et l'enregistrer dans la RAM en tant que donnée du système.
On pourra s'y réferer plus tard autant que nécessaire.

### Le problème

Pour illustrer le problème induit par le numéro en dur du drive de boot, lançons
notre kernel dans Qemu depuis une disquette en remplaçant l'option `-hda` par `-fda` :

    qemu-system-i386 -fda kernel

Qemu va afficher éternellement un message du genre "Booting from floppy disk...".
La faute au code de chargement dans `boot.nasm` :

{% highlight nasm %}
DRIVE_NUMBER  equ 0x80

drive_reset:
;[...]
; Charger le shell à l'adresse 0x9000.
mov ax, SHELL_ADDRESS / 16
;[...]
mov dl, DRIVE_NUMBER ; <<< Il n'y a pas de drive 0x80
int 0x13
jc drive_reset       ; <<< Alors erreur et on recommence
{% endhighlight %}

Si on passe le `DRIVE_NUMBER` à 0, on pourra booter à partir d'une disquette.
Mais alors c'est le disque dur qui ne fonctionnera plus.

### La solution

Pour une fois ce n'est pas le problème mais la solution qui vient du BIOS.
Juste avant de passer la main au boot sector, le BIOS charge dans le registre DL
le numéro du drive sur lequel l'ordinateur a booter. À nous de le sauvegarder
quelque part avant que notre code ne touche au registre DL. Mais après avoir initialisé DS !
Pour rappel on va toucher à la mémoire, donc on aura affaire au couple segment:offset du
mode réel. Je décide de l'enregistrer à l'adresse 0x500 :

    mov byte [0x500], dl

Cette instruction signifie : «charge la case mémoire 0x500 avec l'octet de DL».
Plus précisement encore «la case mémoire pointée par DS:0x500».

## Memory Map

Voici la carte mémoire actuelle de BLONK! J'ai choisi de réservé une tranche de
256 octets pour les données du système et j'ai pris la première zone libre.
L'avenir nous dira si 256 octets est trop ou trop peu ;)

| Début   | Fin     | Longueur   | Fonction |
|---------|---------|------------|---------------------------------------|
| 0x80000 |         |            | BIOS + vidéo
| 0x09200 | 0x7ffff | 475 Ko     | Libre
| 0x09000 | 0x091ff | 512 o      | Programme message
| 0x07c00 | 0x07dff | 512 o      | Boot
| 0x00600 | 0x07bff |            | Stack
| 0x00500 | 0x005ff | 256 o      | Données du système (pour l'instant seulement boot drive)
| 0x00000 | 0x004ff | 1280 o     | Interruptions + BIOS

## Le code

On remplace `DRIVE_NUMBER equ 0x80` par `BOOT_DRIVE equ 0x500`.

On sauvegarde DL dès que possible :

{% highlight nasm %}
xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, BOOT_ADDRESS
mov byte [BOOT_DRIVE], dl
cld
{% endhighlight %}

Puis on remplace les deux `mov dl, DRIVE_NUMBER` par `mov dl, [BOOT_DRIVE]`.

Vous pourrez [le trouver au complet ici](https://github.com/lkdjiin/blonk/tree/v0.0.4).

Une fois assemblé comme la dernière fois, on peut vérifier que ça fonctionne
aussi bien avec une disquette qu'avec un disque dur :

    nasm message.nasm -f bin -o message
    nasm boot.nasm -f bin -o boot
    cat boot message > kernel

    qemu-system-i386 -fda kernel
    qemu-system-i386 -hda kernel

## Le moniteur Qemu

On lance le kernel avec `qemu-system-i386 -hda kernel`. Quand le message
"BLONK! 0.0.4" s'affiche, ouvrez l'onglet du moniteur (menu view).

La commande de base pour inspecter la mémoire est `x/`. Sa forme : `x/` suivi
du nombre d'éléments, du format, puis de l'adresse. Le format est une taille
(`b` octet, `h` mot de 2 octets) suivie d'un rendu (`x` hexadécimal, `c`
caractère) : `bx` pour des octets en hexadécimal, `bc` pour des octets en
caractères. Sans précision du rendu, l'hexadécimal est utilisé.

Dans le moniteur tapez :

    x/8b 0x500

Résultat :

    QEMU 10.2.1 monitor - type 'help' for more information
    (qemu) x/8b 0x500
    00000500: 0x80 0x00 0x00 0x00 0x00 0x00 0x00 0x00

Le premier octet est notre boot drive sauvegardé : `0x80` parce qu'on a démarré
depuis un disque dur. Avec `-fda kernel` ce serait `0x00`.

### Notre message en mémoire

Le message "BLONK! 0.0.4" est stocké dans le programme `message`, en 0x9013.
Regardons ses octets :

    (qemu) x/16bx 0x9013
    00009013: 0x42 0x4c 0x4f 0x4e 0x4b 0x21 0x20 0x30
    0000901b: 0x2e 0x30 0x2e 0x34 0x00 0xac 0x08 0xc0

On reconnait les codes ASCII du message : `0x42`='B', `0x4c`='L', `0x4f`='O',
`0x4e`='N', `0x4b`='K', `0x21`='!', et le zéro final qui marque la fin de la
chaîne. Les trois octets qui suivent (`0xac 0x08 0xc0`) ne font pas partie du
message : c'est le début de la fonction `print_string`, qui commence par
`lodsb` puis `or al, al`.

### L'état du processeur

La commande `info registers` affiche l'état de tous les registres :

    (qemu) info registers
    EAX=00000e00 EBX=00000007 ECX=00000002 EDX=00000080
    ESI=00009020 EDI=00000000 EBP=00000000 ESP=00007c00
    EIP=00009011 EFL=00000246 [---Z-P-] CPL=0 ...

- `EIP=00009011` : on est dans la boucle infinie `jmp $`, la dernière
  instruction de notre programme
- `ESP=00007c00` : le haut de la pile, comme prévu
- `EDX=00000080` : DL contient à nouveau le numéro du boot drive, relu depuis
  0x500
- `ESI=00009020` : SI pointe juste après la chaîne, `lodsb` incrémentant à
  chaque caractère lu

### Une capture d'écran

Pour terminer, la commande `screendump` écrit une image de l'écran dans le
répertoire courant au format PPM :

    (qemu) screendump ecran.ppm



## Références

- [Code complet de BLONK! v0.0.4](https://github.com/lkdjiin/blonk/tree/v0.0.4)
- [Documentation moniteur Qemu](https://www.qemu.org/docs/master/system/monitor.html)


{% include serie_blonk.md %}
