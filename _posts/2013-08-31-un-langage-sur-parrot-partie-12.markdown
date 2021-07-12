---
layout: post
title: "Un langage sur Parrot - partie 12"
date: 2013-08-31 11:02
legacy: true
tags: [parrot, naam, ruby]
---



Dans le dernier épisode, j'utilisais un AST pour capturer la grammaire
de Naam, et le code n'était pas très propre. Cette fois je nettoie un peu
tout ça en mettant les règles de grammaire dans leur propres classes.

<!-- more -->

De ce fait, le syntaxer a beaucoup maigri puisqu'il se contente
maintenant de lancer la première règle:

{% highlight ruby %}
module Naam

  # Public: Here we transform a list of lexical units in an AST.
  class Syntaxer

    def initialize
      @ast = AST.new "ast"
    end

    # Public: Compile lexical units from a Naam program in an AST.
    #
    # units - Array of LexicalUnits
    #
    # Returns the AST.
    def run units
      ProgramRule.new(units, @ast).apply!
      @ast
    end

  end
end
{% endhighlight %}



Voici la règle de base:

{% highlight ruby %}
module Naam
  class BaseRule

    def initialize(units, ast_node)
      @units = units
      @ast_node = ast_node
      @series = []
    end

    def apply!
      raise NotImplementedError
    end

    private

    def accept(type, value = '')
      unit = @units.slice!(0)
      @series << unit
      raise Error unless unit.type == type
      if value != ''
        raise Error unless unit.value == value
      end
    end

    def accept_series(*args)
      args.each {|arg| accept(arg) }
    end

  end
end
{% endhighlight %}

Reste à écrire une classe par règle de grammaire. Voici par exemple la 
règle pour la `else clause`:

{% highlight ruby %}
module Naam
  class ElseClauseRule < BaseRule
    def apply!
      accept(:int)
      accept(:keyword, 'else')
      accept(:eol)
      else_node = ElseClauseAST.new
      else_node.add_child(ReturnValueAST.new(@series[0].value))
      @ast_node.add_child(else_node)
    end
  end
end
{% endhighlight %}

La prochaine étape sera de sortir le code PIR à partir de l'AST.





À demain.


