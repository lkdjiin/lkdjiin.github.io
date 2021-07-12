---
layout: post
title: "Implémenter un langage sur Parrot - partie 9: la syntaxe"
date: 2013-08-18 08:01
legacy: true
tags: [parrot, ruby]
---

Après avoir écrit un 
[tokenizer](http://lkdjiin.github.io/blog/2013/08/12/parrot-6-ecrire-le-tokenizer/),
avoir produit les [unités lexicales](http://lkdjiin.github.io/blog/2013/08/13/implementer-un-langage-sur-parrot-partie-7-le-lexer/)
et avoir défini
[une grammaire](http://lkdjiin.github.io/blog/2013/08/17/implementer-un-langage-sur-parrot-partie-8-la-grammaire/)
pour le langage Naam, je passe maintenant à la vérification de la syntaxe.

<!-- more -->

La vérification de la syntaxe se passe dans la classe `Compiler`. *- C'est pas
le meilleur choix de nom et ça changera par la suite -*. Basiquement, cette
classe ne fait que suivre la logique de la grammaire.

{% highlight ruby %}
class Compiler

  # units - Array of LexicalUnits
  def compile units
    @units = units
    program
  end

  private

  def program
    while @units.size > 0
      case @units.first.type
      when :eol then accept(:eol)
      else
        instruction
      end
    end
  end

  def instruction
    case @units.first.type
    when :keyword then print_statement
    when :word then function_def
    else
      raise Error
    end
  end

  def print_statement
    accept(:keyword, 'print')
    accept_series(:word, :paro, :int, :parc, :eol)
  end

  def function_def
    accept_series(:word, :paro, :word, :parc, :affect, :eol)
    if_clause while if_clause?
    else_clause
  end

  def if_clause
    accept(:int)
    accept(:keyword, 'if')
    test
    accept(:eol)
  end

  def else_clause
    accept(:int)
    accept(:keyword, 'else')
    accept(:eol)
  end

  def test
    accept_series(:word, :op, :int)
  end

  def accept(type, value = '')
    unit = @units.slice!(0)
    raise Error unless unit.type == type
    if value != ''
      raise Error unless unit.value == value
    end
  end

  def accept_series(*args)
    args.each {|arg| accept(arg) }
  end

  def if_clause?
    @units[1].type == :keyword && @units[1].value == 'if'
  end
end
{% endhighlight %}

Quelques commentaires sur ce code:

{% highlight ruby %}
def instruction
  # ...
  else
    raise Error
  end
end
{% endhighlight %}

Plusieurs fois j'utilise la classe `Error`, qui n'existe pas. C'est parce que
je ne veux pas encore réfléchir à la gestion des erreurs. Les seuls cas qui
m'intéressent pour l'instant sont ceux où ça fonctionne.

{% highlight ruby %}
def accept(type, value = '')
  unit = @units.slice!(0)
  raise Error unless unit.type == type
  if value != ''
    raise Error unless unit.value == value
  end
end
{% endhighlight %}

C'est la méthode `accept`, toute simple, qui effectue la vérification
de la syntaxe en comparant l'unité lexicale attendue avec celle réellement
disponible. On constate que les unités lexicales (représentées par `@units`)
sont détruites au fur et à mesure de leur consommation.

La prochaine, il sera enfin temps d'émettre le code PIR.





À demain.

