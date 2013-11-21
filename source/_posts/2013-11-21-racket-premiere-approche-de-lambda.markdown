---
layout: post
title: "Racket: première approche de lambda"
date: 2013-11-21 19:53
comments: true
categories: [racket, tutoriel, débutant, lambda]
---

{% level 1 %}

Dans un [article précédent](http://lkdjiin.github.io/blog/2013/11/11/racket-pour-les-rubyists-6-une-premiere-fonction/), j'ai écrit une fonction Racket pour calculer
les diviseurs d'un nombre n:

``` racket
#lang racket

(define (divisors n)
  ; Is i a divisor of n?
  (define (divisor? i)
    (= 0 (remainder n i)))
  (filter divisor? (range 1 (+ n 1))))

(provide divisors)
```

Puis on a vu comment [faire des tests unitaires](http://lkdjiin.github.io/blog/2013/11/17/racket-pour-les-rubyists-8-tests-unitaires-simples/).
Il est temps maintenant de faire un peu de refactoring.

<!-- more -->

Tout d'abord, le plus simple, on va extraire une fonction qui calcule
un *range* de 1 à n inclus:

``` racket number.rkt
#lang racket

; divisors : integer -> list of integers
; Get divisors of a number n.
(define (divisors n)
  ; Is i a divisor of n?
  (define (divisor? i)
    (= 0 (remainder n i)))
  (filter divisor? (range-inclusive n)))

; range-inclusive : integer -> list of integers
; Build a list from 1 to n inclusive.
(define (range-inclusive n)
  (range 1 (+ n 1)))

(provide divisors)
```

Vous noterez au passage que j'ai commencé à documenter mes fonctions en
spécifiant les types de données en entrée et en sortie. Vous remarquez aussi
que `range-inclusive` ne fait pas partie de l'API du module:
`(provide divisors)`.

Maintenant il nous faut extraire la fonction qui regarde si un nombre *i* est
un diviseur de *n*:

``` racket
; divisor-of? : integer integer -> boolean
; Tells if i is a divisor of n.
(define (divisor-of? n i)
  (= 0 (remainder n i)))
```

Le nom de la fonction a changé au passage pour `divisor-of?`. Mais surtout
nous avons du inclure *n* dans les arguments de la fonction.

On doit maintenant *insérer* cette fonction dans le code de la fonction
principale `divisors`. Voici une première tentative un peu naive:

``` racket
; Attention, ce code ne fonctionne pas.
(define (divisors n)
  (filter (divisor-of? n i) (range-inclusive n)))
```

Évidemment ça ne marche pas, puisque Racket ne connait pas *i*, mais
ça nous donne une orientation. Pour que Racket sache ce que nous voulons
placer dans *i*, à savoir l'élément en cours de traitement par la fonction
`filter`, on va passer par une fonction anonyme:

``` racket
(define (divisors n)
  (filter (lambda (i) (divisor-of? n i)) (range-inclusive n)))
```

Une fonction anonyme (lambda) prend un argument (ou plusieurs) et une
expression. À chaque itération, `filter` passe un élément tiré de
`(range-inclusive n)` à la fonction anonyme `(lambda (i) (divisors-of? n i))`.

Voilà donc notre module, après refactoring:

``` racket number.rkt
#lang racket

; divisors : integer -> list of integers
; Get divisors of a number n.
(define (divisors n)
  (filter (lambda (i) (divisor-of? n i)) (range-inclusive n)))

; divisor-of? : integer integer -> boolean
; Tells if i is a divisor of n.
(define (divisor-of? n i)
  (= 0 (remainder n i)))

; range-inclusive : integer -> list of integers
; Build a list from 1 to n inclusive.
(define (range-inclusive n)
  (range 1 (+ n 1)))

(provide divisors)
```

On aurait aussi pu écrire ce qui suit, à la place des trois fonctions ci-dessus:

``` racket
; divisors : integer -> list of integers
; Get divisors of a number n.
(define (divisors n)
  (filter (lambda (i) (= 0 (remainder n i))) (range 1 (+ n 1))))
```

Ça fait bien sûr beaucoup moins de code… Peut-être est-ce parceque je ne suis
pas encore habitué à Racket, mais je trouve aussi cela bien moins lisible.
Si on doit réutiliser les fonctions `divisor-of?` et `range-inclusive`, il
n'y a pas de question à se poser. Sinon…? Si vous connaissez bien
Racket/Scheme/Lisp laissez donc un commentaire pour me dire quelle version
est la plus idiomatique de ce type de langages.

À demain.

{% connexe %}

