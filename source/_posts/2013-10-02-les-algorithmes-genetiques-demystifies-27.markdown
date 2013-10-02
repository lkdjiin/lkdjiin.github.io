---
layout: post
title: "Les algorithmes génétiques démystifiés 27"
date: 2013-10-02 12:06
comments: true
categories: [problème des 8 dames, extremum local, algorithme génétique, ruby, intermédiaire]
---

{% level 2 %}

Maintenant qu'on a vu ce qu'était *en théorie* un extremum local, on
regarde *en pratique* comment il se manifeste dans les algorithmes
génétiques.

<!-- more -->

Comment un extremum local se manifeste dans les algorithmes génétiques ?
------------------------------------------------------------------------

On va reprendre le [dernier code](http://lkdjiin.github.io/blog/2013/09/27/les-algorithmes-genetiques-demystifies-24/)
sur le problème des 8 dames et modifier deux ou trois petites choses.
D'abord on s'assure d'avoir des soucis en passant la taille de l'échiquier
à 16, et on réduit le nombre de générations pour ne pas avoir à attendre
trop longtemps, 200 semble un bon compromis:

``` ruby
generations = 200
board_size = 16
```

Puis on modifie la méthode `run` de la classe `GeneticAlgorithm` de cette
manière:

``` ruby
def run
  @generations.times do |generation|
    Evaluator.new(@board_size, @population).evaluate
    best = @population.best
    # display(generation, best)
    if best.score > 1.0
      best.display
      exit
    end
    next_generation
  end
  @population.each {|individual| p individual.chromosome }
end
```

La nouveauté est la ligne suivante:

``` ruby
  @population.each {|individual| p individual.chromosome }
```

Ainsi, au bout de 200 générations, on affiche la liste des chromosomes.
Pour ceux qui ne connaisse pas Ruby, `p x` est un raccourci pour
`puts x.inspect`.

J'ai aussi pris soin de commenter la ligne `display(generation, best)`
pour pouvoir enregistrer plus tard le résultat dans un fichier sans que
celui-ci soit pollué par des données inutiles.

Quand on lance le programme, on obtient quelque chose comme ça:

    [~/genetic]⇒ ruby 8_queens.rb
    [10, 8, 5, 11, 2, 0, 15, 6, 9, 13, 1, 4, 14, 7, 14, 3]
    [10, 8, 5, 11, 2, 0, 15, 6, 9, 13, 1, 4, 14, 7, 11, 3]
    [10, 8, 5, 11, 2, 0, 15, 12, 9, 13, 1, 4, 14, 7, 14, 3]
    [10, 8, 5, 11, 2, 0, 15, 6, 9, 13, 1, 4, 14, 7, 11, 3]
    [10, 8, 5, 11, 2, 0, 15, 6, 9, 13, 1, 4, 14, 7, 14, 3]
    ...

Les chromosomes sont tous identiques, ou presque ! Pour savoir à quel
point ils sont identiques, on peut les compter à la main (!?) où écrire
un petit script de trois lignes:

``` ruby 8_queens_stat.rb
hash = Hash.new(0)
File.open(ARGV.first, "r").each_line {|line| hash[line] += 1 }
hash.each {|key, value| puts "#{"%3d" % value} => #{key}" }
```

L'explication de ce script dépasse le cadre de cet article, l'objectif
étant de savoir combien de chromosomes sont identiques. Pour cela on
refait tourner notre algorithme génétique en enregistrant le résultat
(c'est à dire la liste des chromosomes après 200 générations) dans un
fichier:

    [~/genetic]⇒ ruby 8_queens.rb > result.txt

Puis on fait travailler notre script sur ce fichier:

    [~/genetic]⇒ ruby 8_queens_stat.rb result.txt
    971 => [1, 7, 13, 11, 9, 15, 5, 14, 2, 0, 8, 6, 12, 10, 2, 4]
      1 => [1, 7, 2, 11, 9, 15, 5, 14, 2, 0, 8, 6, 12, 10, 2, 4]
      1 => [1, 7, 13, 11, 9, 15, 5, 8, 2, 0, 8, 6, 12, 10, 2, 4]
      1 => [1, 7, 13, 11, 9, 15, 5, 14, 2, 12, 8, 6, 12, 10, 2, 4]
      1 => [1, 7, 13, 11, 9, 15, 5, 14, 2, 0, 8, 6, 12, 10, 2, 0]
      2 => [1, 7, 13, 11, 9, 15, 5, 14, 9, 0, 8, 6, 12, 10, 2, 4]
      1 => [1, 13, 13, 11, 9, 15, 5, 14, 2, 0, 8, 6, 12, 10, 2, 4]
      3 => [1, 7, 13, 11, 9, 15, 5, 14, 2, 0, 8, 6, 12, 10, 2, 6]
      8 => [3, 7, 13, 11, 9, 15, 5, 14, 2, 0, 8, 6, 12, 10, 2, 4]
      1 => [1, 7, 13, 2, 9, 15, 5, 14, 2, 0, 8, 6, 12, 10, 2, 4]
      1 => [1, 7, 13, 11, 9, 15, 5, 14, 2, 0, 8, 6, 12, 10, 2, 14]
      1 => [1, 7, 13, 11, 9, 15, 5, 14, 2, 0, 8, 6, 12, 10, 3, 4]
      1 => [1, 7, 13, 3, 9, 15, 5, 14, 2, 0, 8, 6, 12, 10, 2, 4]
      1 => [1, 7, 13, 11, 9, 15, 5, 14, 2, 0, 8, 6, 12, 5, 2, 4]
      1 => [1, 7, 13, 11, 9, 15, 5, 14, 2, 0, 8, 6, 13, 10, 2, 4]
      1 => [1, 7, 14, 11, 9, 15, 5, 14, 2, 0, 8, 6, 12, 10, 2, 4]
      1 => [1, 3, 13, 11, 9, 15, 5, 14, 2, 0, 8, 6, 12, 10, 2, 4]
      2 => [1, 7, 13, 11, 4, 15, 5, 14, 2, 0, 8, 6, 12, 10, 2, 4]
      1 => [1, 7, 13, 11, 9, 15, 5, 14, 2, 0, 8, 6, 12, 14, 2, 4]

971 chromosomes sur 1000 sont identiques ! Question diversité génétique
on repassera… Voilà donc comment un extremum local se manifeste dans
un algorithme génétique: toutes les solutions convergent vers un même
point. L'algorithme ne peut plus produire de nouvelles solutions originales,
il patauge. Les quelques chromosomes différents, 29 sur 1000 dans ce cas là
(ou encore 2,9%) s'expliquent en grande partie par la mutation.

Si vous étudiez en détail le résultat ci-dessus, vous verrez que chaque
chromosome différent ne diffère du chromosome majoritaire que par un
seul de ses gènes. C'est la clé pour comprendre pourquoi la mutation
semble impuissante à nous aider dans ce problème des 8 dames, alors que
tout avait bien fonctionné avec le paradoxe du singe savant. On verra
ça dans le prochain article.

À demain.

{% connexe %}

