---
layout: post
title: "Parrot 6: Écrire le tokenizer"
date: 2013-08-12 09:05
legacy: true
tags: [parrot, naam]
---



Après avoir défini un semblant de
[méthode de travail](http://lkdjiin.github.io/blog/2013/08/11/parrot-5-un-plan-pour-ecrire-un-compilateur/)
on s'attaque aujourd'hui à l'écriture d'un
[tokenizer](http://en.wikipedia.org/wiki/Tokenization)
pour Naam.

<!-- more -->

Le tokenizer
------------
Le code du projet est en ligne sur Github à l'adresse suivante:
[naam](https://github.com/lkdjiin/naam).
N'hésitez pas à le consulter. Les extraits qui suivront sont tirés de la
version 0.0.1.

La *tokenization* est le processus de séparation des éléments 
basiques d'un langage.
C'est la première étape de l'analyse lexicale.
Par exemple, à partir du programme suivant:

    sign(n)=
    1  if n > 0
    -1 if n < 0
    0  else

    print sign(4)

Je veut obtenir la suite de tokens suivante:

    sign
    (
    n
    )
    =

    1
    if
    n
    >
    0

    -1
    if
    n
    <
    0

    0
    else


    print
    sign
    (
    4
    )

Je vais d'abord introduire la classe `Main`, qui est certainement
temporaire et aussi (exceptionnellement) la seule à ne pas être
testée. Elle est juste là pour me permettre de visualiser les
résultats.
Le principe est très simple:

{% highlight ruby %}
class Main
  def self.run(filename)
    source_lines = Reader.read filename
    source_lines.each do |line|
      tkr = Parser::Tokenizer.new(line)
      while tkr.has_more_token?
        puts tkr.next_token
      end
    end
  end
end
{% endhighlight %}


Maintenant, on passe au truc intéressant, le tokenizer
proprement dit:

{% highlight ruby %}
module Naam::Parser

  # Internal: Tokenize a string of naam code.
  class Tokenizer

    # Public: Initialize a new Tokenizer object, ready to
    # tokenize a string of naam code.
    #
    # code - A String of naam code.
    def initialize code
      @index = 0
      @token = ''
      @look_ahead = ''
      @codeline = code
      forward_look_ahead
    end

    # Public: Get the next token from the code.
    #
    # Returns The String token.
    def next_token
      token = produce_next_token
      skip_white
      @token = ''
      token
    end

    # Public: Tells if a token is available.
    #
    # Returns Boolean.
    def has_more_token?
      @index <= @codeline.size
    end

    private

    # Look to the next character in the code.
    #
    # Returns nothing.
    def forward_look_ahead
      @look_ahead = @codeline[@index, 1]
      @index += 1
    end

    # Returns the String next available token.
    def produce_next_token
      if @look_ahead =~ /[0-9]/
        get_integer
      elsif @look_ahead == '('
        get_paro
      elsif @look_ahead == ')'
        get_parc
      elsif @look_ahead == '='
        get_eq
      elsif @look_ahead == "\n"
        get_eol
      else
        get_word
      end
    end

    # Skip all «white» characters until next non-white one.
    # Currently only spaces are considered as white.
    #
    # Returns nothing.
    def skip_white
      forward_look_ahead while @look_ahead == ' '
    end

    # Returns a String of what naam considered an integer.
    def get_integer
      add_look_ahead while @look_ahead =~ /[0-9]/
      @token
    end

    # Returns String opened parenthesis.
    def get_paro; add_this_char; end

    # Returns String closed parenthesis.
    def get_parc; add_this_char; end

    # Returns String equal symbol "=".
    def get_eq; add_this_char; end

    # Returns String end of line "\n".
    def get_eol; add_this_char; end

    # Add current character to the current token and return it.
    # Usefull shorthand for single character's tokens.
    #
    # Returns the String current token.
    def add_this_char
      add_look_ahead
      @token
    end

    # If it's not anything else, it's what naam language call a word.
    #
    # Returns String.
    def get_word
      add_look_ahead while not @look_ahead =~ /[\(\)=\n ]/
      @token
    end

    # Add current character to current token, then look for the
    # next char, ready for another cycle.
    #
    # Returns nothing.
    def add_look_ahead
      @token << @look_ahead
      forward_look_ahead
    end

  end
end
{% endhighlight %}

Chaque méthode est suffisament documentée pour que vous puissiez
comprendre la logique de la bestiole. La prochaine fois on s'attaque
au *lexer*.





À demain.


