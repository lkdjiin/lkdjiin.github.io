---
layout: post
title: "Un désassembleur pour Chip8"
date: 2016-01-31 10:25
legacy: true
tags: [ruby, jruby, chip8, émulateur, assembleur]
---

En ce moment je bricole un émulateur pour
[Chip8](https://fr.wikipedia.org/wiki/CHIP-8) en JRuby.  Un des outils que j'ai
écrit en Ruby pour cet émulateur est **c8dasm**, un
[désassembleur](https://fr.wikipedia.org/wiki/D%C3%A9sassembleur) pour Chip8.

{% img center /images/vintage.jpg %}

<!-- more -->

Si vous avez besoin d'un tel outil, si vous voulez étudier l'intérieur d'un
désassembleur, ou si vous êtes simplement curieux, vous trouverez
[le code en ligne](https://github.com/lkdjiin/c8dasm).

Si vous voulez voir ce que ça donne, voici un exemple:

    $ c8dasm MAZE
    200:a21e  LD I, 21e     ;Puts 21e into register I.
    202:c201  RND V2, 01    ;Puts random byte AND 01 into register V2.
    204:3201  SE V2, 01     ;Skip next instruction if V2 = 01.
    206:a21a  LD I, 21a     ;Puts 21a into register I.
    208:d014  DRW V0, V1, 4 ;Draws 4-byte sprite from I at (V0, V1)
    20a:7004  ADD V0, 04    ;V0 = V0 + 04.
    20c:3040  SE V0, 40     ;Skip next instruction if V0 = 40.
    20e:1200  JP 200        ;Jump to location 200.
    210:6000  LD V0, 00     ;Puts the value 00 into register V0.
    212:7104  ADD V1, 04    ;V1 = V1 + 04.
    [...]


