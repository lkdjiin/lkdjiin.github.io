---
layout: post
title: "Les algorithmes génétiques démystifiés 11"
date: 2013-09-11 09:04
comments: true
categories: [paradoxe du singe savant, algorithme génétique, ruby, intermédiaire]
---
{% level 2 %}

La [dernière fois](http://lkdjiin.github.io/blog/2013/09/10/les-algorithmes-genetiques-demystifies-10/)
on a assuré la sélection à l'aide d'une piscine
d'accouplement (je ne me lasse pas de ce terme…). Aujourd'hui, on peut
aller au bout de l'algorithme en ajoutant la reproduction.

<!-- more -->

La reproduction des phrases
---------------------------

Il n'y a rien de nouveau par rapport à [l'algorithme précédent](http://lkdjiin.github.io/blog/2013/08/29/les-algorithmes-genetiques-demystifies-2/),
c'est peut-être même plus simple. Voici la méthode `crossover`, qui
permet d'obtenir un enfant:

``` ruby
def crossover(parent1, parent2)
  point = rand(1..(@search_value.size - 1))
  child = parent1.last[0...point] + parent2.last[point..-1]
  [nil, mutate(child)]
end
```

**Edit du 14 sept 2013** Le code ci-dessus contient une erreur, à la
seconde ligne il faut lire: `point = rand(1..@search_value.size)`.

`crossover` prends deux chromosomes en entrée (les parents). On définit
un point de croisement au hasard. On utilise ce point de croisement pour
*couper* les parents en deux parties. Un enfant est produit en concaténant
la première partie du premier parent avec la seconde partie du second
parent. Enfin on renvoie un chromosome, après avoir passer l'enfant/phrase
à la mutation. Voici justement la méthode chargée de la mutation:

``` ruby
def mutate(phrase)
  @search_value.size.times do |index|
    phrase[index] = random_gene if rand < @mutation_rate
  end
  phrase
end
```

La différence avec [l'algorithme précédent](http://lkdjiin.github.io/blog/2013/08/29/les-algorithmes-genetiques-demystifies-2/) est que cette fois chaque gène
peut muter. Avantage: on est plus proche du phénomène naturel et on pourrait
se retrouver avec un chromosome dont 2 ou 3 gènes sont mutants, ça semble
bon pour la diversité génétique. Inconvénient: Générer un nombre aléatoire
pour chaque gène peut faire tomber les performances si on a un millier de
gènes (ou plus) par chromosome et/ou une population importante. Comme
je dis d'habitude: «Si c'est de l'informatique, c'est une histoire de
compromis».

On peut maintenant créer une méthode `next_generation` qui englobe la
sélection et la reproduction:

``` ruby
def next_generation
  mating_pool = create_mating_pool
  pool_size = mating_pool.size
  @population = []
  @population_size.times do
    parent1 = mating_pool[rand(pool_size)]
    parent2 = mating_pool[rand(pool_size)]
    @population << crossover(parent1, parent2)
  end
end
```

Je ne vais pas vous faire l'affront d'expliquer cette méthode, vous avez
toutes les cartes en main pour la comprendre. Sinon, c'est que j'ai mal
fait mon boulot…

Il reste à mettre tout ça ensemble, voici le code complet du programme:

``` ruby monkey.rb
def make_chromosome
  value = ""
  length = @search_value.size
  length.times { value += random_gene }
  [nil, value]
end

def random_gene
  @genes[rand(@genes.size)]
end

def make_population
  population = []
  @population_size.times { population << make_chromosome }
  population
end

def score_population
  evaluate_population
  normalize_population_score
end

def evaluate_population
  @population.map! {|person| [evaluate(person.last), person.last] }
end

def evaluate(phrase)
  score = 0
  phrase.split('').each_with_index do |character, index|
    score += 1 if @search_value[index] == character
  end
  score
end

def normalize_population_score
  total = @population.inject(0) {|sum, person| sum + person.first }
  @population.map! {|person| [person.first.to_f / total * 100, person.last] }
end

def next_generation
  mating_pool = create_mating_pool
  pool_size = mating_pool.size
  @population = []
  @population_size.times do
    parent1 = mating_pool[rand(pool_size)]
    parent2 = mating_pool[rand(pool_size)]
    @population << crossover(parent1, parent2)
  end
end

def create_mating_pool
  mating_pool = []
  @population.each do |person|
    person.first.to_i.times { mating_pool << person }
  end
  mating_pool
end

def crossover(parent1, parent2)
  point = rand(1..@search_value.size)
  child = parent1.last[0...point] + parent2.last[point..-1]
  [nil, mutate(child)]
end

def mutate(phrase)
  @search_value.size.times do |index|
    phrase[index] = random_gene if rand < @mutation_rate
  end
  phrase
end

def solution_found
  found = false
  @population.each do |person|
    found = true if person.last == @search_value
  end
  found
end

@search_value = "Mon royaume pour un cheval"
@genes = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "
@population_size = 100
@mutation_rate = 0.01
@population = make_population

1000.times do |generation|
  score_population
  puts "Generation: #{generation}"
  @population.each {|i| puts i.inspect }
  exit if solution_found
  next_generation
end
```

Et voilà le résultat:

    [~/genetic]⇒ ruby monkey.rb 
    ...
    Generation: 869
    [1.0092854259184496, "Mon royaume pour un chevaB"]
    [1.0092854259184496, "Mon royaume pour un chevan"]
    [1.0092854259184496, "Mon royaume pour un chevaB"]
    ...
    [1.0496568429551878, "Mon royaume pour un cheval"]
    ...
    [1.0092854259184496, "Mon royaume pour un chevan"]
    [1.0092854259184496, "Mon royaume pour un chevaB"]
    [0.9689140088817118, "Mon royaume pour un chNvaB"]

La prochaine fois on va améliorer notre méthode de sélection pour
tenir compte des chiffres après la virgule.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

