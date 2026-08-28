---
layout: post
title: "Secteur de boot : Hello, world!"
date: 2026-08-27 8:00
comments: true
tags: [ blonk! ]
---

L'objectif est de prendre la main au démarrage de l'ordinateur en affichant un
message sur l'écran, et rien de plus.

{% img center /images/blonk-001-01.png %}

<!-- more -->

## Power On

Quand on allume un ordinateur (un PC), le BIOS cherche un périphérique (disque dur, clé
USB, disquette, ...) à partir duquel charger un code d'amorçage.
Sur les PC ce code est celui du tout premier secteur du périphérique d'amorçage,
soit 512 octets, pas un de plus, pas un de moins.
Le BIOS place le contenu de ce secteur en mémoire à l'adresse `0x7c00`.
Il vérifie la signature de _boot_, qui sont les deux derniers octets de ce bloc
de 512 octets. Si c'est la bonne (`0x55 0xaa`) il lance l'exécution à l'adresse
`0x7c00`. Sinon il essaie le périphérique suivant sur sa liste.

## Le code de base

C'est assez simple puisque le BIOS nous fournit une fonction pour écrire une
chaîne de caractères. Mais il y a quand même plusieurs subtilitées à prendre en
compte, dues au fonctionnement du processeur x86. Le code est écrit pour
[nasm](https://www.nasm.us/).

{% highlight nasm %}
org 0x7c00      ; (1)
bits 16         ; (2)

xor ax, ax      ; (3)
mov ds, ax      ; (4)
mov es, ax
mov ss, ax
mov sp, 0x7c00  ; (5)
cld             ; (6)

mov si, welcome   ; (7)
call print_string ; (8)

jmp $             ; (9)

welcome db 'Welcome and bienvenue', 0x0d, 0x0a, 0 ; (10)

print_string:      ; (11)
  lodsb            ; (12)
  or al, al        ; (13)
  jz .done         ; (14)
  mov ah, 0x0e     ; (15)
  mov bx, 0x0007   ; (16)
  int 0x10         ; (17)
  jmp print_string ; (18)
.done:
  ret              ; (19)

times 510-($-$$) db 0 ; (20)
dw 0xaa55             ; (21)
{% endhighlight %}

### Explications ligne par ligne

Comme c'est le premier programme en assembleur de la série, que c'est peut-être
la première fois que vous utilisez nasm, je vais le décortiquer ligne après
ligne. Je ne le ferais plus autant par la suite.

(1) `org 0x7c00`

C'est une directive pour l'assembleur, signifiant que le code qui suit démarre
à l'adresse 0x7c00. Ainsi les adresses absolues tomberont aux
bons endroits. On peut vérifier ces adresses, encodées en langage machine, en désassemblant le binaire :

    ndisasm -b 16 -o 0x7c00 boot | head -7
    00007C00  31C0              xor ax,ax
    00007C02  8ED8              mov ds,ax
    00007C04  8EC0              mov es,ax
    00007C06  8ED0              mov ss,ax
    00007C08  BC007C            mov sp,0x7c00
    00007C0B  FC                cld
    00007C0C  BE147C            mov si,0x7c14 ; <--- Ici par exemple

(2) `bits 16`

Là aussi, c'est une directive. Elle signale à l'assembleur de générer du code
16 bits. Au démarrage de l'ordinateur, le CPU est en 16 bits, ce que Intel nomme
le mode réèl.

(3) `xor ax, ax`

La manière classique pour x86 de charger un registre à zéro. C'est
équivalent à `mov ax, 0`, sauf que ça produit un code machine plus court.
Comparaison :

|code machine| assembleur |
|------------|------------|
| `B80000`   | `mov ax,0x0` |
|------------|------------|
| `31C0`     | `xor ax,ax`  |

(4) `mov ds, ax`

On charge le registre DS (data segment) à 0. Et dans les lignes suivantes on
fait pareil avec ES (extra segment) et SS (stack segment).

Note 1 : on ne peut pas
charger les registres de segment directement, par exemple `mov ds, 0`. C'est
pourquoi on passe par AX.

Note 2 : en mode réel, une adresse est **toujours** un couple `segment:offset`.
C'est le moyen qu'a choisi Intel pour pouvoir adresser plus de 64 Ko.

    adresse physique = segment × 16 + offset

Les deux couples suivants représente la même adresse :

    0000:7C00  = 0x0000×16 + 0x7C00 = 0x7C00
    07C0:0000  = 0x07C0×16 + 0x0000 = 0x7C00

(5) `mov sp, 0x7c00`

SP est le registre _stack pointer_. Il représente le haut de la pile. Comme la
pile descend, on peut la placer juste avant notre code. Cette zone est pour
l'instant un endroit relativement libre et sans risque pour la pile.

(6) `cld`

Cette instruction signifie _Clear Direction Flag_. Elle met à zéro le _flag_ de
direction pour que les instructions de copie fonctionnent dans le sens normal,
vers l'avant. En théorie les _flags_ peuvent être dans n'importe quel état
lorsque le BIOS passe la main à votre _boot sector_.

(7) `mov si, welcome`

Charge le registre SI avec l'adresse du message à afficher. Pourquoi ? Parce que
c'est ce que demande la fonction BIOS qu'on utilise plus loin.

(8) `call print_string`

J'aurais pu mettre directement le code pour afficher le message, mais j'ai
préféré faire plus propre avec un appel de routine.

(9) `jmp $`

Lorsqu'on revient de la routine `print_string` on retombe ici. `$` est une sorte
de variable magique de l'assembleur nasm, qui est remplacée par l'adresse courante
lors de l'assemblage. On a donc une boucle infinie. C'est l'équivalent de :

{% highlight nasm %}
loop:
  jmp loop
{% endhighlight %}

(10) `welcome db 'Welcome and bienvenue', 0x0d, 0x0a, 0`

Le message à afficher. Déclarer avec `db` : _declare byte(s)_. Notez qu'on
inclus passage à la ligne suivante, retour à la ligne, et zéro terminal.

(11) `print_string:`

Le _label_ `print_string`. Un _label_ est convertit en adresse lors de l'assemblage.
C'est pourquoi on a pu faire plus tôt un `call print_string`.

(12) `lodsb`

C'est une instruction de copie. Elle charge l'octet pointé par DS:SI dans AL puis
incrémente SI. Elle est ainsi prête à charger le prochain caractère du message.

(13) `or al, al`

On teste le contenu de AL pour savoir si c'est zéro, ce qui indiquera la fin du
message. Quel que soit X, `or X, X` produira zéro si et seulement si X == 0.

(14) `jz .done`

Si c'est la fin du message (le dernier caractère lu était un zéro) on saute au
_label_ `.done`.

(15) `mov ah, 0x0e`

C'est le numéro de la fonction de l'interruption 0x10 du BIOS.

(16) `mov bx, 0x0007`

C'est la couleur du caractère qu'on va afficher.

(17) `int 0x10`

Tout les infos nécessaires sont chargées dans les registres adéquats. On appelle
le BIOS pour afficher un caractère.

(18) `jmp print_string`

Au tour du caractère suivant.

(19) `ret`

Le message est affiché, on sort de la routine.

(20) `times 510-($-$$) db 0`

Un truc de nasm qui va remplir de zéro jusqu'au 510ème octet.

(21) `dw 0xaa55`

La signature du _boot sector_.

### Assemblage et test dans Qemu

À l'aide de nasm, on transforme le code source en un fichier binaire qu'on
pourra ensuite utiliser comme secteur de boot :

    nasm boot.nasm -f bin -o boot

- `boot.nasm` : le fichier à assembler
- `-f bin` : format binaire, aussi appelé plat, c'est à dire sans header
- `-o boot` : le nom du fichier en sortie

Assurez vous que le fichier `boot` mesure bien exactement 512 octets.

Puis on utilise l'émulateur de PC [Qemu](https://www.qemu.org/) pour tester ce
fichier binaire. Un émulateur ne remplace pas le matériel réel, mais il nous
permet d'accélerer grandement la vitesse de développement.

    qemu-system-i386 -hda boot

- `-hda boot` : le fichier boot est utilisé comme image du premier disque dur

### Test sur ordinateur physique

Je transfère le fichier `boot` sur une clé USB, que j'utilise pour _booter_ sur
trois ordinateurs de test. Deux laptops d'une dizaine d'années et un desktop de
20 ans. D'abord il faut déterminer le nom du _device_ à utiliser pour la clé USB :

    sudo fdisk -l

Ensuite on copie le fichier sur la clé. Il va s'installer naturellement au
début, donc sur le premier secteur :

    sudo cp boot /dev/sdx   # <<< remplacez x par la bonne lettre ;)

Attention quand même, si vous vous plantez de _device_ vous perdez ses données.
Vérifier plusieurs fois la commande.

Sur les trois ordinateurs, deux affichent parfaitement le message. Mais sur la
machine la plus récente, le message est tronqué et n'affiche que "Welcome ".
2 sur 3 c'est un bon score pour un premier essai. Je réglerai ce problème dans
un prochain article.

## Glossaire

**BIOS** — Basic Input Output System

_Système élémentaire d'entrée/sortie présent dans la ROM des ordinateurs_
_compatibles PC._

**PC** — Personal Computer

_Ordinateur compatible PC, basé sur les microprocesseurs de la famille x86._

## Références

- [Code complet de BLONK! v0.0.1](https://github.com/lkdjiin/blonk/tree/v0.0.1)
- [L'assembleur nasm](https://www.nasm.us/)
- [L'émulateur Qemu](https://www.qemu.org/)
- [BIOS](https://wiki.osdev.org/BIOS)
- [int 10h ah=0Eh](https://www.ctyme.com/intr/rb-0106.htm)


{% include serie_blonk.md %}
