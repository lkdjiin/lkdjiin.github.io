---
layout: post
title: "Racket: Trouves mon nombre - partie 2"
date: 2014-01-05 20:32
legacy: true
tags: [racket, jeu, débutant]
---



Suite de l'article d'hier, aujourd'hui on ajoute la fonction
`smaller` à notre petit jeu textuel.

<!-- more -->

Voici le fichier `guess.rkt` avec la nouvelle fonction:

{% highlight racket %}
#lang racket

(define lower 1)
(define upper 100)

(define (guess)
  (quotient (+ lower upper) 2))

(define (smaller)
  (set! upper (max lower (sub1 (guess))))
  (guess))
{% endhighlight %}

Cette fonction change l'étendue du nombre à trouver, puis fait une nouvelle
proposition:

    [~]⇒ racket
    Welcome to Racket v5.3.6.
    -> (enter! "guess.rkt")
    -> (guess)
    50
    -> (smaller)
    25

Voyons notre nouvelle fonction en détail:

{% highlight racket %}
(define (smaller)
  (set! upper (max lower (sub1 (guess))))
  (guess))
{% endhighlight %}

Si le nombre à trouver est plus petit que 50, il est donc compris entre
1 et 49. Il faut donc changer la limite haute (`upper`) pour refléter
cette nouvelle donne.

Le rôle de `set!` est de redéfinir une variable. Ici, on va changer le
contenu de la variable `upper`.

La fonction `sub1` décremente le nombre passé en argument, donc
`(sub1 (guess))` renvoie 49. Et nous prenons, grâce à `max`, le nombre maximum entre
celui-ci (49) et la valeur de la limite basse, ce qui permet de
s'assurer que la valeur de `upper` ne sera jamais inférieure à
la valeur de `lower`. Ce qu'on peut vérifier en continuant à évaluer
`smaller`:


    -> (smaller)
    25
    -> (smaller)
    12
    -> (smaller)
    6
    -> (smaller)
    3
    -> (smaller)
    1
    -> (smaller)
    1
    -> (smaller)
    1
    ...

La prochaine fois on verra la fonction inverse: `bigger` que vous
pouvez essayer de coder par vous-même en attendant.



À demain.


