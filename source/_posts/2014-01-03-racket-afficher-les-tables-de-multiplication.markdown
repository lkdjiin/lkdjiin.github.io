---
layout: post
title: "Racket: Afficher les tables de multiplication"
date: 2014-01-03 17:41
comments: true
categories: [racket, débutant]
---

{% level 1 %}

Aujourd'hui un programme vraiment très simple pour débuter en Racket:
comment afficher les tables de multiplication de 1 à 12.
Attention: vrais débutants uniquement !

<!-- more -->

On commence par une fonction qui affiche une ligne d'une table de
multiplication:

``` racket
(define (display-table-line rank n)
  (printf "~a x ~a = ~a\n" rank n (* rank n)))
```

Cette fonction se nomme `display-table-line` et prends deux
paramètres: `rank` et `n`. `n` est le numéro de la table (table des 1,
table des 2, table des 3, etc).
`printf` permet d'afficher une ligne de texte formaté, chaque occurence
de `~a` sera remplacée, dans l'ordre, par les arguments qui suivent.

Voici maintenant la fonction `display-table`, qui va afficher une table entière:

``` racket
(define (display-table n)
  (for ([rank (in-range 1 11)])
       (display-table-line rank n)))
```

Cette fonction affiche la table des `n`. Tout se passe dans une boucle `for`.
La fonction `(in-range x y)` retourne un range de x inclus, à y non-inclus.

Et enfin, voici la boucle principale qui provoque l'affichage des tables de
1 à 12:

``` racket
(for ([num (in-range 1 13)])
     (printf "Table des ~a\n\n" num)
     (display-table num)
     (newline))
```

On peut paraphraser le code ainsi: pour chaque table de 1 à 12, écrire un
entête, afficher la table, puis passer une ligne.

Voici donc, pour finir, le code complet:

``` racket
#lang racket

(define (display-table-line rank n)
  (printf "~a x ~a = ~a\n" rank n (* rank n)))

(define (display-table n)
  (for ([rank (in-range 1 11)])
       (display-table-line rank n)))

(for ([num (in-range 1 13)])
     (printf "Table des ~a\n\n" num)
     (display-table num)
     (newline))
```

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
