---
layout: post
title: "Le jeu de la vie en racket - partie 1"
date: 2014-11-01 12:22
comments: true
categories: [jeu de la vie, racket]
---

{% level 2 %}

Le troisième volet de cette série [le jeu de la vie en 7 langages](http://lkdjiin.github.io/blog/2014/10/08/le-jeu-de-la-vie-dans-sept-langages-differents/)
sera consacré à [Racket](http://racket-lang.org/), un dialecte de Lisp.
Télécharger le ici: http://download.racket-lang.org/
et installez avec `bash ./nom-du-fichier.sh`

<!-- more -->

On commence par un *smoke test* pour être sûr que Racket est bien installé et
accessible. Dans un fichier `game-of-life-test.rkt`, chargez le framework de
test et le futur fichier d'implémentation.

``` racket game-of-life-test.rkt
#lang racket

(require rackunit
         "game-of-life.rkt")
```

Puis executez le :

    $ racket game-of-life-test.rkt
    game-of-life-test.rkt:4:9: cannot open module file

Cool, Racket est là et nous dit qu'il ne peut pas ouvrir le fichier
`game-of-life.rkt`. Créons le :

    touch game-of-life.rkt

``` racket game-of-life.rkt
#lang racket
```

Premier test maintenant, la fonction `create-generation` doit renvoyer une
liste.

``` racket game-of-life-test.rkt
#lang racket

(require rackunit
         "game-of-life.rkt")

(check-pred list? (create-generation 3 4))
```

    $ racket game-of-life-test.rkt 
    game-of-life-test.rkt:6:19: create-generation: unbound identifier in module

Ok, on renvoie donc une liste vide `'()`. Notez aussi `provide`, qui permet de
définir en quelque sorte les fonctions publiques du fichier.

``` racket game-of-life.rkt
#lang racket

(define (create-generation width height)
  '())

(provide create-generation)
```

`rackunit`, le framework de test *shippé* avec Racket peut aussi documenter
les tests:

``` racket game-of-life-test.rkt
(check-equal? (length (create-generation 3 4)) 4
              "It builds a list with the right height")
```

On crée une liste de la bonne taille, et comme on se fiche pour l'instant de ce
qu'elle contient, on peut l'initialiser avec des zéros.

``` racket game-of-life.rkt
(define (create-generation width height)
  (make-list height 0))
```

Chaque élément de la liste doit aussi être une liste (la dimension `x`).

``` racket game-of-life-test.rkt
(check-equal? (length (first (create-generation 3 4))) 3
              "It builds a list with the right width")
```

    $ racket game-of-life-test.rkt 
    length: contract violation
      expected: list?
      given: 0

J'utilise `for/list` pour construire cette fameuse liste à deux dimensions. Les
différentes variantes de `for` me semble très utilisées en Racket.

``` racket game-of-life.rkt
(define (create-generation width height)
  (for/list ([i (make-list height 0)])
            (make-list width 0)))
```

Finalement, je veux que ma liste contiennent des `0` (cellule morte) et des
`1` (cellule vivante).

``` racket game-of-life-test.rkt
(let ([cell (first (first (create-generation 3 4)))])
  (check-true (or (= cell 0) (= cell 1))
              "It populates generation with 0s or 1s"))
```

``` racket game-of-life.rkt
(define (create-generation width height)
  (for/list ([i (make-list height 0)])
            (make-list width (random 2))))
```

Ce dernier bout de code contient un bug qui n'est pas attrapé par les
tests (vous l'avez vu ?). Je *fixerais* ça dans le prochain article.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

{% connexe %}
