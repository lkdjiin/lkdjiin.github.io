---
layout: post
title: "Les algorithmes génétiques démystifiés 2"
date: 2013-08-29 09:29
comments: true
categories: [algorithme génétique, ruby, intermédiaire]
---

{% level 2 %}

Dans cette seconde partie, on commence à coder…

J'ai choisi un problème simple: trouver une expression qui vaut 987 en
mélangeant les chiffres de 0 à 9 et les symboles +, -, / et %, respectivement
pour addition, soustraction, division entière et reste de la division.
L'expression comportera 12 caractères/symboles maximum. Par exemple:

* "987"
* "900+87"
* "2000/2-13"

sont différentes solutions possibles au problème posé.

<!-- more -->

Je n'utilise pas la multiplication pour éviter d'avoir des nombres trop
grands (`**` est l'opérateur de puissance en Ruby, comme dans certains
autres langages).

La première chose à faire est de définir comment on va coder les gènes.
Traditionnellement, ils sont représentés sous la forme d'une chaîne de bits.
Comme on a 14 symboles (10 chiffres et 4 opérateurs mathématiques) à
coder, 4 bits sont suffisants. Les 2 derniers encodages sont des gènes qui
ne font rien:

    0000 0
    0001 1
    0010 2
    0011 3
    0100 4
    0101 5
    0110 6
    0111 7
    1000 8
    1001 9
    1010 +
    1011 -
    1100 /
    1101 %
    1110 ne rien faire
    1111 ne rien faire

L'expression recherchée devant faire au maximum 12 caractères de long, nos
chromosomes mesureront 48 bits (12 caractères multiplié par 4 bits).

Le problème est posé,
c'est parti pour le code. Il est en Ruby mais je vais faire en sorte
qu'il soit compréhensible par tous et facilement transposable dans
votre langage de prédilection.

On doit pouvoir créer un chromosome au hasard:

``` ruby
def make_chromosome
  value = ""
  48.times { value += rand(0..1).to_s }
  [nil, value]
end
```

Cette fonction renvoie une liste avec `nil`, qui sera plus tard utilisé
pour mémoriser l'évaluation du chromosome (son score) et une chaîne de
48 caractères au hasard parmi "1" et "0".

On peut maintenant fabriquer une population complète:

``` ruby
def make_population
  population = []
  100.times { population << make_chromosome }
  population
end
```

La fonction `make_population` renvoie une liste de 100 chromosomes.

On peut voir ce que ça donne avec `make_population.each {|x| puts x.inspect}`:

    [nil, "110111010010111000000001011001111000100010101111"]
    [nil, "101100010001001000011000111011000001100010000000"]
    ...
    [nil, "111110110011110111111110110000010100100100000100"]
    [nil, "000010101001000010011001101010101110011100010010"]

Maintenant qu'on a créé une population de 100 solutions potentielles, il
faut pouvoir évaluer chaque solution. Pour cela, il faut d'abord être en
mesure de séparer une suite de 48 bits (le chromosome) en 12 parties de
4 bits (les gènes):

``` ruby
def chromosome_to_gene(chromosome)
  chromosome.last.scan /.{4}/
end
```

La fonction `chromosome_to_gene` prend en entrée un chromosome (créé avec
`make_chromosome`) et renvoie une liste des 12 gènes qui le compose.

Pour décrypter l'expression composée par les 12 gènes, il faut tout
d'abord décrypter un seul gène:

``` ruby
def gene_to_operand(gene)
  case gene
  when "0000" then 0
  when "0001" then 1
  when "0010" then 2
  when "0011" then 3
  when "0100" then 4
  when "0101" then 5
  when "0110" then 6
  when "0111" then 7
  when "1000" then 8
  when "1001" then 9
  when "1010" then "+"
  when "1011" then "-"
  when "1100" then "/"
  when "1101" then "%"
  end
end
```

On peut maintenant decrypter la formule complète (l'expression):

``` ruby
def genes_to_formula(genes)
  formula = []
  genes.each {|gene| formula << gene_to_operand(gene) }
  formula.join
end
```

`genes_to_formula` prend en entrée la liste des 12 gènes d'un chromosome
et renvoie l'expression sous la forme d'une chaîne de caractères.

L'évaluation proprement dite se passe ainsi:

``` ruby
def evaluation(genes)
  formula = genes_to_formula(genes)
  begin
    result = (@search_value - eval(formula)).abs
  rescue Exception
    result = 999_999_999_999
  end
  result = 999_999_999_999 unless result.is_a?(Integer)
  result
end
```

Cette fonction mérite quelques d'explications. L'expression (`formula`)
est évaluée avec `eval`. En ruby, `eval` evalue une chaîne de caractères
comme si c'était du code source (comme en Javascript, etc).
On ôte ce résultat de `@search_value`, qui
contient le nombre qu'on cherche (notre problème) et on garde la valeur
absolue. Ainsi zéro signifie une solution et plus on s'éloigne de zéro,
plus on est loin d'une solution. On pourra donc facilement classer nos
individus. Si `eval` provoque une exception (à cause d'une formule/expression
incompréhensible), on place une grande valeur
comme résultat puisqu'on est très loin de la solution. On peut voir
le nombre 999.999.999.999 comme étant l'infini. Enfin je regarde si
le résultat de `eval` est bien un nombre et dans le cas contraire, je
change le résultat pour refleter ce souci. Qu'est ce que ça peut être
d'autre qu'un nombre ? En ruby, une chaîne placée entre `/` est une
expression régulière. Voilà pour aujourd'hui.

À demain.

{% connexe %}

