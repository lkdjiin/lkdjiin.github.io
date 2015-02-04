---
layout: post
title: "Une machine de Turing en Ruby - La routine de copie"
date: 2015-02-04 10:22
comments: true
categories: [ruby, intermédiaire, turing]
---

{% level 2 %}

La routine de copie est une brique élémentaire d'un programme pour une machine
de Turing. Par exemple, si les données de la bande sont `111`, la routine de
copie va doubler ces trois symboles en insérant un zéro au milieu: `1110111`.

{% img center /images/copie-clone.jpg %}

<!-- more -->

Je ne vais pas expliquer la routine de copie
— [cet article de Wikipédia](http://en.wikipedia.org/wiki/Turing_machine_examples#A_copy_subroutine)
le fait très bien — mais plutôt montrer comment j'ai du adapter
[ma machine de Turing](https://github.com/lkdjiin/turing_machine)
pour pouvoir faire tourner cette routine.

Voici le jeu d'instructions de la routine de copie:

``` raw copy_with_data
0 A  => 1 L B
0 B  => 1 N s1
0 s1 => N N HALT
1 s1 => 0 R s2
0 s2 => 0 R s3
1 s2 => 1 R s2
0 s3 => 1 L s4
1 s3 => 1 R s3
0 s4 => 0 L s5
1 s4 => 1 L s4
0 s5 => 1 R s1
1 s5 => 1 L s5
```

C'est en deux parties, les deux premières lignes écrivent des données sur la
bande (le nombre `11`) et les neuf dernières lignes sont effectivement la
routine de copie. Une des limitations actuelles de ma machine de Turing est de
ne pas pouvoir initialiser la bande avec des données spécifiques, il faut donc
le faire depuis le programme, comme ici les deux premières lignes.

Les nouveautés dans ce jeu d'instructions sont les caractères `N`, qu'on peut
trouver dans les symboles à écrire et dans le mouvement de la tête de lecture,
par exemple dans la 3ème ligne:

    0 s1 => N N HALT

Cela signifie pas d'écriture et pas de mouvement (**N**o write, **N**o move).

Le parser étant déjà capable d'attraper n'importe quel mot/symbole, il suffit de
faire évoluer la méthode de mise à jour de la bande ainsi (c'est un peu lourd
comme écriture mais ça reste clair et pragmatique):

``` ruby lib/turing_machine/instance.rb
module TuringMachine

  class Instance

  [...]

    def update_tape(current_action)
      @tape.head = current_action[:write] unless current_action[:write] == 'N'
      @tape.shift_left if current_action[:move] == 'L'
      @tape.shift_right if current_action[:move] == 'R'
    end

  [...]
```

Et maintenant la routine de copie fonctionne !

    $ turing_machine instruction_sets/copy_with_data
      1 0000000000000000000000000000000000000000 A -> 1LB
                           ^
      2 0000000000000000000100000000000000000000 B -> 1Ns1
                          ^
      3 0000000000000000001100000000000000000000 s1 -> 0Rs2
                          ^
      4 0000000000000000000100000000000000000000 s2 -> 1Rs2
                           ^
      5 0000000000000000000100000000000000000000 s2 -> 0Rs3
                            ^
      6 0000000000000000000100000000000000000000 s3 -> 1Ls4
                             ^
      7 0000000000000000000101000000000000000000 s4 -> 0Ls5
                            ^
      8 0000000000000000000101000000000000000000 s5 -> 1Ls5
                           ^
      9 0000000000000000000101000000000000000000 s5 -> 1Rs1
                          ^
     10 0000000000000000001101000000000000000000 s1 -> 0Rs2
                           ^
     11 0000000000000000001001000000000000000000 s2 -> 0Rs3
                            ^
     12 0000000000000000001001000000000000000000 s3 -> 1Rs3
                             ^
     13 0000000000000000001001000000000000000000 s3 -> 1Ls4
                              ^
     14 0000000000000000001001100000000000000000 s4 -> 1Ls4
                             ^
     15 0000000000000000001001100000000000000000 s4 -> 0Ls5
                            ^
     16 0000000000000000001001100000000000000000 s5 -> 1Rs1
                           ^
     17 0000000000000000001101100000000000000000 s1 -> NNHALT
                            ^
     18 0000000000000000001101100000000000000000 HALT


Le code est [sur Github](https://github.com/lkdjiin/turing_machine), à plus tard.

{% connexe %}
