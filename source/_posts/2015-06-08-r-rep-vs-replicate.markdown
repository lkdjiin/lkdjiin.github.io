---
layout: post
title: "R : rep vs replicate"
date: 2015-06-08 15:45
comments: true
categories: [R, débutant, hasard, data science]
---

{% level 1 %}

Nouveau venu en R, je découvre régulièrement des nouvelles fonctions qui me
simplifient la vie. Comme par exemple la fonction `replicate` dont je vais
parler aujourd'hui.

Partons de l'hypothèse que je veuille générer plusieurs nombres aléatoires de
1 à 10. Pour ceci je dispose de la fonction `random` suivante, qui produit
justement un nombre aléatoire entre 1 et 10 :

<!-- more -->

``` r
random <- function() {
  sample(1:10, size=1)
}

random()
[1] 5

random()
[1] 1
```

Comment faire pour obtenir *n* nombres aléatoires en utilisant cette fonction ?
Mettons quatre nombres. Si je me sers de `rep`, je vais avoir quelques
surprises :

``` r
rep(random(), 4)
[1] 8 8 8 8

rep(random(), 4)
[1] 2 2 2 2
```

En effet, l'appel à `random()` est fait avant la répétition, j'obtiens donc
quatre fois la même valeur.

Pour résoudre ce problème, je peux utiliser la fonction `replicate` :

``` r
replicate(4, random())
[1]  3  6 10  3
```

Ça fonctionne car cette fois `random()` est appelé pour chacune des
répétitions.

Pour la petite histoire, `replicate` est un cas spécial de la fonction plus
générale `sapply` :

``` r
sapply(1:4, function(x) random())
[1] 10  4  2  1
```

Dans ce cas d'utilisation précis `replicate` est plus confortable à utiliser,
puisque cette méthode évite de générer un vecteur inutile (`1:4`) et de passer par une fonction anonyme qui n'utilise pas son argument.

{% connexe %}
