---
layout: post
title: "Trouves mon nombre - partie 3"
date: 2014-01-09 21:00
legacy: true
tags: [racket, jeu, débutant]
---



Aujourd'hui on regarde la fonction `bigger`, qui est l'inverse de la
fonction `smaller` [vue la dernière fois](http://lkdjiin.github.io/blog/2014/01/05/racket-trouves-mon-nombre-partie-2/).

<!-- more -->

Voici donc notre nouveau fichier `guess.rkt` avec sa nouvelle fonction:

{% highlight racket %}
#lang racket

(define lower 1)
(define upper 100)

(define (guess)
  (quotient (+ lower upper) 2))

(define (smaller)
  (set! upper (max lower (sub1 (guess))))
  (guess))

(define (bigger)
  (set! lower (min upper (add1 (guess))))
  (guess))
{% endhighlight %}

La fonction `bigger` fait exactement l'inverse de `smaller`:

    [~]⇒ racket
    Welcome to Racket v5.3.6.
    -> (enter! "guess.rkt")
    -> (guess)
    50
    -> (bigger)
    75

Et c'est tout ce qu'il nous faut pour que la machine trouve le
nombre que j'ai choisi. Si par exemple je pensais au nombre
77, on continuerait ainsi:

    -> (bigger)
    88
    -> (smaller)
    81
    -> (smaller)
    78
    -> (smaller)
    76
    -> (bigger)
    77

La prochaine fois, on verra comment démarrer le jeu avec n'importe
quelle étendue de nombres.



À demain.


