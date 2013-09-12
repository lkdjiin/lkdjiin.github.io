---
layout: post
title: "Les algorithmes génétiques démystifiés 12"
date: 2013-09-12 08:28
comments: true
categories: [paradoxe du singe savant, algorithme génétique, ruby, intermédiaire]
---

{% level 2 %}

Pour résoudre le paradoxe du singe savant, on a utilisé la méthode
de sélection dite de «la roue de la fortune», mais je n'avais pas
fournit l'algorithme complet de cette méthode. On en parle aujourd'hui.

<!-- more -->

Le problème avec la simulation de la roue de la fortune que j'ai
utilisé [précédemment](http://lkdjiin.github.io/blog/2013/09/10/les-algorithmes-genetiques-demystifies-10/),
c'est qu'elle n'est pas réaliste. Je n'utilisai que la partie entière des
scores d'évaluation pour placer des copies des individus dans le
*mating pool*. Ainsi un score de 0,99 était éliminatoire, et un score de 2,01
était vu comme deux fois plus adapté qu'un score de 1,99 !

Une roue de la fortune réaliste
--------------------------------

L'idée, qui vient de [John Holland](http://en.wikipedia.org/wiki/John_Henry_Holland), est de donner une chance supplémentaire
au individus de placer une copie d'eux-mêmes en fonction de la partie
fractionnaire de leur score. Par exemple un individu évalué à 1,87 placera
d'office une copie dans le *mating pool* et aura 87 chances sur 100 de placer
une seconde copie. De même, un individu évalué à 0,49 aura 49 chances sur 100
de placer une copie. Simple, efficace et réaliste. Voici la méthode
`create_mating_pool` révisée:

``` ruby
def create_mating_pool
  mating_pool = []
  @population.each do |person|
    integer_part = person.first.to_i
    fractional_part = person.first - integer_part
    integer_part.times { mating_pool << person }
    mating_pool << person if rand < fractional_part
  end
  mating_pool
end
```

Pour que ça fonctionne avec n'importe quelle taille de population, et pas
seulement 100 individus, il faut aussi réviser la façon dont on
normalise les scores:

``` ruby
def normalize_population_score
  total = @population.inject(0) {|sum, person| sum + person.first }
  @population.map! do |person|
    [person.first.to_f / total * @population_size, person.last]
  end
end
```

Et voilà, on peut maintenant jouer avec nos deux variables que sont
`@population_size`, la taille de la population, et `@mutation_rate`, le
taux de mutation, pour rendre l'algorithme le plus rapide possible.

Il y a beaucoup de choses à propos des algorithmes génétiques sur
lesquelles j'ai encore envie d'écrire, notamment:

* analyse des variables
* autres méthodes de reproduction
* autres méthodes de sélection
* mélange élitisme/roue de la fortune
* code orienté objet (éventuellement création d'un framework)
* algorithme dégénéré (Hill-climbing)
* extremum local

Chaque point de cette liste fera sûrement l'objet d'un (ou plusieurs)
futur article.

À demain.

{% connexe %}
