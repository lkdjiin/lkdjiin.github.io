---
layout: post
title: "Un langage sur Parrot - partie 11: Arbre syntaxique abstrait"
date: 2013-08-26 08:48
comments: true
categories: [parrot, ast, naam, ruby, intermédiaire]
---

{% level 2 %}

Dans le dernier épisode, je me suis rendu compte que j'aurais intéret
à utiliser un arbre syntaxique abstrait pour mon petit langage. En
voici une première implémentation.

<!-- more -->

Un arbre syntaxique abstrait (*Abstract Syntax Tree* en anglais, ou AST)
est avant tout une manière de structurer des données:

        A
       / \
      B   C
     / \   \
    D   E   F
       /
      G

On part d'un noeud racine (ici `A`) et on ajoute des branches qui mènent à
d'autres noeuds. On peut distinguer les noeuds terminaux (`D`, `F` et `G`) des
noeuds non-terminaux. 
Les noeuds terminaux, aussi appelés feuilles, contiennent une valeur. Les noeuds
non-terminaux contiennent d'autres noeuds.
C'est une manière pratique de représenter un code source,
l'AST étant (assez) facilement manipulable. Il est dit abstrait dans le sens
où il ne contient pas chaque éléments du langage source. Par exemple, les
parenthèses, les virgules, ou encore les débuts et fins de blocs sont
souvent absents de l'AST. Si vous voulez en savoir plus sur les AST:
[http://en.wikipedia.org/wiki/Abstract_syntax_tree](http://en.wikipedia.org/wiki/Abstract_syntax_tree).

Le code qui suit est sur [Github](https://github.com/lkdjiin/naam),
à la version 0.0.5.

L'objectif est de créer l'AST et de le visualiser ainsi:

    program
      function definition
        header
          name ::= sign
          argument ::= n
        if clause
          return value ::= 1
          test
            left value ::= n
            operator value ::= >
            right value ::= 0
        if clause
          return value ::= -1
          test
            left value ::= n
            operator value ::= <
            right value ::= 0
        else clause
          return value ::= 0
      print statement ::= sign(4)

Voici la classe de base de l'AST:

``` ruby
module Naam::AST
  class Node

    def initialize name
      @name = name
      @children = []
    end

    attr_reader :children, :name

    def add_child child; @children << child; end

    def leaf?; @children.empty?; end

    def display(indent = 0)
      print " " * indent + @name
      print " ::= #{@value}" if leaf?
      puts
      @children.each {|child| child.display(indent + 2) }
    end
  end
end
```

Elle permet entre autres d'ajouter un noeud enfant avec `add_child` et de
déterminer si un noeud est une feuille avec `leaf?`. La méthode `display`,
appliquée sur le noeud racine permettra d'afficher l'arbre complet.

Un noeud non-terminal ressemblera à ça:

``` ruby
module Naam::AST
  class Program < Node
    def initialize
      super("program")
    end
  end
end
```

Pour un noeud terminal (une feuille), on ajoutera simplement une valeur:

``` ruby
module Naam::AST
  class Argument < Node
    def initialize value
      super("argument")
      @value = value
    end
  end
end
```


Comment appliquer tout ça ? Directement dans le *syntaxer*. En voici
quelques extraits:

``` ruby
module Naam::Parser
  class Syntaxer

    def initialize
      # ...
      @ast = Naam::AST::Program.new
    end

    # ...

    def function_def
      node = Naam::AST::FunctionDef.new
      @ast.add_child node
      function_header(node)
      if_clause(node) while if_clause?
      else_clause(node)
    end

    def function_header(node)
      @series = []
      accept_series(:word, :paro, :word, :parc, :affect, :eol)
      f_header = Naam::AST::FunctionHeader.new
      f_header.add_child(Naam::AST::Name.new(@series[0].value))
      f_header.add_child(Naam::AST::Arg.new(@series[2].value))
      node.add_child(f_header)
    end

    # ...

  end
end
```

L'AST va me permettre de faire un truc plus propre (même si cette classe
`Syntaxer` demande toujours un gros *refactoring*) et de manipuler plus
aisement le code source.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

