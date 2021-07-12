---
layout: post
title: "Des benchmarks en général et de Ruby en particulier"
date: 2014-05-08 18:24
legacy: true
tags: [débutant, benchmark, ruby]
---



En ce moment je fais quelques recherches sur la *lenteur* de Ruby.
J'aimerais faire un article sur pourquoi Ruby est lent et pourquoi ça
n'est pas un problême la plupart du temps.

Pendant ces recherches je suis tombé sur cet article:
[Ruby Is Too Slow for Programming Competitions](http://blog.clifreeder.com/blog/2013/04/21/ruby-is-too-slow-for-programming-competitions/).
Dans cet article, l'auteur utilise ce [script](https://gist.github.com/clifff/5401367) de benchmark pour comparer deux manières différentes pour savoir
si un nombre est un [palindrome](http://fr.wikipedia.org/wiki/Nombre_palindrome).
La première manière utilise une méthode mathématique et la seconde manière
transforme le nombre en chaîne de caractères.

<!-- more -->

Alors je n'ai pas regardé le code en détail, j'ai juste voulu faire tourner
le benchmark sur quelques version de Ruby. On commence avec la version
1.9.3:

**ruby MRI 1.9.3**

    Rehearsal -------------------------------------------------------------
    Integer palindrome method  18.800000   0.000000  18.800000 ( 18.814018)
    String palindrome method    9.860000   0.010000   9.870000 (  9.885368)
    --------------------------------------------------- total: 28.670000sec

                                    user     system      total        real
    Integer palindrome method  18.150000   0.000000  18.150000 ( 18.168135)
    String palindrome method    9.830000   0.000000   9.830000 (  9.844366)

On voit que la méthode qui utilise les nombres est deux fois plus lente que
la méthode qui utilise les chaînes de caractères.

Passons à la version 2.0 de Ruby:

**ruby MRI 2.0**

    Rehearsal -------------------------------------------------------------
    Integer palindrome method  19.250000   0.010000  19.260000 ( 19.273625)
    String palindrome method    8.910000   0.000000   8.910000 (  8.922845)
    --------------------------------------------------- total: 28.170000sec

                                    user     system      total        real
    Integer palindrome method  19.560000   0.000000  19.560000 ( 19.555138)
    String palindrome method    8.760000   0.100000   8.860000 (  8.866579)

Je ne m'attendais pas du tout à ça ! La seconde méthode est bien légèrement
plus rapide mais la première méthode est au contraire légèrement plus lente
qu'avec Ruby 1.9.3. Utilisant Ruby au quotidien, j'avais noté une réelle
amélioration de la vitesse lors du passage à 2.0.

Maintenant voyons ce que donne la version 2.1:

**ruby MRI 2.1**

    Rehearsal -------------------------------------------------------------
    Integer palindrome method  13.930000   0.010000  13.940000 ( 13.938652)
    String palindrome method    8.160000   0.000000   8.160000 (  8.165836)
    --------------------------------------------------- total: 22.100000sec

                                    user     system      total        real
    Integer palindrome method  14.000000   0.000000  14.000000 ( 13.992662)
    String palindrome method    8.320000   0.000000   8.320000 (  8.323284)

C'est plus conforme à mes attentes, on voit une nette amélioration avec la
première méthode.

Comme j'ai un rubinius sous la main et que j'ai déjà pu constater que cette
implémentation de Ruby pouvait être rapide, j'essaye:

**rubinius 2.0**

    Rehearsal -------------------------------------------------------------
    Integer palindrome method   3.768236   0.000000   3.768236 (  3.781376)
    String palindrome method   10.240640   0.044002  10.284642 ( 10.293314)
    --------------------------------------------------- total: 14.052878sec

                                    user     system      total        real
    Integer palindrome method   2.140134   0.000000   2.140134 (  2.141363)
    String palindrome method    8.472530   0.048003   8.520533 (  8.533402)

Waow ! Si la seconde méthode (avec les chaînes de caractères) est
sensiblement équivalente à Ruby 2.1, la première méthode (avec les
nombres) est pratiquement **7 fois plus rapide**.

De là à dire que les benchmarks ne servent à rien, il n'y a qu'un pas que
je ne veux pas franchir. Je veux seulement dire qu'il faut faire très
attention avec les benchmarks et ne pas tirer de conclusions hatives.
L'auteur de ce benchmark concluait à tort que la seconde méthode est plus
rapide que la première. Alors que c'est plus une question de contexte,
d'algorithme utilisé, d'implémentation du langage, et peut-être encore
d'autres choses qui m'échappent.

La seule conclusion que je peux tirer de ça est: d'une manière générale,
pensez à tester votre application avec Rubinius, vous pourriez être
agréablement surpris ;)



À demain.



