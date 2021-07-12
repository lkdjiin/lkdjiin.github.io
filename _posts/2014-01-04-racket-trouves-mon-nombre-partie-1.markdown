---
layout: post
title: "Racket: Trouves mon nombre - partie 1"
date: 2014-01-04 19:12
legacy: true
tags: [racket, jeu]
---



«Devines un nombre entre 1 et 100 !» C'est le jeu que je vous propose
d'écrire en Racket pour apprendre ce langage.
Le code provient du livre [Realm of Racket](http://realmofracket.com/)
et il est livré avec Racket. Vous pourrez le trouver dans le dossier
`collects/realm/chapter2` de votre installation de Racket.

<!-- more -->

Voici le morceau de code qu'on va voir aujourd'hui:

{% highlight racket %}
#lang racket

(define lower 1)
(define upper 100)

(define (guess)
  (quotient (+ lower upper) 2))
{% endhighlight %}

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

{% highlight racket %}
(define lower 1)
(define upper 100)
{% endhighlight %}

Plus tard dans le programme, le contenu de ces variables changera pour
réduire l'étendue.

Maintenant, voyons comment la machine *devine* un nombre:

{% highlight racket %}
(define (guess)
  (quotient (+ lower upper) 2))
{% endhighlight %}

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

{% highlight racket %}
(quotient a b)
{% endhighlight %}

est égal à:

{% highlight racket %}
(truncate (/ a b))
{% endhighlight %}



À demain.




