---
layout: post
title: "Implémenter un langage sur Parrot - partie 10: émettre le code assembleur"
date: 2013-08-20 10:01
comments: true
categories: [parrot, intermédiaire, compilateur, ruby]
---

{% level 2 %}

Maintenant qu'on a 
[vérifié la syntaxe](http://lkdjiin.github.io/blog/2013/08/18/implementer-un-langage-sur-parrot-partie-9-la-syntaxe/)
de notre petit programme, on peut sortir le code assembleur PIR:

``` ruby lib/naam/main.rb
def self.run(filename)
  # ...
  comp = Compiler.new
  comp.compile(units.dup)
end
```

<!-- more -->

Voici le module Emitter:

``` ruby lib/naam/emitter.rb
module Naam
  module Emitter

    # Output the main procedure.
    #
    # series - An Array of String.
    #
    # Examples
    #
    #   Emitter.main(["foo(4)", "bar(-1)"]
    #   # => .sub main :main
    #   # =>     .local int f
    #   # =>     f = foo(4)
    #   # =>     say f
    #   # =>     f = bar(-1)
    #   # =>     say f
    #   # => .end
    #
    # Returns nothing.
    def self.main(series)
      unless series.empty?
        puts
        puts ".sub main :main"
        puts "    .local int f"
        series.each do |str|
          puts "    f = #{str}"
          puts "    say f"
        end
        puts ".end"
      end
    end

    # Dispatch different kind of emit message.
    #
    # type   - A Symbol in :function_header, :function_footer,
    #          :if_clause, :else_clause and :label.
    # series - An Array of LexicalUnit.
    # label  - Hash like { label: "NAME", value: "123" }. Could be nil.
    #
    # Returns nothing.
    def self.emit(type, series, label)
      case type
      when :function_header then function_header(series)
      when :function_footer then function_footer
      when :if_clause then if_clause(series, label)
      when :else_clause then else_clause(series)
      when :label then label(series, label)
      else
        raise Error
      end
    end

    def self.function_header(series)
      puts ".sub " + series[0].value
      puts "    .param int " + series[2].value
      puts "    .local int result"
      puts
    end

    def self.function_footer
      puts "RETURN:"
      puts "    .return(result)"
      puts ".end"
    end

    def self.if_clause(series, label)
      puts "    if #{series[2].value} #{series[3].value} #{series[4].value} " +
           "goto #{label[:label]}"
    end

    def self.else_clause(series)
      puts "    result = #{series[0].value}"
      puts "    goto RETURN"
    end

    def self.label(series, label)
      puts label[:label] + ":"
      puts "    result = #{label[:value]}"
      puts "    goto RETURN"
    end

  end
end
```

Et voilà quelques morceaux choisis dans la class Compiler pour montrer
son utilisation:

``` ruby lib/naam/compiler.rb
module Naam

  # Public: Here we transform a list of lexical units in a PIR source
  # code. At least this is the goal.
  #
  # The logic of this class try follow the grammar of Naam (see the file
  # grammar.md).
  class Compiler

    def initialize
      @series = []
      @current_label = "LABEL0000"
      @labels = []
      @main = []
    end

    # Public: Compile lexical units from a Naam program in a PIR
    # program.
    #
    # units - Array of LexicalUnits
    #
    # Returns nothing.
    def compile units
      @units = units
      program
    end

    private

    # This is the entry rule.
    #
    # Returns nothing.
    def program
      while @units.size > 0
        @series = []
        case @units.first.type
        when :eol then accept(:eol)
        else
          instruction
        end
      end
      @labels.each {|lbl| emit(:label, lbl) }
      emit(:function_footer)
      Emitter.main(@main)
    end

    # ...

    # Returns nothing.
    def function_def
      accept_series(:word, :paro, :word, :parc, :affect, :eol)
      emit(:function_header)
      if_clause while if_clause?
      else_clause
    end

    # ...

    # Send a message to Emitter module.
    #
    # type  - A Symbol (see Emitter).
    # label - A Hash composed of:
    #         :label - The label name as a String.
    #         :value - The String value that will be returned by
    #                  PIR instructions for this label.
    #         By default, label is nil and unused.
    #
    # Returns nothing.
    def emit(type, label = nil)
      Emitter.emit(type, @series, label)
      @series = []
    end

    # Get a label.
    #
    # value - String value associated to the label.
    #
    # Examples
    #
    #   next_label("123")
    #   # => { label: "LABEL0000", value: "123" }
    #   next_label("-9")
    #   # => { label: "LABEL0001", value: "-9" }
    #
    # Returns the Hash label.
    def next_label(value)
      temp = { label: @current_label, value: value }
      @labels << temp
      @current_label = @current_label.next
      temp
    end
  end
end
```

Maintenant que je le montre, je me rends compte que ce code n'est pas
terrible. Bien que le fichier source à compiler soit extremement simple,
je suis déjà obligé de faire un tas de contorsions, notamment pour sortir
la procédure main. Je pensais que c'était une bonne idée de méler
vérification de la syntaxe et production du code assembleur pour montrer
les relations entre ces deux phases, mais visiblement ça n'aide pas
à la clarté du code. La meilleure solution pour m'en sortir est, je pense,
de me servir d'un AST (Arbre syntaxique abstrait). La prochaine fois je
parlerais donc de l'AST.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

{% connexe %}
