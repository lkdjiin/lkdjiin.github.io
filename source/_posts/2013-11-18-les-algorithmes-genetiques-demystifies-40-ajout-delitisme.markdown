---
layout: post
title: "Les algorithmes génétiques démystifiés 40: Ajout d'élitisme"
date: 2013-11-18 17:39
comments: true
categories: [algorithme génétique, intermédiaire, ruby, problème du sac à dos, élitisme]
---

{% level 2 %}

Dans la plupart des ouvrages, thèses ou mémoires consacrés aux algorithmes
génétiques il est dit:

{% blockquote %}
Un peu d'élitisme améliore les performances des algorithmes génétiques.
{% endblockquote %}

Voyons voir si c'est vrai.

<!-- more -->

Une petite analyse
------------------
En lançant la première version du programme
([voir le code](https://github.com/lkdjiin/knapsack_genetic_algorithm/blob/master/knapsack.rb) et/ou
[voir l'article](http://lkdjiin.github.io/blog/2013/11/16/les-algorithmes-genetiques-39-resolution-du-sac-a-dos/))
on s'aperçoit qu'une génération *n*+1 n'améliore pas forcement le score du
meilleur individu:

    [~]⇒ ruby knapsack.rb 
    Gen: 0 Best score: 867
    Gen: 1 Best score: 895
    Gen: 2 Best score: 920
    Gen: 3 Best score: 877
    Gen: 4 Best score: 887
    Gen: 5 Best score: 925
    Gen: 6 Best score: 927
    Gen: 7 Best score: 960
    Gen: 8 Best score: 960
    Gen: 9 Best score: 915
    Gen: 10 Best score: 950
    Gen: 11 Best score: 925

Dans l'extrait ci-dessus, le meilleur individu de la génération n° 8
possède un score de 960, alors qu'à la génération suivante, le meilleur
individu retombe à un score de 915.

Mise en place de l'élite
------------------------
Je vais donc mettre en place une seconde version de ce programme où je
vais conserver les quatre meilleurs individus de chaque génération pour la
génération suivante. Le code complet de cette seconde version se trouve
sur Github: [knapsack2.rb](https://github.com/lkdjiin/knapsack_genetic_algorithm/blob/master/knapsack2.rb).
Seule la méthode `next_generation`, de la classe `GeneticAlgorithm`, change:

``` ruby
def next_generation
  @population.sort_by! {|i| i.score}
  elite = @population.pop(4)
  pool = MatingPool.new(@population)
  population_size = @population.size
  @population.clear
  population_size.times do
    @population << @crossover.two_point(pool.random, pool.random)
  end
  @population.concat elite
end
```

Voici quelques explications. Tout d'abord la population est triée sur le
score, du plus faible au plus important:

    @population.sort_by! {|i| i.score}

Puis on retire les quatre meilleurs individus de la population et on les
conserve dans `elite`:

    elite = @population.pop(4)

À la fin de la sélection/croisement/mutation, on réintroduit l'élite dans
la nouvelle population:

    @population.concat elite

Les performances
----------------
J'ai fait tourner chaque programme 200 fois et fait la moyenne de la
génération où la meilleure solution (score de 1030) est trouvée:

    Programme    | Génération moyenne
    =================================
    knapsack.rb  |              72.06
    ---------------------------------
    knapsack2.rb |              67.61

Les performances sont bien améliorées. Pas d'une manière spectaculaire, mais
c'est toujours bon à prendre.

La prochaine fois on verra si on peut encore améliorer les performances en
tenant compte des solutions invalides.

À demain.

{% connexe %}

