---
layout: post
title: "Racket pour les Rubyists 3: Trouver les diviseurs"
date: 2013-11-08 19:17
comments: true
categories: [Racket, Ruby, tutoriel, débutant]
---

{% level 1 %}

Précédemment, on a vu comment produire une
[liste de nombre](http://lkdjiin.github.io/blog/2013/11/06/racket-pour-les-rubyists-2-produire-une-suite-de-nombre/)
avec la fonction `range`. Aujourd'hui on va traduire les tests Ruby suivants
en Racket:

``` ruby
8 % 2 == 0 #=> true
8 % 3 == 0 #=> false
```

<!-- more -->

Reste d'une division
--------------------

Pour calculer le reste d'une division euclidienne, on utilise la fonction
`remainder`. Par exemple:

``` racket
(remainder 8 2) ;=> 0
(remainder 8 3) ;=> 2
```

D'une manière plus générale, `(remainder a b)` calcule le reste de la
division de `a` par `b`. Vous remarquerez encore une fois la notation *prefix*
de Racket.

Au passage, vous notez que le signe pour débuter un commentaire est le
point-virgule (`;`).

Les booléens
------------

En Ruby les deux valeurs booléennes sont **true** et **false**, en Racket
elles sont notées **#t** et **#f**:


Tester l'égalité
----------------
  
Quand Ruby utilise le signe `==`, comme beaucoup d'autres langages, Racket
utilise un seul signe `=`:

``` racket
(= 1 1) ;=> #t
(= 1 2) ;=> #f
```

Attention, `=` ne fonctionne qu'avec les nombres comme vous pouvez le
constater dans la session suivante:

    -> (= "xav" "xav")
    ; =: contract violation
    ;   expected: number?
    ;   given: "xav"
    ;   argument position: 1st

Donc, pour tester si le reste d'une division euclidienne est égal à zéro,
on pourra faire comme ça:

``` racket
(= 0 (remainder 8 2)) ;=> #t
(= 0 (remainder 8 3)) ;=> #f
```

Et d'une manière générale, pour tester si *i* est un diviseur de *n*:

``` racket
(= 0 (remainder n i))
```

La prochaine fois, on verra la fonction Racket `filter`, qui est le
pendant de la méthode `select` de Ruby.

À demain.

{% connexe %}

