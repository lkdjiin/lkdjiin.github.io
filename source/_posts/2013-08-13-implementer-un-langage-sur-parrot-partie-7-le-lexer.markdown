---
layout: post
title: "Implémenter un langage sur Parrot - partie 7: le lexer"
date: 2013-08-13 10:27
comments: true
categories: [intermédiaire, parrot, compilateur, naam, ruby]
---

{% level 2 %}

Après avoir vu
[la tokenisation](http://lkdjiin.github.io/blog/2013/08/12/parrot-6-ecrire-le-tokenizer/),
on continue aujourd'hui l'analyse
lexicale avec la production des lexèmes.

<!-- more -->

Qu'est-ce qu'un lexème ?
------------------------
Si vous avez le temps, lisez [l'article de wikipédia](http://fr.wikipedia.org/wiki/Lex%C3%A8me).
Sinon voici ma définition pour le domaine qui nous intéresse:

{% blockquote %}
Un lexème (unité lexicale) est un token auquel on attache un type
très basique.
{% endblockquote %}

Par exemple, la phrase «Je mange.» donnerait:

    mot:         Je
    mot:         mange
    ponctuation: .

On pourrait produire un *lexer* plus intelligent qui donnerait:

    mot:         Je
    verbe:       mange
    ponctuation: .

Les langages informatiques étant beaucoup moins complexe que les
langages humains, écrire un *lexer* est souvent une formalité.

Objectif
--------

L'objectif d'aujourd'hui est d'obtenir quelque chose comme ça:

``` console
[~/devel/ruby/naam]$ bin/naam spec/fixtures/sign.naam 
#<Naam::Parser::LexicalUnit:0x8fca2f8 @type=:word, @value="sign">
#<Naam::Parser::LexicalUnit:0x8fca258 @type=:paro, @value="(">
#<Naam::Parser::LexicalUnit:0x8fca0b4 @type=:word, @value="n">
#<Naam::Parser::LexicalUnit:0x8fc9fec @type=:parc, @value=")">
#<Naam::Parser::LexicalUnit:0x8fc9ee8 @type=:affect, @value="=">
#<Naam::Parser::LexicalUnit:0x8fc9de4 @type=:eol, @value="\n">
#<Naam::Parser::LexicalUnit:0x8fc9b8c @type=:int, @value="1">
#<Naam::Parser::LexicalUnit:0x8fc99d4 @type=:keyword, @value="if">
...
```

Le code
-------
Le code source du projet est sur Github, à la
[version 0.0.2](https://github.com/lkdjiin/naam/tree/v0.0.2).

Bien souvent l'étape de tokenisation et de lexification peuvent être
regroupées en une seule et même étape. Là, j'ai choisi de les séparer pour
avoir un code plus simple à montrer. Tout d'abord, voici la classe
`lexical_unit`:

``` ruby lib/naam/parser/lexical_unit.rb
module Naam::Parser

  # A container for lexical units.
  class LexicalUnit
    private_class_method :new

    attr_reader :type, :value

    # type  - Symbol
    # value - String
    def initialize type, value
      @type = type
      @value = value
    end

    def self.int value ; new(:int, value) ; end
    def self.word value ; new(:word, value) ; end
    def self.keyword value ; new(:keyword, value) ; end
    def self.op value ; new(:op, value) ; end
    def self.paro ; new(:paro, "(") ; end
    def self.parc ; new(:parc, ")") ; end
    def self.eol ; new(:eol, "\n") ; end
    def self.affect ; new(:affect, "=") ; end
  end
end
```

J'ai beau chercher, je ne trouve rien à dire d'intelligent sur cette classe.
J'avais prévenu: c'est très simple. Et ça continue, on passe maintenant au
*lexer* proprement dit, qui est tout aussi simple:

``` ruby lib/naam/parser/lexer.rb
module Naam::Parser
  class Lexer
    def from_token(token)
      if token == '('
        LexicalUnit.paro()
      elsif token == ')'
        LexicalUnit.parc()
      elsif token == "\n"
        LexicalUnit.eol()
      elsif token == '='
        LexicalUnit.affect()
      elsif token == '<'
        LexicalUnit.op(token)
      elsif token == '>'
        LexicalUnit.op(token)
      elsif token == 'if'
        LexicalUnit.keyword(token)
      elsif token == 'else'
        LexicalUnit.keyword(token)
      elsif token =~ /[+|-]?\d+/
        LexicalUnit.int(token)
      else
        LexicalUnit.word(token)
      end
    end
  end
end
```

Voilà, on a fini l'analyse lexicale, c'est à dire la première phase
de l'écriture d'un compilateur. La prochaine fois je parlerais de la
grammaire de Naam, ce qui enclenchera la phase d'analyse syntaxique.

À demain.

