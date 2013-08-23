---
layout: post
title: "Implémenter un langage sur Parrot - partie 8: la grammaire"
date: 2013-08-17 09:29
comments: true
categories: [intermédiaire, parrot, naam, bnf, compilateur]
---
{% level 2 %}

Écrire un langage sans en spécificier la grammaire c'est un peu comme se
tirer une balle dans le pied. Même quand le langage est aussi simple et
petit que
Naam (voir l'[article originel](http://lkdjiin.github.io/blog/2013/08/01/implementer-un-langage-sur-la-machine-virtuelle-parrot-partie-1/)),
c'est un gain de temps pour la suite.

<!-- more -->

Pour spécificier la grammaire d'un langage informatique, on utilise
généralement la
[BNF](http://fr.wikipedia.org/wiki/Forme_de_Backus-Naur),
(Backus Naur Form) ou l'une de ses extensions. Il n'est pas rare qu'un auteur
utilise une version personnalisée de la BNF, et c'est ce que je vais faire
pour Naam.

Voici les quelques règles de la méta-syntaxe:

    {foo}         zero or more foo
    foo | bar     foo or bar
    foo           a non-terminal foo
    'foo'         keyword foo
    [foo]         zero or one foo
    ---           free speech

Et voici la grammaire de Naam:

    program           ::= {instruction | eol}

    instruction       ::= function_def | print_statement

    print_statement   ::= 'print' word ( int ) eol

    function_def      ::= word ( word ) = eol {if_clause} else_clause

    if_clause         ::= int 'if' test eol

    test              ::= word op int

    else_clause       ::= int 'else' eol

    op                ::= < | >

    eol               ::= --- End of line
    int               ::= --- Integer
    word              ::= --- Anything else

Cette grammaire est vraiment toute petite, mais suffisante pour spécifier
le programme suivant, qui est ce que j'ai choisi pour commencer à écrire
le compilateur Naam:

    sign(n)=
    1 if n > 0
    -1 if n < 0
    0 else

Alors pourquoi écrire une grammaire ? Pourquoi ne pas commencer à coder
directement le compilateur ? Parce qu'il faut bien avouer qu'écrire une
telle grammaire n'a rien d'amusant. Tout d'abord une grammaire, même petite,
possède toujours un certain niveau de complexité qu'il est difficile de 
faire tenir entièrement dans sa tête. En l'écrivant on met à jour certains
problèmes qui sinon resteraient cachés longtemps. Autre intéret d'écrire la
grammaire: chaque règle va devenir un morceau de code ; écrire la grammaire
c'est un peu comme avoir déjà écrit une partie du compilateur.
Dans un prochain article je suivrais cette grammaire pour effectuer la
vérification de la syntaxe.

À demain.

{% connexe %}
