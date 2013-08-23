---
layout: post
title: "Parrot 5: un plan pour écrire un compilateur"
date: 2013-08-11 10:47
comments: true
categories: [intermédiaire, parrot, compilateur, naam]
---

{% level 2 %}

Après avoir fini le tour d'horizon de l'assembleur PIR dans
[la quatrième partie](http://lkdjiin.github.io/blog/2013/08/10/implementer-un-langage-sur-la-machine-virtuelle-parrot-partie-4/)
je digresse un peu sur ce qui nous attends dans les prochains épisodes.

<!-- more -->

Un plan pour écrire un compilateur
----------------------------------

Maintenant qu'on sait écrire des programmes en PIR suffisament
évolués pour fournir un début de support au magnifique langage Naam,
il est plus que temps d'écrire le compilateur Naam vers PIR.
Pour ça, il y a plusieurs solutions.

La première est d'utiliser les outils fournis avec Parrot sous le nom
de PCT: Parrot Compiler Tools. PCT a vraiment l'air très bien et devrait
faire l'affaire pour certains. Malheureusement pour moi, les outils PCT
sont écrits en Perl, langage que je ne connais vraiment pas assez. J'ai
essayé mais y a pas eu moyen. Si vous connaissez bien Perl, je pense que
vous serez très heureux avec les PCT. Sinon, il faut se tourner
vers autre chose.

La seconde solution est plus old-school. On écrit un compilateur en C à l'aide
de Lex et Yacc,
[Flex](http://flex.sourceforge.net/)
et [Bison](http://www.gnu.org/software/bison/), etc. Encore une fois, comme
pour PCT, ce sont de très bons outils. Mais j'ai déjà donné, ils
sont aussi ennuyeux qu'ils sont excellents. Pour mémoire,
j'écris un *toy language* pour le fun.

Ça me laisse une troisième solution: tout écrire *from scratch* en Ruby.
Ça c'est fun.

J'ai une certaine expérience dans le domaine. J'ai écrit des assembleurs,
des compilateurs, des interpréteurs. En C, en python, en Java, en Ruby.
Avec ou sans outils tiers. Certains projets ont aboutis et d'autres ont
échoués mais à chaque fois j'appris quelque chose. Tout ça pour vous dire
que je sais assez bien dans quoi je m'embarque. Naam est, et restera, un
langage très simple. Comme je sais où je vais, écrire un compilateur
Naam vers PIR en Ruby ne sera pas trop difficile.
Je n'écrirais surement pas un code performant. Au contraire, je
m'attacherais uniquement à produire un code facile à lire.
Il nous faudra un analyseur lexical (un *tokenizer* et un *lexer*), un
analyseur syntaxique (pour les fameuses *Syntax Error*). On aura peut-être
besoin de produire un AST (*Abstract Syntax Tree*) mais surement pas dès
le début. On aura aussi intêret à écrire la grammaire du langage. Il y
arrivera un moment où il faudra se pencher sur les messages d'erreurs
du compilateur. Après ça on avisera.

Un compilateur est après tout un programme comme un autre, donc je ne vois
pas de raisons de ne pas l'écrire par améliorations successives. L'objectif
initial sera donc simplement de compiler et faire tourner le programme suivant:

    sign(n)=
    1  if n > 0
    -1 if n < 0
    0  else

    print sign(-123)

La prochaine fois on commence par le commencement en écrivant le
[tokenizer](http://en.wikipedia.org/wiki/Tokenization).

À demain.

{% connexe %}
