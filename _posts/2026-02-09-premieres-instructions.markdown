---
layout: post
title: "Premières instructions"
date: 2026-02-09 8:00
comments: true
tags: [ retro, 8bits ]
---

Suite à l'expérience du dernier article je sais maintenant un peu mieux ce que
fait le processeur 6502 au démarrage. Il va chercher l'adresse mémoire de début
d'un programme. Cette adresse est rangée aux adresses `$fffc` et `$fffd`. On va
écrire ce programme dans la ROM, pour qu'il soit exécuté à chaque démarrage/reset.

<!-- more -->

Une petite mise en garde avant de commencer : pour écrire un nombre hexadécimal
j'utilise indifféremment la notation `0x12ab` et `$12ab`.

## Démarrer en $8000

Programmons la ROM pour qu'elle contienne une adresse de début de programme.

Ça pourrait faire mal au crâne. Voici quelques rappels :
- Le processeur possède un espace d'adressage de 64Ko.
- La ROM fait 32Ko. La dernière fois je l'ai mappée dans l'espace d'adressage du processeur aux adresses `$8000` à `$ffff`.

Notre programme devra débuter à l'adresse `$8000` :

{% highlight ruby %}
rom[0x7ffc] = 0x00
rom[0x7ffd] = 0x80
{% endhighlight %}

`0x7ffc` et `0x7ffd` sont les adresses
dans la ROM physique. Elles seront accessibles aux adresses `$fffc` et
`$fffd` pour le processeur (puisque la ROM est mappée sur les 32Ko supérieurs).
Pour `0x00` et `0x80`, il ne faut pas oublier que le 6502 fonctionne en little-endian
et c'est donc bien le nombre `$8000`.

Je produis la ROM :

    $ ruby make_rom.rb

Et je confirme ce qu'elle contient :

    $ hexdump -C rom.bin
    00000000  ea ea ea ea ea ea ea ea  ea ea ea ea ea ea ea ea  |................|
    *
    00007ff0  ea ea ea ea ea ea ea ea  ea ea ea ea 00 80 ea ea  |................|
    00008000

Si on replace la ROM, on doit maintenant voir le processeur démarrer à l'adresse `$8000` après un reset.

## Deux instructions

On veut placer ce programme assembleur dans la ROM :

    lda $42   // Charger la valeur $42 dans le registre A
    sta $6000 // Placer le contenu de A à l'adresse $6000

On se retrouve a tout faire à la main comme les pionniers ;) Il faut l'assembler
manuellement.
D'abord on doit trouver à quels opcodes correspondent ces instructions.
On peut regarder dans la datasheet du processeur, ou [en ligne](https://llx.com/Neil/a2/opcodes.html).

Le programme ruby pour produire la ROM devient alors :

{% highlight ruby %}
LDA_IMM = 0xa9
STA_ABS = 0x8d

rom = Array.new(32_768, 0xea)

rom[0] = LDA_IMM # Opcode de l'instruction lda avec adressage immédiat.
rom[1] = 0x42    # Opérande de lda.
rom[2] = STA_ABS # Opcode de l'instruction sta avec adressage absolu.
rom[3] = 0x00    # Opérande de sta, octet de poid faible.
rom[4] = 0x60    # Opérande de sta, octet de poid fort.
rom[0x7ffc] = 0x00
rom[0x7ffd] = 0x80

File.open("rom.bin", "wb") do |file|
  file.write(rom.pack("C*"))
end
{% endhighlight %}


Je montre le _dump_ pour qu'on comprenne bien comment c'est agencé dans la ROM :

    $ hexdump -C rom.bin
    00000000  a9 42 8d 00 60 ea ea ea  ea ea ea ea ea ea ea ea  |.B..`...........|
    00000010  ea ea ea ea ea ea ea ea  ea ea ea ea ea ea ea ea  |................|
    *
    00007ff0  ea ea ea ea ea ea ea ea  ea ea ea ea 00 80 ea ea  |................|
    00008000

Je rebranche tout et je monitore le processeur avec l'arduino.

|-----------------|------------|------|-----|---|-------------|
| Adresse (B)     | Données (B)| A    | R/W | D | Commentaire
|-----------------|------------|------|-----|---|-------------|
|1111111111111111 | 11101010   | ffff | R | ea  | Début du reset
|1110101100000111 | 11101010   | eb07 | R | ea  |
|0000000111111010 | 11101010   | 01fa | R | ea  |
|0000000111111001 | 11101010   | 01f9 | R | ea  |
|0000000111111000 | 11101010   | 01f8 | R | ea  |
|1111111111111100 | 00000000   | fffc | R | 00  | Lecture adresse programme
|1111111111111101 | 10000000   | fffd | R | 80  | Lecture adresse programme
|1000000000000000 | 10101001   | 8000 | R | a9  | Instruction `lda`
|1000000000000001 | 01000010   | 8001 | R | 42  | Opérande
|1000000000000010 | 10001101   | 8002 | R | 8d  | Instruction `sta`
|1000000000000011 | 00000000   | 8003 | R | 00  | Opérande
|1000000000000100 | 01100000   | 8004 | R | 60  | Opérande
|0110000000000000 | 01000010   | 6000 | W | 42  | Écriture $42 à l'adresse $6000
|1000000000000101 | 11101010   | 8005 | R | ea  | Instruction `nop`
|1000000000000110 | 11101010   | 8006 | R | ea  | Instruction `nop`
|1000000000000110 | 11101010   | 8006 | R | ea  | Instruction `nop`

- Adresse (B) => Contenu du bus d'adresse, en binaire
- Données (B) => Contenu du bus de données, en binaire
- A => Contenu du bus d'adresse, en hexadécimal
- R/W => Mode lecture (R) ou écriture (W)
- D => Contenu du bus de données, en hexadécimal

## Conclusion

C'était un premier programme. Il ne fait peut-être pas grand chose, mais il le
fait ! Et comme rien n'a explosé ou grillé, je trouve ça très encourageant ;)


{% include serie_ordi_8bits.md %}
