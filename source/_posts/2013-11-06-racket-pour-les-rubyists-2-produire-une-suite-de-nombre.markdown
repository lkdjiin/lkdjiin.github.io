---
layout: post
title: "Racket pour les rubyists 2: Produire une suite de nombre"
date: 2013-11-06 19:10
comments: true
categories: [Racket, Ruby, tutoriel, débutant]
---

{% level 1 %}

La [dernière fois](http://lkdjiin.github.io/blog/2013/11/03/racket-pour-les-rubyists-definir-une-fonction/)
on a vu comment définir une fonction en Racket. Aujourd'hui on va essayer
de traduire la méthode Ruby suivante:

``` ruby
def divisors(n)
  (1..n).select {|i| n % i == 0}
end
```

<!-- more -->

Tout d'abord, j'ai envie découper cette méthode en trois parties plus petites:

1. `1..n`, pour produire une suite de nombre.
2. `select`, qui est la méthode utilisée pour conserver/supprimer certains
   éléments.
3. `n % i == 0`, qui est un test pour savoir si i est un diviseur de n.

Produire une suite de nombre
----------------------------
On s'intéresse d'abord à la 1ère partie. Racket possède la fonction `range`,
qui produit une liste de nombre. En fournissant un seul argument, n, `range`
produit une liste de 0 à n *non-inclus*:

    -> (range 4)
    '(0 1 2 3)

En fournissant deux arguments, m et n, `range` produit une liste de m à n
*non-inclus*:

    -> (range 1 4)
    '(1 2 3)

Pour être exhaustif, il existe une dernière possibilité, avec 3 arguments
m, n et p, pour produire une liste
de m à n *non-inclus* par pas de p:

    -> (range 10 20 3)
    '(10 13 16 19)

Pour produire une liste de m à n *inclus*, il faut falloir augmenter n de 1:

    -> (define n 4)
    -> (range 1 (+ n 1))
    '(1 2 3 4)

Vous notez au passage la manière de définir une variable, identique à la
définition d'une méthode, ainsi que la façon dont Racket écrit une liste:

- entre parenthèses
- précédée par un apostrophe
- pas de virgule pour séparer les éléments

Le prochain article abordera le test d'égalité en Racket.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}


