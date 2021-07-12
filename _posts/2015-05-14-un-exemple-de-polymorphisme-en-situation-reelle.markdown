---
layout: post
title: "Un exemple de polymorphisme en situation réelle"
date: 2015-05-14 19:16
legacy: true
tags: [ruby, avancé, polymorphisme, chip8, assembleur, émulateur]
---



J'écris en ce moment un [émulateur](http://fr.wikipedia.org/wiki/%C3%89mulation)
pour [Chip-8](http://fr.wikipedia.org/wiki/CHIP-8), en Ruby. Dans les outils que
j'écris à coté il y a un [désassembleur](http://fr.wikipedia.org/wiki/D%C3%A9sassembleur) de code Chip-8. Dans ce
désassembleur il y a un bel exemple de polymorphisme.

<!-- more -->

## Un peu de contexte

La classe Opcode permet de faire la correspondance entre un [opcode](http://fr.wikipedia.org/wiki/Langage_machine#Opcode) Chip-8
et une ligne de code assembleur. Un opcode Chip-8 est toujours représenté par
un nombre [hexadécimal](http://fr.wikipedia.org/wiki/Syst%C3%A8me_hexad%C3%A9cimal) de 4 chiffres.

Voici quelques exemples d'opcodes et leur correspondance en assembleur :

    Opcode | Assembleur  | Remarque
    -------|-------------|---------
    2a00   | CALL a00    |
    7012   | ADD V0, 12  | V0 est un registre
    a22e   | LOAD I, 22e | I est un registre

On pourra remarquer (même si ça n'est pas ultra visible avec seulement trois
exemples) que c'est le premier chiffre (ici `2`, `7` et `a`) qui décide du
type d'instruction.

De `0` à `f`, on a donc 16 types possibles, ce qui donne ce genre de code :

{% highlight ruby %}
class Opcode

  def initialize(opcode)
    @opcode = opcode
    @assembly = compute_assembly
    ...
  end

  ...

  private

  def compute_assembly
    case @opcode[0]
    when '0' then "Return this code"
    when '1' then "Return that code"
    when '2' then # ...
    ...
    when 'd' then # ...
    when 'e' then # ...
    when 'f' then # ...
    end
  end

end
{% endhighlight %}

De plus, certains type d'instruction sont partagés en sous type, selon le
quatrième chiffre, ou bien selon les troisième et quatrième, ça dépend. Comme
toujours, on se retrouve à devoir gérer des cas particuliers, et le code
ressemble rapidement à la monstruosité qui suit :

{% highlight ruby %}
def compute_assembly
  case @opcode[0]
  when '0'
    if @opcode == '00e0'
      # do that
    elsif @opcode == '00ee'
      # do that
    else
      # do that
    end
  when '1' then # do that
  when '2' then # do that
  when '3' then # do that
  when '4' then # do that
  when '5' then # do that
  when '6' then # do that
  when '7' then # do that
  when '8'
    case @opcode[3]
    when '0' then # do that
    when '1' then # do that
    when '2' then # do that
    when '3' then # do that
    when '4' then # do that
    when '5' then # do that
    when '6' then # do that
    when '7' then # do that
    when 'e' then # do that
    else
      # do that
    end
  when '9' then ...
  when 'a' then ...
  when 'b' then ...
  when 'c' then ...
  when 'd' then ...
  when 'e'
    # Ici, encore 2 sous-groupes
  when 'f'
    # Ici, encore 10 autres sous-groupes
  end
end
{% endhighlight %}

C'est pas bon, hein ? Pour arranger ça, rien de tel qu'un peu de polymorphisme.
La classe Opcode va donc se contenter de ceci :

{% highlight ruby %}
class Opcode

    def initialize(opcode)
      asm = Assembly.new(opcode)
      @assembly = asm.to_s
    end

end
{% endhighlight %}

Vous devinez que c'est maintenant dans une nouvelle classe `Assembly` que sont géré les différentes
instructions et sous instructions :

{% highlight ruby %}
class Assembly

  def initialize(opcode)
    @opcode = opcode
    @assembly = build_assembly.to_s || ''
  end

  def to_s
    @assembly
  end

  private

  def build_assembly
    klass = Kernel.const_get('Asm' + @opcode[0])
    klass.new(@opcode)
  end

end
{% endhighlight %}

Et bien non, elles sont gérées chacune dans sa classe respective, à savoir
`Asm0`, `Asm1`, `Asm2`, et cetera jusqu'à `Asmf`. Voici un exemple :

{% highlight ruby %}
class Asm2 < AsmBase

  def to_s
    "CALL #{nnn}"
  end

end
{% endhighlight %}

Chacune des classes `Asm0` à `Asmf` hérite de `AsmBase` qui définit le
comportement commun (nnn, kk, x et y sont simplement des conventions de nommage en
assembleur Chip-8) :

{% highlight ruby %}
class AsmBase

  def initialize(opcode)
    @opcode = opcode
  end

  def nnn
    @opcode[1, 3]
  end

  def kk
    @opcode[2, 2]
  end

  def x
    @opcode[1]
  end

  def y
    @opcode[2]
  end

end
{% endhighlight %}

C'est un cas classique d'utilisation du polymorphisme. On troque
un long switch/case (virtuellement infini) pour plusieurs petites classes simples.
Le système est toujours aussi complexe dans son ensemble, mais sa maintenance
est maintenant plus facile.


