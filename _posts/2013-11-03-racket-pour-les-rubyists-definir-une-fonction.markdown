---
layout: post
title: "Racket pour les Rubyists: Définir une fonction"
date: 2013-11-03 15:06
legacy: true
tags: [racket, ruby]
---



Racket est un langage dérivé de Scheme que je suis en train d'apprendre.
Je vais m'inspirer de ma série d'articles
[Apprendre Ruby en faisant des maths](http://lkdjiin.github.io/blog/2013/10/21/apprendre-ruby-en-faisant-des-maths/)
pour expliquer les bases de Racket en le comparant à Ruby. Si vous
connaissez un peu Ruby, j'espère que vous n'aurez aucun mal à suivre
ces articles. On commence aujourd'hui avec la définition d'une fonction.

<!-- more -->

J'utiliserais la version 5.3.6 de Racket et la version 2.0 de Ruby.
Au début, on va utiliser le REPL, pour Ruby on a `irb`, pour Racket on
a `racket`.

Définir une fonction
--------------------
Racket a des fonctions et Ruby a des méthodes, mais ça ne fait aucune
différence pour l'instant. Voyons comment définir une fonction `addition`,
qui va calculer et renvoyer la somme de deux arguments, `a` et `b`:

    [~]⇒ racket
    -> (define (addition a b)
         (+ a b))
    -> (addition 12 34)
    46

Comparons immédiatement avec la version Ruby:

    [~]⇒ irb
    >> def addition(a, b)
    >>   a + b
    >> end
    nil
    >> addition 12, 34
    46

Première remarque: avec Racket les parenthèses sont **très importantes**.
On est obligé de les utilisées, et de les utilisées correctement.

Deuxième remarque: Ruby utilise la notation *infix* (`a + b`) alors que
Racket utilise la notation *prefix* (`+ a b`). Étrange au début si vous
n'avez jamais utilisé ce genre de truc, on s'y fait très vite.

Troisième remarque: avec Racket les arguments ne sont pas séparés par des
virgules.

Enfin, Ruby utilise des mots clés (`def` et `end`) pour délimiter un
bloc/ensemble d'instructions alors que Racket utilise simplement les
parenthèses.

**Exercice**: Sur le même modèle que la fonction `addition`, définissez et
utilsez les fonctions `soustraction` et `multiplication`. Voici les solutions:

{% highlight racket %}
(define (soustraction a b)
  (- a b))

(soustraction 17 7)

(define (multiplication a b)
  (* a b))

(multiplication 2 3)
{% endhighlight %}





À demain.



