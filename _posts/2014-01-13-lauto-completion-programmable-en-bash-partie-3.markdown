---
layout: post
title: "L'auto-complétion programmable en Bash - partie 3"
date: 2014-01-13 20:50
legacy: true
tags: [bash]
---



Cet article est la suite de:
[L'auto complétion programmable en bash: partie 2](http://lkdjiin.github.io/blog/2014/01/11/lauto-completion-en-bash-partie-2/).

Je joue donc quelques minutes avec la commande `compgen`, juste pour voir
de quoi il s'agit. L'option `-W` retient particulièrement mon attention.
On lui passe une liste de mots entre guillemets et ça nous les renvoient:

    [~]⇒ compgen -W "foo bar baz"
    foo
    bar
    baz

<!-- more -->

Ok, on va pas se mentir, vous ne voyez pas tellement l'intérêt, hein ?
Et si on passait un second argument à `compgen`, comme le début d'un
mot:

    [~]⇒ compgen -W "foo bar baz" f
    foo

Ou bien encore:

    [~]⇒ compgen -W "foo bar baz" ba
    bar
    baz

Voilà qui est intéressant. Et si on lui donne un début de mot inexistant:

    [~]⇒ compgen -W "foo bar baz" o
    [~]⇒ 

Les sections **complete** et surtout **programmable completion** de la page
de man sont particulièrement indigestes. Je me doute que je devrais les lire
si je veux aller plus loin, mais ça attendra encore.
Donc je google «bash programmable completion» et je trouve ce qu'il me faut pour
commencer. La suite la prochaine fois.



À demain.




