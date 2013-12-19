---
layout: post
title: "Racket pour les Rubyists 8: Tests unitaires simples"
date: 2013-11-17 19:04
comments: true
categories: [racket, ruby, tutoriel, débutant, test unitaire]
---

{% level 1 %}

Maintenant que l'on sait [écrire un module pour Racket](http://lkdjiin.github.io/blog/2013/11/15/racket-pour-les-rubyists-7-module-basique/), on va pouvoir
faire des tests unitaires simples avec RackUnit, le framework de test
fournit avec le langage Racket.

<!-- more -->

Notre module
------------
On va tout d'abord mettre notre fonction `divisors` dans le fichier
`number.rkt`:

``` racket
#lang racket

(define (divisors n)
  ; Is i a divisor of n?
  (define (divisor? i)
    (= 0 (remainder n i)))
  (filter divisor? (range 1 (+ n 1))))

(provide divisors)
```

Puis on s'assure que tout fonctionne bien en appelant la fonction `divisors`
depuis une session racket:

    [~]⇒ racket
    Welcome to Racket v5.3.6.
    -> (require "number.rkt")
    -> (divisors 17)
    '(1 17)
    -> (exit)

Le framework RackUnit
---------------------
Tout comme Ruby est fournit avec test/unit, Racket est livré avec RackUnit.
C'est un framework de tests unitaires relativement simple, surtout dans son
*utilisation basique* comme on va le voir ici.

Comme notre fichier à tester se nomme `number.rkt`, nous allons nommer le
fichier comportant les tests `number-test.rkt` et le placer dans le même
dossier:

``` racket
#lang racket

(require rackunit
         "number.rkt")
```

On requiert la bibliothèque `rackunit` ainsi que le fichier à tester. *On verra
dans un autre article pourquoi `rackunit` n'est pas placé entre guillemets.*
Maintenant on peut effectuer un test avec la fonction:

    (check-equal? A B)

qui s'assure que l'expression A est égale à l'expression B. Par exemple:

``` racket
#lang racket

(require rackunit
         "number.rkt")

(check-equal? (divisors 8) '(1 2 4 8))
```

Et on lance les tests comme ceci:

    [~]⇒ racket number-test.rkt
    [~]⇒ 

Quand tout les tests passent, RackUnit est silencieux.
Si on modifie notre fonction `divisors` ainsi:

    (filter divisor? (range 2 (+ n 1))))

On peut voir le genre de sortie produit par RackUnit sur un test qui
échoue:

    [~]⇒ racket number-test.rkt
    --------------------
    FAILURE
    actual:     (2 4 8)
    expected:   (1 2 4 8)
    name:       check-equal?
    location:   (#<path:/number-test.rkt> 7 0 92 38)
    expression: (check-equal? (divisors 8) (quote (1 2 4 8)))

    Check failure
    --------------------

Comparaison avec Ruby et unit/test
----------------------------------

Voici un test similaire pour Ruby, écrit avec le framework test/unit:

``` ruby
require_relative "number"
require "test/unit"

class TestNumber < Test::Unit::TestCase
  def test_divisors
    assert_equal [1, 2, 4, 8], Number.divisors(8)
  end
end
```

Ruby est loin d'être un langage verbeux et pourtant on peut voir qu'ici il
faut écrire une classe et utiliser l'héritage rien que pour un simple petit
test de rien du tout. Alors je ne dis pas que les *test cases* sont
inutiles (et Racket permet aussi d'organiser les tests de plusieurs
manières différentes), seulement dans le cas d'un programme aussi simple
que le notre je trouve la façon de faire de Racket plus *naturelle*.

La prochaine fois on passera au refactoring de notre méthode `divisors`.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

