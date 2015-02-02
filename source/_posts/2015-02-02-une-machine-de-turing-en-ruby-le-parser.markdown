---
layout: post
title: "Une machine de Turing en Ruby - Le parser"
date: 2015-02-02 18:04
comments: true
categories: [ruby, débutant, turing, parser]
---

{% level 1 %}

La machine de Turing réalisée dans le [dernier article](/blog/2015/02/01/une-machine-de-turing-en-ruby/)
était seulement un brouillon, et elle souffre de plusieurs limitations.
J'aimerais maintenant faire évoluer le programme en permettant à l'utilisateur
de charger un jeu d'instructions quelconque. Pour cela j'aurai besoin
d'un *parser*, qui sera vite écrit grâce à Ruby.

{% img center /images/gears4.jpg %}

<!-- more -->

Un jeu d'instruction pour la machine de Turing ressemblera à ceci (si vous avez
besoin du code, [il est ici](https://github.com/lkdjiin/turing_machine)):

``` raw instruction_sets/busy_beaver_3
0 A => 1 R B
1 A => 1 L C
0 B => 1 L A
1 B => 1 R B
0 C => 1 L B
1 C => 1 R HALT
```

C'est l'algorithme *busy beaver à 3 états* que j'ai utilisé pour coder la
première version de la machine. Il faut écrire un *parser* qui va transformer
ce *code source* en ce hash Ruby, utilisé en interne par la machine:

```
{
  ['0', 'A'] => {write: '1', move: 'R', next_state: 'B'},
  ['1', 'A'] => {write: '1', move: 'L', next_state: 'C'},
  ['0', 'B'] => {write: '1', move: 'L', next_state: 'A'},
  ['1', 'B'] => {write: '1', move: 'R', next_state: 'B'},
  ['0', 'C'] => {write: '1', move: 'L', next_state: 'B'},
  ['1', 'C'] => {write: '1', move: 'R', next_state: 'HALT'},
}
```

Voici le parser, qui est construit autour de la méthode `String#split`.

``` ruby lib/turing_machine/instructions_parser.rb
module TuringMachine

  class InstructionsParser

    def initialize(raw_instructions)
      @lines = raw_instructions.split("\n")
      @instructions = {}
    end

    def parse
      build_instructions
      @instructions
    end

    private

    def build_instructions
      @lines.each do |instruction|
        keys, value = instruction.split('=>')
        key_symbol, key_state = keys.split
        write, move, next_state = value.split
        @instructions[[key_symbol, key_state]] = {
          write: write, move: move, next_state: next_state
        }
      end
    end

  end

end
```

On va l'utiliser comme ça:

``` ruby
raw_instructions = IO.read(ARGV[0])
parser = InstructionsParser.new(raw_instructions)
instructions = parser.parse
```

Je vais expliquer plus en détail. Tout d'abord dans le constructeur, on divise
la grande chaîne de caractères en entrée en autant de lignes indépendantes:

    @lines = raw_instructions.split("\n")

Puis dans la méthode privée `build_instructions`, on itère sur chacune des
lignes pour construire le hash:

    @lines.each do |instruction|

Chaque ligne est d'abord divisé en deux parties, de chaque coté de `=>`:

    keys, value = instruction.split('=>')

La partie des clés (celle de gauche) est à son tour divisé en deux, le symbole
sous la tête de lecture et l'état de la machine:

    key_symbol, key_state = keys.split

Ensuite c'est au tour de la partie de droite, celle qui représente la prochaine
instruction:

    write, move, next_state = value.split

Enfin, on ajoute clé et valeur dans le hash:

    @instructions[[key_symbol, key_state]] = {
      write: write, move: move, next_state: next_state
    }

Pour finir, voici mon premier jeu d'instructions pour une machine de Turing:

``` raw instruction_sets/write101
0 A => 1 R B
0 B => 0 R C
0 C => 1 R HALT
```

Ça fait quoi ? Ça écrit 101, tout simplement :

     turing_machine instruction_sets/write101 
      1 0000000000000000000000000000000000000000 A -> 1RB
                           ^
      2 0000000000000000000100000000000000000000 B -> 0RC
                            ^
      3 0000000000000000000100000000000000000000 C -> 1RHALT
                             ^
      4 0000000000000000000101000000000000000000 HALT

Je vous rappelle que vous pouvez consulter le code de la
[machine de Turing](https://github.com/lkdjiin/turing_machine).

Voilà, avec l'aide de `String#split` il est facile d'écrire un parser simple.
Alors bien sûr, ce parser n'est pas vraiment complet, il manque par exemple la
gestion des erreurs. Mais il y a des choses plus urgentes à implémenter, comme
le mouvement nul, le ruban infini, ou la possibilité de commencer le programme
avec un ruban qui contient des données…

À plus tard.

{% connexe %}
