---
layout: post
title: "Implémenter un langage sur la machine virtuelle Parrot: partie 2"
date: 2013-08-02 09:07
legacy: true
tags: [parrot]
---



*Aujourd'hui je m'intéresse à*
[Parrot](http://www.parrot.org/).
*Après une brève description de cette
machine virtuelle, on l'installe et on écrit un premier programme.*

<!-- more -->

Présentation de Parrot
----------------------
La machine virtuelle Parrot offre un nombre illimité de registre,
qui sont de 4 types différents:

* Integer, pour les nombres entiers
* Number, pour les nombres réels
* String, pour les chaînes de caractères
* PMC, pour, en gros, les objets (Polymorphic container)

Les instructions peuvent être entrées sous 4 formes différentes, du plus
haut-niveau vers le plus bas:

1. PIR, *Parrot Intermediate Representation*, qui ressemble à un assembleur
   de haut-niveau.
2. PASM, *Parrot Assembly*, qui est un assembleur classique, sans fioritures.
3. PAST, *Parrot Abstract Syntax Tree*, qui accepte un
   [AST](http://en.wikipedia.org/wiki/Abstract_syntax_tree) en entrée.
4. PBC, *Parrot Byte Code*, le code machine de Parrot.

Est-ce-que j'ai vraiment besoin de dire que, si possible, je me limiterais
à PIR ?

Enfin, Parrot possède un
[Garbage Collector](http://fr.wikipedia.org/wiki/Ramasse-miettes_%28informatique%29).
On aura pas besoin de s'acharner
à libérer la mémoire, Parrot le fait pour nous.


Installation de Parrot
----------------------
Avant de pouvoir jouer avec Parrot, il faut l'installer.
Le point de départ est sur
[www.parrot.org/source.html](http://www.parrot.org/source.html).
Sur ma machine Debian, j'ai d'abord installé la version de Parrot qui se
trouve dans les dépots. Le problème c'est que pas mal d'outils annexes
demandent à avoir un *working repository*, ils ne sont pas inclus dans les
paquets. De plus, les sources ont l'air de contenir pas mal d'exemples.
J'ai donc désinstallé le package pour Debian et rapatrié les sources depuis
Github : [github.com/parrot/parrot](https://github.com/parrot/parrot).
L'installation s'est déroulée sans soucis particuliers. Comme je trouve la
documentation un peu confuse sur ce point, voilà comment j'ai fait ; si ça
peut vous éviter de chercher…

    perl Configure.pl
    make
    make test
    sudo make install

Hello Parrot
------------
On s'attaque enfin à l'écriture du classique *hello world*:

{% highlight nasm %}
.sub main
  say "Hello world"
.end
{% endhighlight %}

On le lance ainsi:

    parrot hello.pir

Maintenant que Parrot est installé et fonctionnel, on va pouvoir écrire quelques
petits programmes en PIR.





À demain.


