---
layout: post
title: "Le jeu de la vie en racket - partie 2"
date: 2014-11-08 13:46
comments: true
categories: [jeu de la vie, racket]
---

{% level 2 %}

C'est le moment d'afficher à l'écran notre génération créée au hasard
[la dernière fois](http://lkdjiin.github.io/blog/2014/11/01/le-jeu-de-la-vie-en-racket-partie-1/).
Je rappelle que je n'écris pas de tests pour cette partie.
Pour obtenir un affichage, je me contente de suivre les exemples donnés dans la
documentation
[drawing overview](http://mirror.racket-lang.org/releases/6.1/doc/draw/overview.html)
et [windowing overview](http://mirror.racket-lang.org/releases/6.1/doc/gui/windowing-overview.html).

<!-- more -->

Ce qui donne la première experimentation suivante:

``` racket game-of-life.rkt
#lang racket/gui

...

(define generation (create-generation 100 100))

(define frame (new frame%
  [label "Example"]
  [width 100]
  [height 100]))

(new canvas%
     [parent frame]
     [paint-callback
       (λ (canvas dc)
          (send dc set-brush (new brush% [color "black"]))
          (for ([y (length generation)])
            (for ([x (length (first generation))])
              (when (= 1 (list-ref (list-ref generation y) x))
                (send dc draw-rectangle x y 1 1)))))])

(send frame show #t)
```

Le truc marrant (une façon de voir comme une autre) est que si on
joue les tests, la fenêtre s'affiche. C'est pas très pratique.

Mais avant tout, ce code révèle une erreur précédente:

{% img /images/code-barre-2014-10-11.png %}

On dirait un code barre ! Pas vraiment une distribution uniforme.

Alors le bug est simple à trouver, par contre je vais devoir écrire un ou
plusieurs nouveaux tests et je garde ça pour la fin de l'article.

Ensuite, je voudrais faire une boucle qui affiche une nouvelle génération au
hasard chaque seconde. Je dois avouer que cette histoire de canvas, je la sens
pas trop. Et le code que j'ai pondu s'en ressent. D'abord je mets ce qui a trait
à une génération dans un module à part:

``` racket generation.rkt
#lang racket

(define (create-generation width height)
  (for/list ([i (make-list height 0)])
            (make-list width (random 2))))

(provide create-generation)
```

Puis, tout le bazar de frame et de canvas, aussi dans un module:

``` racket window.rkt
#lang racket/gui

(define (create-window w h g)
  (define frame (new frame%
                     [label "Game of Life"]
                     [width w]
                     [height h]))
  (define canvas (new (class canvas%
         (super-new [parent frame] [style '(no-autoclear)])
         (define current-generation g)
         (define dc (send this get-dc))
         (define/public (change-generation g)
           (set! current-generation g)
           (send this refresh-now))
         (define/override (on-paint)
           (send dc set-brush (new brush% [color "black"]))
           (send dc draw-rectangle 0 0 w h)
           (send dc set-brush (new brush% [color "white"]))
           (for ([y (length current-generation)])
             (for ([x (length (first current-generation))])
               (when (= 1 (list-ref (list-ref current-generation y) x))
                 (send dc draw-rectangle x y 1 1))))))))
  (send frame show #t)
  canvas)

(provide create-window)
```

Moi qui suis habitué à des méthodes de 2 ou 3 lignes, c'est pas vraiment ça.
Et puis j'ai du mal à saisir le modèle objet de Racket.

Enfin le programme principal avec la boucle:

``` racket game-of-life.rkt
#lang racket

(require "generation.rkt"
         "window.rkt")

(define size 100)
(define generation (create-generation size size))
(define canvas (create-window size size generation))

(define (loop n)
  (send canvas change-generation (create-generation size size))
  (sleep 1)
  (when (> n 0)
    (loop (sub1 n))))

(loop 10)
```

Si j'ai le temps, j'essaierais d'utiliser la bibliothèque `2htdp/universe`,
qui me semble bien plus simple.

Maintenant le bug. Le problème est que je crée des lignes complètes de 0 ou de 1
dans la liste qui représente une génération, plutôt que de distribuer
uniformément ces 0 et ces 1. Je vais donc ajouter un test qui initialise le
générateur de nombres aléatoires toujours de la même manière.

``` racket game-of-life-test.rkt
#lang racket

(require rackunit
         "generation.rkt")

...

((λ ()
   (random-seed 1)
   (check-equal? (create-generation 2 3) '((1 1) (0 1) (1 1))
                 "It populates generation uniformly")))
```

Sans surprise, le test échoue.

    $ racket game-of-life-test.rkt
    --------------------
    FAILURE
    actual:     ((1 1) (1 1) (0 0))
    expected:   ((1 0) (1 0) (1 0))
    name:       check-equal?
    location:   (#<path:/home/xavier/code/game-of-life-racket/game-of-life-test.rkt> 21 3 537 112)
    expression: (check-equal? (create-generation 2 3) (quote ((1 0) (1 0) (1 0))))
    message:    "It populates generation uniformly"

Et voici le fix.

``` racket generation.rkt
#lang racket

(define (create-generation width height)
  (define (rnd _)
    (random 2))
  (for/list ([i (make-list height 0)])
            (map rnd (make-list width 0))))

(provide create-generation)
```


<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

{% connexe %}
