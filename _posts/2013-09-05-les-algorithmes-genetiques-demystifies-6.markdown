---
layout: post
title: "Les algorithmes génétiques démystifiés 6"
date: 2013-09-05 13:01
legacy: true
tags: [algorithme génétique, ruby]
---



La dernière fois on était resté sur un algorithme parfois *bloqué* par
l'extremum local. Aujourd'hui on arrange cela grâce à la mutation génétique.

<!-- more -->

Tout d'abord un petit mot sur la mutation génétique. Vous voyez peut-être
cela comme de sombres expériences de laboratoire, ou bien vous pensez à
Peter Parker mordu par une araignée radioactive et devenant Spiderman…
En fait, la mutation génétique est un phénomène tout à fait naturel, et
à l'origine de l'évolution des espèces. Pour ce qui nous intéresse ici, on
imaginera que, de temps en temps, un gène est *mal recopié*, ce qui va se
traduire par une inversion d'un bit dans un chromosome.

Voici la méthode qui est chargée de muter un chromosome:

{% highlight ruby %}
def mutate(chromosome)
  bit = rand(48)
  value = chromosome.last
  if value[bit] == "0"
    value[bit] = "1"
  else
    value[bit] = "0"
  end
  [nil, value]
end
{% endhighlight %}

On sélectionne au hasard un bit parmi les 48 que comporte le chromosome,
puis on l'inverse. Enfin on retourne le nouveau chromosome. Pour voir ce
code à l'oeuvre, on peut écrire ceci:

{% highlight ruby %}
c = make_chromosome
puts c.inspect
c = mutate(c)
puts c.inspect
{% endhighlight %}

On peut voir qu'un bit a été inversé:

    [~/genetic]⇒ ruby test.rb 
    [nil, "101000101001011110110000011000010000110011011110"]
    [nil, "101000101001011110110000011000010000110010011110"]

Reste à savoir *quand* muter ? On considère généralement que le bon taux
de mutation se trouve entre 1/1000 et 1/100000. Ce qui nous donne la
méthode suivante:

{% highlight ruby %}
def mutation
  @population.map do |individual|
    if rand(1000) == 0
      mutate(individual)
    else
      individual
    end
  end
end
{% endhighlight %}

Un individu sur 1000 va recevoir une mutation, ce qui va permettre d'apporter
du nouveau matériel génétique et, en théorie, d'éviter de tomber dans un
extremum local. Pour voir ce que ça donne, il faut modifier le code du
dernier article pour appliquer la mutation:

{% highlight ruby %}
10000.times do |generation|
  score_population
  @population = @population.sort
  best = @population.first.first
  puts "Generation: #{generation} Best: #{best}"
  if best == 0
    genes = chromosome_to_gene(@population.first)
    puts "Formula: #{genes_to_formula(genes)}"
    exit
  end
  next_generation
  @population = mutation
end
{% endhighlight %}

Vous noterez au passage que je suis passé de 50 générations à 10000. Les
algorithmes génétiques n'ont vraiment de sens que sur un grand nombre de
générations. Voyons le résultat:

    [~/genetic]⇒ ruby test.rb 
    Generation: 0 Best: 39
    Generation: 1 Best: 100
    Generation: 2 Best: 34
    Generation: 3 Best: 88
    Generation: 4 Best: 44
    Generation: 5 Best: 19
    Generation: 6 Best: 105
    Generation: 7 Best: 47
    Generation: 8 Best: 13
    Generation: 9 Best: 13
    Generation: 10 Best: 13
    Generation: 11 Best: 2
    Generation: 12 Best: 1
    Generation: 13 Best: 3
    Generation: 14 Best: 33
    Generation: 15 Best: 19
    Generation: 16 Best: 7
    Generation: 17 Best: 9
    Generation: 18 Best: 1
    ...
    Generation: 465 Best: 1
    Generation: 466 Best: 0
    Formula: 88-1%3+900

Ça fonctionne ! Sauf que parfois…

Parfois on atteint la 10.000ème génération sans avoir la solution. Je l'ai
déjà dit et je le répète : un algorithme génétique ne peut pas garantir
que l'on trouvera la meilleure solution. Le problème avec notre algorithme
(dont je donne le code complet à la fin de l'article) tient sûrement dans
sa méthode de sélection ainsi que dans la manière dont on produit une
nouvelle génération. Il serait intéressant de voir ce qu'il se passe
en introduisant du sang frais, c'est à dire quelques individus produits
au hasard. Peut-être le sujet d'un prochain article ?

Le code source entier
------------------

{% highlight ruby %}
def make_chromosome
  value = ""
  48.times { value += rand(0..1).to_s }
  [nil, value]
end

def make_population
  population = []
  100.times { population << make_chromosome }
  population
end

def chromosome_to_gene(chromosome)
  chromosome.last.scan /.{4}/
end

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

def selection
  @selected = @population[0...50].shuffle
end

def genes_to_formula(genes)
  formula = []
  genes.each {|gene| formula << gene_to_operand(gene) }
  formula.join
end

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

def score_population
  @population = @population.map do |individual|
    genes = chromosome_to_gene(individual)
    individual[0] = evaluation(genes)
    individual
  end
end

def crossover(parent1, parent2)
  point = rand(1..47)
  child1 = [nil, parent1.last[0...point] + parent2.last[point..-1]]
  child2 = [nil, parent2.last[0...point] + parent1.last[point..-1]]
  [child1, child2]
end

def next_generation
  @selection = selection
  @population = []
  25.times do
    parent1, parent2 = @selection.slice!(0, 2)
    child1, child2 = crossover(parent1, parent2)
    child3, child4 = crossover(parent1, parent2)
    @population += [child1, child2, child3, child4]
  end
end

def mutation
  @population.map do |individual|
    if rand(1000) == 0
      mutate(individual)
    else
      individual
    end
  end
end

def mutate(chromosome)
  bit = rand(48)
  value = chromosome.last
  if value[bit] == "0"
    value[bit] = "1"
  else
    value[bit] = "0"
  end
  [nil, value]
end

@search_value = 987
@population = make_population

10000.times do |generation|
  score_population
  @population = @population.sort
  best = @population.first.first
  puts "Generation: #{generation} Best: #{best}"
  if best == 0
    genes = chromosome_to_gene(@population.first)
    puts "Formula: #{genes_to_formula(genes)}"
    exit
  end
  next_generation
  @population = mutation
end
{% endhighlight %}





À demain.



