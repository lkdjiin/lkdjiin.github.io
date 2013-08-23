---
layout: post
title: "Implémenter un langage sur la machine virtuelle Parrot: partie 1"
date: 2013-08-01 07:59
comments: true
categories: [intermédiaire, parrot, naam]
---
{% level 2 %}

Cela fait quelques années que j'ai envie d'essayer la
[machine virtuelle](https://fr.wikipedia.org/wiki/Machine_virtuelle)
[Parrot](http://www.parrot.org/) et j'ai toujours reporté à plus tard.
Jusqu'à maintenant. Aujourd'hui, je commence à écrire un
[toy language](http://en.wikipedia.org/wiki/Toy_language)
qui tournera sur Parrot.

Pour implémenter un langage sur Parrot, il faut d'abord … un langage.
Simple de préférence, avec peu de fonctionnalités, au moins pour
démarrer.
Je vais en inventer un pour l'occasion, ce qui sera bien plus drôle que
d'utiliser un sous-ensemble d'un langage déjà existant.

<!-- more -->

Le langage naam
---------------
Naam signifie No Assignment, Automatic Memoization.
Je rappelle qu'il s'agit d'un *toy language*, l'objectif étant
d'expérimenter, et non de produire le prochain succès planétaire.
Pour le moment, et peut-être pour toujours, le langage sera limité
à l'utilisation des nombres entiers. Pas de nombres à virgule, pas de
chaînes, pas d'objets… Je viens de passer quelques jours à envisager
une syntaxe. Mais la reflexion n'est pas terminée et elle pourrait
changer d'ici à l'implémentation de naam. Voici des exemples:

    sign(n)=
    1  if n > 0
    -1 if n < 0
    0  else
    
    print sign(3)

Les détails:

    sign(n)=

C'est la définition d'une fonction `sign`.

    1  if n > 0
    -1 if n < 0

Si `n` est positif on renvoie 1. Si `n` est négatif on renvoie -1.

    0  else

Dans les autres cas (il reste le cas du zéro) on renvoie 0. Le mot `else`
marque aussi la fin de la fonction.

Voici maintenant ce que pourrait être la fonction factorielle:

    !(n)=
    1            if 0
    n * .(n - 1) if n > 0
    else

    print !(7)

Et le détail:

    !(n)=

On définit la fonction `!`. Le nom d'une fonction n'a pas à être composé
de lettres. Des signes font aussi bien l'affaire.

    1            if 0

Quand l'argument vaut zéro, on renvoie 1.

    n * .(n - 1) if n > 0

Dans les cas où `n` est positif, on renvoie `n` multiplié 
par la factorielle de `n - 1`.
Le point (`.`) signifie «la fonction elle-même».

    else

Enfin, dans les autres cas (qui ici sont `n` est négatif) on renvoie du
vide, rien, nada. Comme une fonction est dans l'obligation de renvoyer
une valeur, cela provoquera une erreur (ce qui est voulu).

Un dernier exemple pour terminer, la fonction d'Ackermann. Je ne vais pas
la commenter, la seule différence avec ce que j'ai montré avant est
qu'il y a deux arguments :

    ackermann(m, n)=
    n + 1                 if 0, n
    .(m - 1, 1)           if m > 0, 0
    .(m - 1, .(m, n - 1)) else

    print ackermann(2, 3)

On pourrait aussi écrire la même fonction de la manière suivante (je n'ai
pas encore décidé si naam supporterait les deux syntaxes ou non):

    ackermann(0, n)     = n + 1
    ackermann(m > 0, 0) = .(m - 1, 1)
    ackermann(m, n)     = .(m - 1, .(m, n - 1))


Alors, qu'en pensez vous. Est-ce-que ça vous dit de voir naître un
*toy language* au jour le jour ? Que pensez vous de naam ?

La prochaine fois on installe Parrot et on joue un peu avec pour sentir le truc.

À demain.

{% connexe %}
