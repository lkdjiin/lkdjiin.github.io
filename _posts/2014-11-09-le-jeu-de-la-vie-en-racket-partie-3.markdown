---
layout: post
title: "Le jeu de la vie en racket - partie 3"
date: 2014-11-09 15:01
legacy: true
tags: [jeu de la vie, racket]
---



C'est la troisième et dernière partie du jeu de la vie en Racket.

{% img /images/screenshot-game-of-life-racket.png %}

<!-- more -->

Trouver le prochain état d'une cellule
--------------------------------------

Vous avez l'habitude maintenant, je commence par un test très simple.

{% highlight racket %}
(check-equal? (next-cell-state '(1 1 1 0 0 0 0 0 0)) 1)
{% endhighlight %}

Et une implémentation minimale.

{% highlight racket %}
#lang racket

...

(define (next-cell-state neighborhood)
  1)

(provide create-generation
         next-cell-state)
{% endhighlight %}

Puis je teste d'autres cas.

{% highlight racket %}
(check-equal? (next-cell-state '(1 1 1 0 0 0 0 0 0)) 1)
(check-equal? (next-cell-state '(1 0 0 1 0 0 1 0 0)) 1)

(check-equal? (next-cell-state '(1 0 0 1 1 0 1 0 0)) 1)
(check-equal? (next-cell-state '(1 0 0 1 0 0 1 0 1)) 0)
{% endhighlight %}

La fonction `for/sum` réduit une liste à la somme de ses éléments.

{% highlight racket %}
(define (next-cell-state neighborhood)
  (define sum (for/sum ([i neighborhood]) i))
  (if (= 3 sum)
    1
    (list-ref neighborhood 4)))
{% endhighlight %}

Je teste les derniers cas.

{% highlight racket %}
(check-equal? (next-cell-state '(1 1 1 0 0 0 0 0 0)) 1)
(check-equal? (next-cell-state '(1 0 0 1 0 0 1 0 0)) 1)

(check-equal? (next-cell-state '(1 0 0 1 1 0 1 0 0)) 1)
(check-equal? (next-cell-state '(1 0 0 1 0 0 1 0 1)) 0)

(check-equal? (next-cell-state '(1 1 1 1 1 1 1 1 1)) 0)
(check-equal? (next-cell-state '(0 0 0 0 0 0 0 0 0)) 0)
{% endhighlight %}

Comme il y a maintenant trois cas, j'utilise `cond` au lieu de `if`.

{% highlight racket %}
(define (next-cell-state neighborhood)
  (define sum (for/sum ([i neighborhood]) i))
  (cond [(= 3 sum) 1]
        [(= 4 sum) (list-ref neighborhood 4)]
        [else 0]))
{% endhighlight %}

On pourrait aussi utiliser `match` plutôt que `cond`:


{% highlight racket %}
(define (next-cell-state neighborhood)
  (match (for/sum ([i neighborhood]) i)
         [3 1]
         [4 (list-ref neighborhood 4)]
         [_ 0]))
{% endhighlight %}

Je n'ai aucune idée de laquelle est la plus performante, même si je peux
imaginer à priori que dans ce cas là c'est `cond`.

test-case
---------

Je pense qu'il est temps de regrouper les tests en `test-case`. Rackunit, le
framework de test de Racket est assez évolutif.

{% highlight racket %}
#lang racket

(require rackunit
         "generation.rkt")

(test-case "create-generation"
  (check-pred list? (create-generation 3 4)
            "It returns a list")

  (check-equal? (length (create-generation 3 4)) 4
              "It builds a list with the right height")

  (check-equal? (length (first (create-generation 3 4))) 3
              "It builds a list with the right width")

  (let ([cell (first (first (create-generation 3 4)))])
  (check-true (or (= cell 0) (= cell 1))
              "It populates generation with 0s or 1s"))

  ((λ ()
   (random-seed 1)
   (check-equal? (create-generation 2 3) '((1 1) (0 1) (1 1))
                 "It populates generation uniformly"))))

(test-case "next-cell-state"
  (check-equal? (next-cell-state '(1 1 1 0 0 0 0 0 0)) 1)
  (check-equal? (next-cell-state '(1 0 0 1 0 0 1 0 0)) 1)

  (check-equal? (next-cell-state '(1 0 0 1 1 0 1 0 0)) 1)
  (check-equal? (next-cell-state '(1 0 0 1 0 0 1 0 1)) 0)

  (check-equal? (next-cell-state '(1 1 1 1 1 1 1 1 1)) 0)
  (check-equal? (next-cell-state '(0 0 0 0 0 0 0 0 0)) 0))
{% endhighlight %}

Extraire un voisinage de cellule
--------------------------------

Comme toujours je commence par un test simple. On peut noter les arguments
nommés de Racket (`#:`). 

{% highlight racket %}
(test-case "extract-neighborhood"
  (let ([game '((1 0 1 0)
                (0 1 0 1)
                (1 0 0 1))])
    (check-equal? (extract-neighborhood game #:x 1 #:y 1) '(1 0 1 0 1 0 1 0 0))))
{% endhighlight %}

Et une implémentation encore plus simple.

{% highlight racket %}
(define (extract-neighborhood generation #:x [x 0] #:y [y 0])
  '(1 0 1 0 1 0 1 0 0))
{% endhighlight %}

La suite est classique, j'ajoute un nouveau test.

{% highlight racket %}
(test-case "extract-neighborhood"
  (let ([game '((1 0 1 0)
                (0 1 0 1)
                (1 0 0 1))])
    (check-equal? (extract-neighborhood game #:x 1 #:y 1) '(1 0 1 0 1 0 1 0 0))
    (check-equal? (extract-neighborhood game #:x 2 #:y 1) '(0 1 0 1 0 1 0 0 1))))
{% endhighlight %}

Je regarde ce test échouer.

    $ racket game-of-life-test.rkt 
    --------------------
    extract-neighborhood
    FAILURE
    actual:     (1 0 1 0 1 0 1 0 0)
    expected:   (0 1 0 1 0 1 0 0 1)

Et j'implémente le minimum de code pour faire passer ce nouveau test.
Je vous épargne ça dans l'article, si vous êtes curieux vous pouvez trouver
[le code sur Github](https://github.com/lkdjiin/game-of-life-racket).

Une nouvelle génération
-----------------------

J'écris un test pour la production d'une nouvelle génération.

{% highlight racket %}
(test-case "next-generation"
  (let ([game '((1 0 1 0)
                (0 1 0 1)
                (1 0 0 1))])

    (check-equal? (next-generation game) '((0 1 1 0) (1 1 0 1) (0 0 1 0)))))
{% endhighlight %}

Et voici le code qui fait passer ce test.

{% highlight racket %}
(define (next-generation current)
  (for/list ([y (length current)])
    (for/list ([x (length (first current))])
      (define neighborhood (extract-neighborhood current #:x x #:y y))
      (next-cell-state neighborhood))))
{% endhighlight %}

On peut maintenant lancer le jeu de la vie.

{% highlight racket %}
#lang racket

(require "generation.rkt"
         "window.rkt")

(define size 100)
(define generation (create-generation size size))
(define canvas (create-window size size generation))

(define (loop n g)
  (send canvas change-generation g)
  (sleep 0.2)
  (when (> n 0)
    (loop (sub1 n) (next-generation g))))

(loop 30 generation)
{% endhighlight %}
Mise à l'échelle
-------------------------------------

Pour rendre les choses un peu plus intéressantes visuellement, on va faire un
zoom x4.

{% highlight racket %}
#lang racket/gui

(define (create-window w h g)
  (define scale 4)

  (define frame (new frame%
                     [label "Game of Life"]
                     [width (* w scale)]
                     [height (* h scale)]))

  (define canvas (new (class canvas%

    ...

         (define/override (on-paint)
           (send dc set-brush (new brush% [color "black"]))
           (send dc draw-rectangle 0 0 (* w scale) (* h scale))
           (send dc set-brush (new brush% [color "white"]))
           (for ([y (length current-generation)])
             (for ([x (length (first current-generation))])
               (when (= 1 (list-ref (list-ref current-generation y) x))
                 (send dc draw-rectangle (* x scale) (* y scale) scale scale))))))))
  ...
{% endhighlight %}

Une surface de jeu sans bordures
--------------------------

Il reste à *retirer* les bordures du jeu. Le processus est exactement le même
que pour les versions [Javascript](http://lkdjiin.github.io/blog/2014/10/25/le-jeu-de-la-vie-en-ruby-opal-partie-1/) et [Ruby](http://lkdjiin.github.io/blog/2014/10/16/le-jeu-de-la-vie-en-javascript-partie-1/) et je n'ai pas envie de
réécrire les mêmes phrases. Au besoin, je vous rappelle que le
[code complet du jeu de la vie en Racket](https://github.com/lkdjiin/game-of-life-racket) se trouve sur Github.





