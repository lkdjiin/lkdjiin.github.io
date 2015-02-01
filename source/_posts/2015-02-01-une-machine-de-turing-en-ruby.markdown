---
layout: post
title: "Une machine de Turing en Ruby"
date: 2015-02-01 10:11
comments: true
categories: [ruby, intermédiaire, turing]
---

{% level 2 %}

Avec le film *Imitation Game* sorti récemment, Alan Turing, qu'on peut considérer
comme un père fondateur de l'informatique, fait l'actualité.
Je vous propose, dans cet article, de réaliser une machine de Turing en Ruby.

{% img center /images/alan-turing2.jpg %}

<!-- more -->

## Définition de la machine de Turing

Ma définition personnelle sera la suivante:

**Une machine de Turing est une machine imaginaire et hyper-minimale, pouvant
faire tourner un algorithme.**

Si vous ressentez le besoin d'une définition plus formelle, les articles de
Wikipédia, en [anglais](http://en.wikipedia.org/wiki/Turing_machine)
et en [français](http://fr.wikipedia.org/wiki/Machine_de_Turing)
sont très bien fourni. Il y a aussi une présentation sympathique de la machine de
Turing dans une petite [vidéo en français](http://videotheque.cnrs.fr/doc=3001)
de 7 minutes, par le CNRS.

Dans la suite de l'article, je prends comme hypothèse que vous savez ce qu'est
une machine de Turing. Si ça n'est pas le cas, ou si vous avez besoin de vous
rafraichir la mémoire, n'hésitez pas à visiter les liens précédents.

## On fait une gem ?

À terme, j'aimerais un programme qui puisse faire tourner n'importe quel jeu
d'instructions. Mais pour un premier jet, concret, rapidement réalisable, et
malgré tout intéressant,
on va faire tourner un [busy beaver](http://en.wikipedia.org/wiki/Busy_beaver)
à 3 états.

Deux trucs à noter:

1. *Busy beaver à 3 états* ça peut faire peur. Je vous assure qu'il n'y a pas
   de quoi. C'est un algorithme relativement simple.
2. *Busy beaver* se traduit par *castor affairé*, c'est bien la preuve qu'il n'y
   a pas de quoi avoir peur.

Comme je veux une structure bien claire dès le départ, et pas un script vite
fait qu'on aura toutes les peines du monde à étendre, je vais faire une gem:

    $ bundle gem turing_machine -btV
          create  turing_machine/Gemfile
          create  turing_machine/Rakefile
          create  turing_machine/LICENSE.txt
          create  turing_machine/README.md
          create  turing_machine/.gitignore
          create  turing_machine/turing_machine.gemspec
          create  turing_machine/lib/turing_machine.rb
          create  turing_machine/lib/turing_machine/version.rb
          create  turing_machine/bin/turing_machine
          create  turing_machine/.rspec
          create  turing_machine/spec/spec_helper.rb
          create  turing_machine/spec/turing_machine_spec.rb
          create  turing_machine/.travis.yml
    Initializing git repo in /home/xavier/devel/ruby/turing_machine

Vous pouvez trouver le code sur Github : [lkdjiin/turing_machine](https://github.com/lkdjiin/turing_machine).

## Objectif de la première version

Mon objectif est d'obtenir cette sortie quand je lance le programme
`turing_machine`:

    $ turing_machine 
      1 0000000000 A -> 1RB
            ^
      2 0000100000 B -> 1LA
             ^
      3 0000110000 A -> 1LC
            ^
      4 0000110000 C -> 1LB
           ^
      5 0001110000 B -> 1LA
          ^
      6 0011110000 A -> 1RB
         ^
      7 0111110000 B -> 1RB
          ^
      8 0111110000 B -> 1RB
           ^
      9 0111110000 B -> 1RB
            ^
     10 0111110000 B -> 1RB
             ^
     11 0111110000 B -> 1LA
              ^
     12 0111111000 A -> 1LC
             ^
     13 0111111000 C -> 1RHALT
            ^
     14 0111111000 HALT
             ^

Explication d'une ligne de la sortie:

      5 0001110000 B -> 1LA
          ^
- Le `5` est le numéro de la séquence.
- La suite de `0` et de `1` est le ruban.
- Le `^` est la position de la tête de lecture.
- Le `B` est l'état courant.
- La fin, ici `1LA`, est la prochaine instruction à exécuter.

Une instruction est composé a) du symbole à écrire, b) du mouvement de la
tête de lecture et, c) du nouvel état. Par exemple `1LA` signifie: écrire `1`,
bouger la tête de lecture à gauche (`L`) et passer dans l'état `A`.

## Une classe pour le ruban et la tête de lecture

On commence par une classe `Tape` (ruban), que je combine avec `head` (tête de
lecture) pour aller plus vite.

``` ruby
class Tape

  def initialize
    @symbols = Array.new(10) { '0' }
    @index = 4
  end

  attr_reader :index

  def head
    @symbols[@index]
  end

  def head=(symbol)
    @symbols[@index] = symbol
  end

  def shift_left
    @index -= 1
  end

  def shift_right
    @index += 1
  end

  def to_s
    @symbols.join
  end
end
```

Il faut noter qu'une machine de Turing possède un ruban avec un nombre infini
de cellules. Ici ça n'est pas le cas puisqu'il n'y en a que 10. C'est un
raccourci qui permet d'aller plus vite, de garder le code simple, et 10 cellules
sont largement suffisantes pour le *busy beaver à 3 états*.

{% img center /images/castor2.png %}

## Une classe pour le registre d'état

Avoir une classe dédiée à conserver l'état peut sembler
[overkill](http://fr.wikipedia.org/wiki/Overkill). Et pour être honnête, je dois
dire que ça l'est certainement. Une simple variable aurait été suffisante pour
cette première version. Mais bon, je suis sûr que cette classe sera bientôt
utile ;)

``` ruby
class StateRegister

  def initialize(state)
    @state = state
  end

  def current
    @state
  end

  def change(new_state)
    @state = new_state
  end

  def to_s
    @state.to_s
  end
end
```

## Une classe pour la table d'instructions

Ici aussi, j'aurais pu (du ?) faire appel au
[YAGNI](http://en.wikipedia.org/wiki/You_aren%27t_gonna_need_it).
Un simple hash pourrait faire l'affaire pour l'instant.

``` ruby
class Instruction

  def initialize(table)
    @table = table
  end

  def for(symbol, state)
    @table[[symbol, state]]
  end

end
```

## Une instance d'une machine de Turing

Les trois petites classes ci-dessus vont se combiner à l'intérieur de la
classe `Instance` suivante, pour simuler une machine de Turing. Même si elle
est un peu plus complexe que les précédentes, cette classe reste malgré tout
très simple.

``` ruby
class Instance

  def initialize(instructions, initial_state)
    @instruction = Instruction.new(instructions)
    @state = StateRegister.new(initial_state)
    @tape = Tape.new
    @sequence = 1
  end

  def to_s
    "#{'%3d' % @sequence} #{@tape} #{@state}#{instr_to_s}\n    " +
    ' ' * @tape.index + '^'
  end

  def proceed
    current = action
    update_sequence
    update_tape(current)
    update_state(current)
  end

  def halted?
    @state.current == 'HALT'
  end

  private

  def update_sequence
    @sequence += 1
  end

  def update_tape(current_action)
    @tape.head = current_action[:write]
    current_action[:move] == 'L' ? @tape.shift_left : @tape.shift_right
  end

  def update_state(current_action)
    @state.change(current_action[:next_state])
  end

  def action
    @instruction.for(@tape.head, @state.current)
  end

  def instr_to_s
    if halted?
      ''
    else
      " -> " + action[:write] + action[:move] + action[:next_state]
    end
  end
end
```

## Le binaire

Enfin quand je dis le binaire c'est un abus de langage puisque ça reste un
fichier texte ;) Quoiqu'il en soit voici le programme `turing_machine` qui
implémente le *busy beaver à 3 états*.

``` ruby bin/turing_machine
#!/usr/bin/env ruby

require 'turing_machine'

include TuringMachine

instructions = {
  ['0', 'A'] => {write: '1', move: 'R', next_state: 'B'},
  ['1', 'A'] => {write: '1', move: 'L', next_state: 'C'},
  ['0', 'B'] => {write: '1', move: 'L', next_state: 'A'},
  ['1', 'B'] => {write: '1', move: 'R', next_state: 'B'},
  ['0', 'C'] => {write: '1', move: 'L', next_state: 'B'},
  ['1', 'C'] => {write: '1', move: 'R', next_state: 'HALT'},
}

initial_state = 'A'

instance = Instance.new(instructions, initial_state)

loop do
  puts instance.to_s
  break if instance.halted?
  instance.proceed
end
```

Cette version ([voir le code complet](https://github.com/lkdjiin/turing_machine)) est juste une mise en train. Il faudrait maintenant disposer
d'un ruban infini et pouvoir entrer n'importe quel jeu d'instructions.

À plus tard.

{% connexe %}
