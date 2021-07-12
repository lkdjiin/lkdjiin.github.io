---
layout: post
title: "Les sous-ensembles de listes dans R"
date: 2015-04-09 07:47
legacy: true
tags: [R, débutant, sous ensemble, liste]
---



Après avoir parlé des [sous-ensembles de vecteurs](http://lkdjiin.github.io/blog/2015/04/07/les-sous-ensembles-dans-r/) dans le langage R,
c'est maintenant le tour des listes. En R, une liste peut contenir des
types différents, au contraire du vecteur, limité à un seul type.
Prenons par exemple la liste suivante&nbsp;:

{% highlight r %}
> x <- list(1, 2, c("a", "b"))
{% endhighlight %}

À l'affichage, on remarque qu'il s'agit d'une liste grâce aux doubles crochets
(`[[]]`)&nbsp;:

{% highlight r %}
> x
[[1]]
[1] 1

[[2]]
[1] 2

[[3]]
[1] "a" "b"
{% endhighlight %}

<!-- more -->

Les éléments d'une liste peuvent être nommés. Suivant votre langage de
prédilection, vous pouvez penser à une liste R comme à un hash, un dictionnaire,
un tableau associatif, etc&nbsp;:

{% highlight r %}
> x <- list(foo = 1, bar = 2, baz = c("a", "b"))
> x
$foo
[1] 1

$bar
[1] 2

$baz
[1] "a" "b"
{% endhighlight %}

Que se passe-t-il si on utilise la même syntaxe qu'avec un vecteur pour extraire
un élément d'une liste ?

{% highlight r %}
> x[3]
$baz
[1] "a" "b"
{% endhighlight %}

L'idée c'est que l'opérateur `[]` renvoie le même type d'objet que l'objet sur
lequel il est appliqué. Donc utiliser `[]` sur une liste retourne une liste&nbsp;:

{% highlight r %}
> class(x[3])
[1] "list"
{% endhighlight %}

Pour aller chercher un élément, et pas une liste à un seul élément, il faut
utiliser l'opérateur double crochets (`[[]]`)&nbsp;:

{% highlight r %}
> x[[3]]
[1] "a" "b"
{% endhighlight %}

Lorsque les éléments sont nommés, on peut bien sûr utiliser leurs noms comme
clé&nbsp;:

{% highlight r %}
> x$baz
[1] "a" "b"
{% endhighlight %}

Nous pouvons extraire un sous-ensemble d'une liste en passant les indices à
l'opérateur crochet (`[]`)&nbsp;:

{% highlight r %}
> x <- list(1, "2", 3, 4, 5)

> x[c(1, 3, 5)]
[[1]]
[1] 1

[[2]]
[1] 3

[[3]]
[1] 5
{% endhighlight %}

Ou bien en lui donnant un vecteur de booléens&nbsp;:

{% highlight r %}
> x[c(F, T, F, T, F)]
[[1]]
[1] "2"

[[2]]
[1] 4
{% endhighlight %}

En faisant la même chose avec l'opérateur double crochets (`[[]]`) nous pouvons
extraire le nième élément d'un vecteur&nbsp;:

{% highlight r %}
> x <- list(c(1, 2, 3), c("a", "b", "c"))

> x[[c(2, 1)]]
[1] "a"
{% endhighlight %}

Ce qu'on peut décomposer ainsi, d'abord le 2ème élément de la liste&nbsp;:

{% highlight r %}
> x[[2]]
[1] "a" "b" "c"
{% endhighlight %}

Puis le premier élément du vecteur, la syntaxe commence à devenir drôle&nbsp;:

{% highlight r %}
> x[[2]][[1]]
[1] "a"
{% endhighlight %}

Question pour les connaisseurs du langage R : le code précédent me suggère qu'un vecteur
*agit* aussi comme une liste et que l'opérateur double crochet (`[[]]`) n'est pas
limité aux listes. Par exemple&nbsp;:

{% highlight r %}
> y <- c("a", "b", "c")
> y
[1] "a" "b" "c"
> y[[2]]
[1] "b"
> y[2]
[1] "b"
> y[[2]] == y[2]
[1] TRUE
{% endhighlight %}

Est-ce qu'il y a un intérêt à utiliser les double crochets avec des vecteurs ?


