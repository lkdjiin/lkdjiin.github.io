---
layout: post
title: "Les algorithmes génétiques démystifiés 23"
date: 2013-09-26 18:19
comments: true
categories: [problème des 8 dames, algorithme génétique, ruby, intermédiaire]
---

{% level 2 %}

Pour évaluer une solution potentielle dans le problème des 8 dames, on va
devoir calculer le nombre de paires de dames qui sont en conflit (en prise,
pour les joueurs d'échecs).

<!-- more -->

Dans [l'article précédent](http://lkdjiin.github.io/blog/2013/09/25/les-algorithmes-genetiques-demystifies-22/)
on a mis en place la classe `Evaluator`, mais il manquait une partie
déterminante: le calcul du nombre de conflits. Le voici:

``` ruby
  def conflicts(individual)
    board = individual.chromosome
    score = 0
    @board_size.times do |row1|
      gene1 = board[row1]
      (row1+1...@board_size).each do |row2|
        gene2 = board[row2]
        score += 1 if gene1 == gene2
        score += 1 if row2 - row1 == (gene1 - gene2).abs
      end
    end
    score
  end
```

Je ne suis pas très satisfait de cette méthode, elle est assez imposante
(trop longue) et difficile à lire (pas claire). Néanmoins elle fait son
travail et c'est ce qui compte pour l'instant. Je ferais peut-être du
refactoring plus tard (ou bien c'est un lecteur charitable qui va nous
le faire ?). Une explication s'impose:

``` ruby
    @board_size.times do |row1|
      gene1 = board[row1]
```

On a une première itération sur chaque rangées. Dans chaque boucle, la variable
`gene1` reçoit la position de la dame de cette rangée, c'est à dire
le numéro de la colonne (base 0). On va ensuite
comparer cette dame avec les dames des rangées suivantes:

``` ruby
      (row1+1...@board_size).each do |row2|
        gene2 = board[row2]
```

Dans cette seconde itération, `gene2` reçoit successivement les positions
de chaque dames restantes. On peut maintenant regarder si deux dames sont
dans la même colonne:

``` ruby
        score += 1 if gene1 == gene2
```

Ça se passe de commentaire… Pour savoir si deux dames sont sur une
même diagonale, c'est un peu plus tordu:

``` ruby
        score += 1 if row2 - row1 == (gene1 - gene2).abs
```

Je vois un peu ça comme un problème de géométrie. Si deux dames ont le
même écart en nombre de colonnes et en nombre de rangées, c'est qu'elles
partagent la même diagonale.

Cet article n'était pas vraiment orienté algorithme génétique mais je pense
qu'il était pourtant nécessaire. Si on a pas une bonne fonction d'évaluation,
un algorithme génétique n'est d'aucune aide. C'est pour ça que la première
chose que je fais quand j'aborde un nouveau problème c'est de réfléchir au
combo évaluation/chromosome jusqu'à en avoir une vision claire.

À demain.

{% connexe %}

