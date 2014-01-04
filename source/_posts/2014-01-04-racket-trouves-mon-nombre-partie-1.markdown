---
layout: post
title: "Racket: Trouves mon nombre - partie 1"
date: 2014-01-04 19:12
comments: true
categories: [racket, jeu, débutant]
---

{% level 1 %}

«Devines un nombre entre 1 et 100 !» C'est le jeu que je vous propose
d'écrire en Racket pour apprendre ce langage.
Le code provient du livre [Realm of Racket](http://realmofracket.com/)
et il est livré avec Racket. Vous pourrez le trouver dans le dossier
`collects/realm/chapter2` de votre installation de Racket.

<!-- more -->

Voici le morceau de code qu'on va voir aujourd'hui:

``` racket guess.rkt
#lang racket

(define lower 1)
(define upper 100)

(define (guess)
  (quotient (+ lower upper) 2))
```

Enregistrez le dans un fichier `guess.rkt`. Pour le charger, lancez `racket`
et tapez `(enter! "guess.rkt")`:

    [~]⇒ racket
    Welcome to Racket v5.3.6.
    -> (enter! "guess.rkt")

Si vous demandez l'évaluation de la fonction `guess`, vous obtiendrez 50:

    -> (guess)
    50

Voici quelques explications. On a tout d'abord défini deux variables,
`lower` et `upper`, qui sont les limites basses et hautes de l'étendue
sur laquelle la machine va *deviner* un nombre:

``` racket
(define lower 1)
(define upper 100)
```

Plus tard dans le programme, le contenu de ces variables changera pour
réduire l'étendue.

Maintenant, voyons comment la machine *devine* un nombre:

``` racket
(define (guess)
  (quotient (+ lower upper) 2))
```

Tout simplement en donnant le nombre qui se trouve au milieu des limites
basses et hautes. Pour trouver ce nombre, on divise par 2 la somme de la limite
basse et de la limite haute. On doit ici utiliser `quotient` pour faire
la division, et non pas `/`. En effet:

    -> (/ 101 2)
    101/2

En Racket, les nombres restent *exacts* tant qu'ils le peuvent. Comme nous
voulons un nombre entier, il faut le tronquer:

    -> (truncate 101/2)
    50

Voilà ce à quoi sert `quotient`. Autrement dit:

``` racket
(quotient a b)
```

est égal à:

``` racket
(truncate (/ a b))
```

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}


