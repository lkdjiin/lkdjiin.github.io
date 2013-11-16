---
layout: post
title: "Les algorithmes génétiques 39: Resolution du sac à dos"
date: 2013-11-16 10:06
comments: true
categories: [algorithme génétique, intermédiaire, ruby, problème du sac à dos]
---

{% level 2 %}

La dernière fois on a vu une façon simplement
[d'évaluer le contenu](http://lkdjiin.github.io/blog/2013/11/13/les-algorithmes-genetiques-demystifies-38-evaluation-du-sac-a-dos/)
du sac à dos.
Aujourd'hui on met en place l'algorithme génétique proprement dit:
sélection, croisement, mutation, etc.

<!-- more -->

J'ai mis le [code complet de l'algorithme sur Github](https://github.com/lkdjiin/knapsack_genetic_algorithm/blob/master/knapsack.rb).
Celui-ci est basé sur ce qu'on a fait jusqu'ici pour
[le paradoxe du singe savant](http://lkdjiin.github.io/blog/2013/09/08/les-algorithmes-genetiques-demystifies-8-le-paradoxe-du-singe-savant/)
et pour [le problème des 8 dames](http://lkdjiin.github.io/blog/2013/09/24/les-algorithmes-genetiques-demystifies-21-probleme-des-8-dames/).
Je vais donc commenter les parties qui changent.

La classe GeneticAlgorithm
--------------------------

``` ruby
class GeneticAlgorithm
  # ...

  def run
    best_ever = nil
    @generations.times do |generation|
      Evaluator.new(@capacity, @population).evaluate
      best = @population.best
      best_ever = best if best > best_ever
      display(generation, best)
      next_generation
    end
    display_best_ever(best_ever)
  end

  private

  # ...

  def display_best_ever(individual)
    puts "----------------------"
    puts "Best ever"
    puts "----------------------"
    puts "score:      #{individual.score}"
    puts "chromosome: #{individual.chromosome_as_list}"
  end

  # ...
end
```

Voyons la méthode `run`. La variable `best_ever` va contenir le meilleur
individu, toutes générations confondues. À chaque itération, on compare
ce «meilleur de tout les temps» avec le meilleur individu de la génération:

    best_ever = best if best > best_ever

C'est pour ça qu'on avait besoin d'une méthode `>` dans la classe `Individual`
(voir [cet article](http://lkdjiin.github.io/blog/2013/11/12/les-algorithmes-genetiques-demystifies-37-le-probleme-du-sac-a-dos/)).

À la fin de la méthode `run` on utilise la nouvelle méthode `display_best_ever`
pour afficher notre meilleure solution.

La classe Mutator
-----------------

La seconde classe qui change un peu est la classe `Mutator`:

``` ruby
class Mutator
  def initialize(chromosome_size, mutation_rate)
    @size = chromosome_size
    @rate = mutation_rate
  end

  def mutate(chromosome)
    @size.times do |index|
      chromosome[index] = ! chromosome[index] if rand < @rate
    end
    chromosome
  end
end
```

Un chromosome étant une liste (un Array) de booléens, la mutation consiste
à *inverser* un élément, true devient false et inversement:

    chromosome[index] = ! chromosome[index] if rand < @rate

Le lancement du programme
-------------------------
Le problème n'a pas l'air trop complexe, je me dis donc que 100 générations
devraient suffire. La population compte 1 000 individus, ce qui est
classique et le taux de mutation est assez élevé (1%):

``` ruby
knapsack_capacity = 400
generations = 100
population = Population.new(Knapsack::ITEMS.size, 1000)
mutation = 0.01
GeneticAlgorithm.new(generations, population, knapsack_capacity, mutation).run
```

Et voici le moment de vérité:

    [~]⇒ ruby knapsack.rb 
    Gen: 0 Best score: 922
    Gen: 1 Best score: 950
    .
    .
    .
    Gen: 57 Best score: 1010
    Gen: 58 Best score: 957
    Gen: 59 Best score: 1030
    .
    .
    .
    Gen: 99 Best score: 957
    ----------------------
    Best ever
    ----------------------
    score:      1030
    chromosome: map, compass, water, sandwich, glucose, banana, suntan cream,
    waterproof trousers, waterproof overclothes, note-case, sunglasses, socks

La prochaine fois on va analyser ce résultat et faire en sorte de
l'améliorer.

À demain.

{% connexe %}

