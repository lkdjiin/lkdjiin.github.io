---
layout: post
title: "Un langage sur Parrot - partie 13"
date: 2013-09-01 21:02
comments: true
categories: [parrot, ast, naam, ruby, intermédiaire]
---
{% level 2 %}

Après avoir utilisé un AST pour représenter le code source de Naam,
je parcours cet AST pour sortir le code assembleur PIR pour la machine
virtuelle Parrot.

<!-- more -->

Voici la méthode principale (et temporaire):

``` ruby
def self.run(filename)
  .
  .
  .
  syntaxer = Syntaxer.new
  ast = syntaxer.run(units.dup)

  organizer = Organizer.new(ast)
  ast = organizer.reorganize

  emitter = Emitter.new(ast)
  pir_code = emitter.pir_code
  puts pir_code
end
```

La classe Syntaxer se charge de transformer la suite d'unités lexicales
en un arbre syntaxique abstrait (AST). La classe Organizer va en
quelque sorte réorganiser l'arbre, par exemple en regroupant les instructions
qui ne sont pas dans une fonction à l'intérieur d'une fonction principale
PIR.
Quant à la classe Emitter, elle est chargée de transformer l'AST en code PIR.

Voici un extrait de cette classe Emitter:

``` ruby
module Naam
  class Emitter

    def initialize(ast)
      @ast = ast.dup
      @code = ""
      @label = "LABEL0000"
      @labels = []
    end

    # Public: Get PIR code.
    #
    # Returns PIR code as a String.
    def pir_code
      compile(@ast)
      @code
    end

    private

    def compile(node)
      case node
      when MainAST then compile_main(node)
      when FunctionHeaderAST then compile_header(node)
      when IfClauseAST then compile_if_clause(node)
      when ElseClauseAST then compile_else_clause(node)
      when FunctionFooterAST then compile_footer(node)
      end
      node.children.each {|child| compile(child) }
    end

    ...

    def compile_header(node)
      name = node.children.first.value
      arg = node.children.last.value
      @code += ".sub #{name}\n"
      @code += "    .param int #{arg}\n"
      @code += "    .local int result\n"
    end

    ...

    # Get the next label.
    #
    # value - The String value attached to the label.
    #
    # Examples
    #
    #   next_label
    #   # => {name: "LABEL0001", value: "123"}.
    #
    # Returns a Hash.
    def next_label(value)
      label = {name: @label.next!.dup, value: value}
      @labels << label
      label
    end

  end
end
```

La prochaine fois, le compilateur sera fonctionnel.

À demain.

{% connexe %}

