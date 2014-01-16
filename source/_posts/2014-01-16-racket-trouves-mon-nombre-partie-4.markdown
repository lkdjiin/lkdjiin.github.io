---
layout: post
title: "Racket: Trouves mon nombre - partie 4"
date: 2014-01-16 20:47
comments: true
categories: [racket, jeu, débutant]
---

Suite à [l'article précédent](http://lkdjiin.github.io/blog/2014/01/09/trouves-mon-nombre-partie-3/),
on voit aujourd'hui la fonction `start` qui permet de démarrer le jeu avec
n'importe quelle étendue de nombres.

<!-- more -->

Voici tout d'abord le programme complet:

``` racket guess.rkt
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

(define (start n m)
  (set! lower (min n m))
  (set! upper (max n m))
  (guess))
```

On peut maintenant demander à la machine de *deviner* un nombre entre
n et m:

    [~]⇒ racket
    Welcome to Racket v5.3.6.
    -> (enter! "guess.rkt")
    -> (start 1 10)
    5
    -> (bigger)
    8
    -> (smaller)
    6

La fonction `start` utilise des notions déjà vues dans les articles
précédents.

``` racket
(define (start n m)
  (set! lower (min n m))
  (set! upper (max n m))
  (guess))
```

Grâce à `set!`, on redéfini la valeur des variables `lower` et `upper`. Puis
on débute le jeu en lançant `guess`.

La variable `lower` se voit affecter la plus petite des valeurs passées en
arguments, grâce à `min`. Et `upper` se voit affecter la plus grande
grâce à `max`. Du coup, l'ordre des arguments de `start` n'a plus
d'importance:

    -> (start 1000 1)
    500
    -> (start 1 1000)
    500

Voilà qui conclue cette petite introduction au langage Racket.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

