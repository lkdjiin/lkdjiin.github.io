---
layout: post
title: "Racket: Trouves mon nombre - partie 2"
date: 2014-01-05 20:32
comments: true
categories: [racket, jeu, débutant]
---

{% level 1 %}

Suite de l'article d'hier, aujourd'hui on ajoute la fonction
`smaller` à notre petit jeu textuel.

<!-- more -->

Voici le fichier `guess.rkt` avec la nouvelle fonction:

``` racket guess.rkt
#lang racket

(define lower 1)
(define upper 100)

(define (guess)
  (quotient (+ lower upper) 2))

(define (smaller)
  (set! upper (max lower (sub1 (guess))))
  (guess))
```

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

``` racket
(define (smaller)
  (set! upper (max lower (sub1 (guess))))
  (guess))
```

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

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
