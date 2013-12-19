---
layout: post
title: "Les algorithmes génétiques démystifiés 3"
date: 2013-08-30 09:52
comments: true
categories: [algorithme génétique, ruby, intermédiaire]
---

{% level 2 %}

On termine ce qu'on a commencé
[hier](http://lkdjiin.github.io/blog/2013/08/29/les-algorithmes-genetiques-demystifies-2/),
à savoir l'évaluation de la population et on s'occupe aussi
de la sélection, en vue de la reproduction.

<!-- more -->

Il est temps de noter la population entière:

``` ruby
def score_population
  @population = @population.map do |individual|
    genes = chromosome_to_gene(individual)
    individual[0] = evaluation(genes)
    individual
  end
end
```

La fonction `score_population` itère sur chaque individu,
calcule son score et modifie
l'individu pour qu'il reflète ce score. On peut voir ce que donne
notre code jusqu'ici en ajoutant ces quelques lignes:

``` ruby
@search_value = 987
@population = make_population
score_population
@population = @population.sort
@population.each {|individual| puts individual.inspect}
```

Si vous ne connaissez pas trop Ruby, sachez que `sort` va trier
la population sur le premier élément de chaque individu, soit son score.
Et voici un résultat possible:

    [4, "001100111010111110010010100011111010111100110000"]
    [198, "101000011111001000010011110100101010011110001000"]
    [331, "011011101110010101101101011100000110001110000100"]
    [524, "111011100101011010100010011010101110001110000001"]
    [666, "001100101110000111011000100001010101011000000001"]
    [735, "101000101111100001001110101101100010101000110000"]
    [895, "100111110011101101000110110000110101110100101111"]
    [932, "001100010100000111000101011111011000010111110100"]
    ...
    [999999999999, "111100001100101011100000001011111110101110001100"]
    [999999999999, "111100101001110111110101101101101101000111101010"]

Vous pouvez vous amuser à décrypter quelques chromosomes à la main si
ça vous amuse (ou bien si vous êtes sceptique).

On en a maintenant fini avec l'évaluation. Il faut savoir que cette partie est
toujours spécifique à un problème donné. C'est à dire que pour chaque
problème il faut trouver:

* comment représenter/crypter un gène, un chromosome
* comment les décrypter
* comment évaluer une solution
* comment classer la population

La sélection
-------------
Maintenant on peut passer à l'étape de selection. Ça va être très rapide.
Je vais m'inspirer de la selection artificielle, et non pas naturelle:

``` ruby
def selection
  @selected = @population[0...50].shuffle
end
```

Simple, non ? Je conserve les 50 premiers individus. Au passage, `shuffle` sert
à mélanger au hasard. Demain, nous ferons se reproduire ces 50 solutions qui
sont les meilleures de leur génération.

**Attention :** si ce type de sélection a le mérite
d'être simple, il n'en est pas moins radical. C'est de l'élitisme, voir
limite de l'eugénisme
(heureusement ce n'est que de l'informatique). Il y a un tas
d'autres façons d'opérer une sélection, et j'en parlerais sûrement plus en
détails plus tard. D'ici là, cette méthode élitiste devrait convenir assez
bien pour notre petit problème (il est possible qu'elle nous cause
quelques soucis quand même… suspens…).

Un mot sur le code
------------------
J'utilise Ruby pour présenter les algorithmes génétiques car je trouve que
c'est un langage assez facile à comprendre même pour ceux qui ne le
maitrise pas. J'utilise aussi un style volontairement très simple et
procédural pour que chacun puisse l'adapter le plus facilement possible
à son propre paradigme/langage. Si vous voulez voir ce que donne le code
de l'article d'hier d'une manière orienté objet,
[@Sam](https://twitter.com/PagedeGeek)
(de [Page de Geek](http://www.pagedegeek.com/))
a eu la gentillesse de s'y coller et a pondu
[ce code](https://gist.github.com/PagedeGeek/6378269)
très bien écrit.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

