---
layout: post
title: "Les algorithmes génétiques démystifiés 10"
date: 2013-09-10 08:44
comments: true
categories: [paradoxe du singe savant, algorithme génétique, ruby, intermédiaire]
---

{% level 2 %}

Dans [l'article précédent](http://lkdjiin.github.io/blog/2013/09/09/les-algorithmes-genetiques-demystifies-9/)
on a appris à évaluer la population en normalisant les scores.
Aujourd'hui on s'attaque à la méthode de sélection dite de
«la roue de la fortune».

<!-- more -->

Dans l'algorithme génétique [précédent](http://lkdjiin.github.io/blog/2013/08/29/les-algorithmes-genetiques-demystifies-2/)
j'utilisais une méthode de sélection *artificielle* qu'on appelle
l'élitisme : je conservais un certain nombre des meilleurs
individus d'une génération, en éliminant purement et simplement les
autres. J'ai commencé par présenter cette méthode, l'élitisme, car c'est
la plus simple. On a ainsi pu se concentrer sur d'autres parties des
algorithmes génétiques. Seulement voilà, on a vu que cette méthode de
sélection posait certains problèmes, notamment l'appauvrissement du
patrimoine génétique. La méthode de la roue de la fortune va donner une
chance à tout individu porteur d'un bon gène de le transmettre à la
génération suivante. Mais bien sûr, certains auront plus de chances
que d'autres…

La roue de la fortune
---------------------

Imaginez une roue de la fortune où chaque case représenterait un individu.
Imaginez que plus l'individu est adapté, plus sa case sur cette roue est
large. Autrement dit, un meilleur individu à une case qui occupe un
pourcentage plus important de la roue qu'un moins bon individu. Tiens !
Ça tombe bien, la dernière fois on a justement transformé les scores en
pourcentages.

On va utiliser cette image de la roue de la
fortune pour sélectionner des individus en vue de la reproduction.
Je vais prendre un exemple : supposons une population de 5 individus nommés
A, B, C, D et E. Après évaluation nous pourrions avoir:

    A 40%
    B 30%
    C 20%
    D 10%
    E  0%

Pour simuler le principe de la roue de la fortune, nous allons créer une
sélection avec 40 copies de A, 30 copies de B, 20 copies de C et 10 copies
de D. Quand le moment de la reproduction sera venu, on tirera au sort des
couples de parents. De cette manière, les plus adaptés auront plus de
chances de transmettre leurs gènes, mais même les moins adaptés auront aussi
leur chance. L'endroit où l'on place les individus sélectionnés (suivant le
langage : une liste, un tableau, etc) est appellé *mating pool*, qu'on peut
traduire par piscine d'accouplement. J'aurais préféré un terme qui fasse
moins laboratoire, comme «club de rencontre»…

Voyons le code pour créer ce fameux *mating pool*:

``` ruby
def create_mating_pool
  mating_pool = []
  @population.each do |person|
    person.first.to_i.times { mating_pool << person }
  end
  # mating_pool.each {|i| puts i.inspect }
  mating_pool
end
```

La ligne commentée ne sera pas incluse dans le programme final,
mais elle va servir aujourd'hui pour voir ce qu'il se passe et
identifier un souci. Voici le code complet du programme, jusqu'à maintenant:

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

def create_mating_pool
  mating_pool = []
  @population.each do |person|
    person.first.to_i.times { mating_pool << person }
  end
  mating_pool.each {|i| puts i.inspect }
  mating_pool
end

@search_value = "Mon royaume pour un cheval"
@genes = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "
@population_size = 100
@population = make_population
score_population
create_mating_pool
```

Si on lance ce programme, voici une sortie possible:

    [~/genetic]⇒ ruby monkey.rb 
    [1.9607843137254901, "xuo pqnnoRrKbvXoQUXbvNVHxA"]
    [1.9607843137254901, "Yri QsIVwvnPsNouYLugGlZPEg"]
    [1.9607843137254901, "MBxSiHlhlnlgeMwtiVIXNa eiC"]
    [1.9607843137254901, "JggyWIGUdXwfpcpeRVVUGPzeFx"]
    [5.88235294117647, "HPIJqwyYbgZEboKAkVEsFVeNTa"]
    [5.88235294117647, "HPIJqwyYbgZEboKAkVEsFVeNTa"]
    [5.88235294117647, "HPIJqwyYbgZEboKAkVEsFVeNTa"]
    [5.88235294117647, "HPIJqwyYbgZEboKAkVEsFVeNTa"]
    [5.88235294117647, "HPIJqwyYbgZEboKAkVEsFVeNTa"]
    ...

On voit que les individus ayant un pourcentage de 1 virgule quelque chose
ont une seule copie d'eux-mêmes, alors qu'un individu avec un pourcentage
de 5 virgule quelque chose a bien placé cinq copies de lui-même.
Comme il n'est pas possible de mettre 1.96 (ou 5.88) copie(s) j'ai utilisé
seulement la partie entière. C'est un vrai problème. Un pourcentage de 1.0
place une copie et un pourcentage de 1.99 place aussi une copie alors que
1.99 est en gros 2 fois meilleur que 1.0 ! Pire, un pourcentage de
0.99 est éliminé, et on a vu avec l'algorithme [précédent](http://lkdjiin.github.io/blog/2013/08/29/les-algorithmes-genetiques-demystifies-2/)
que ça n'était pas une bonne chose. Encore pire, l'oubli de ces chiffres
après la virgule peut faire crasher notre programme ! Comment ? Si on
augmente la taille de la population, il devient plus que probable que
chaque individus totalise un pourcentage inférieur à 1%. Autrement dit,
le *mating pool* risque de rester vide… Tant qu'on gardera une population
de 100 individus ça devrait passer, mais il faudra bien résoudre ce
problème un jour. La prochaine fois on terminera notre algorithme
avec la reproduction.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

