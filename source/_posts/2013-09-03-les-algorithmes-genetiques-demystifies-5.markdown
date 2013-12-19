---
layout: post
title: "Les algorithmes génétiques démystifiés 5"
date: 2013-09-03 08:43
comments: true
categories: [algorithme génétique, ruby, intermédiaire]
---

{% level 2 %}

Maintenant qu'on sait créer une population de solutions, l'évaluer,
opérer une sélection des meilleures solutions et obtenir une nouvelle
génération par la reproduction, il reste à assembler toutes ces parties
et voir ce qu'il se passe…

<!-- more -->

Voici le code complet de notre algorithme:

``` ruby
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

# Ce qui suit est nouveau:

@search_value = 987
@population = make_population

50.times do |generation|
  score_population
  @population = @population.sort
  best = @population.first.first
  puts "Generation: #{generation} Best: #{best}"
  exit if best == 0
  next_generation
end
```

Seules les dernières lignes de code sont nouvelles. Elles sont assez
simple à comprendre je pense, même si vous ne connaissez pas le
langage Ruby. On commence par définir le nombre qu'on recherche puis
on crée la population d'origine au hasard avec `@population = make_population`.
Ensuite on itère sur 50 générations avec `50.times do |generation|`. C'est
notre première condition de sortie : quoiqu'il se passe, on arrête le
traitement au bout à la 50ème génération. Dans cette boucle on évalue
la génération en cours avec `score_population` et on la trie. Pour savoir
où on en est visuellement on extrait le meilleur score avec
`best = @population.first.first` et on affiche cette information à la ligne
suivante. Vient ensuite notre seconde et dernière condition de sortie avec
`exit if best == 0` ; autrement dit on stoppe le traitement à la première
solution trouvée. Pour finir, on produit la génération suivante avec
`next_generation`.

Et ça donne quoi ?
--------------
La plupart du temps ça donne quelque chose comme ça:

``` console
[~/genetic]⇒ ruby test.rb 
Generation: 0 Best: 507
Generation: 1 Best: 138
Generation: 2 Best: 485
Generation: 3 Best: 347
Generation: 4 Best: 65
Generation: 5 Best: 208
Generation: 6 Best: 222
Generation: 7 Best: 15
Generation: 8 Best: 15
Generation: 9 Best: 2
Generation: 10 Best: 0
```

Les générations successives convergent lentement vers la solution.
Si vous voulez voir la solution trouvée (c'est normal d'être curieux)
vous pouvez remplacez une ligne de code pour afficher la solution:

``` ruby
# exit if best == 0
if best == 0
  genes = chromosome_to_gene(@population.first)
  puts "Formula: #{genes_to_formula(genes)}"
  exit
end
```

Voici quelques exemples de solutions:

    Formula: 912%429+933
    Formula: 670+594-277
    Formula: 893+91%96+3
    Formula: 923--03--61

Alors, la plupart du temps, ça se passe bien. Mais parfois un phénomène
étrange se produit:

``` console
[~/genetic]⇒ ruby test.rb 
Generation: 0 Best: 597
Generation: 1 Best: 621
Generation: 2 Best: 104
...
Generation: 25 Best: 1
...
Generation: 48 Best: 1
Generation: 49 Best: 1
[~/genetic]⇒ 
```

L'algorithme reste *bloqué* sur une valeur et on atteint la 50ème
génération sans avoir trouver de solution. What the fuck ? Et bien
l'algorithme a atteint ce qu'on appelle
[l'extremum local](http://fr.wikipedia.org/wiki/Extremum_local). Pour faire
court, ça signifie qu'il ne peut pas faire mieux
avec les gènes dont il disposait à l'origine. Je developperais cette
idée dans un futur article. En attendant, comment on règle ça ?
En s'inspirant encore une fois de phénomènes naturels : la mutation
et/ou la diversité génétique.
C'est le sujet du prochain article.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

