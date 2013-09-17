---
layout: post
title: "Les algorithmes génétiques démystifiés 16: Le Hill-Climbing"
date: 2013-09-17 10:50
comments: true
categories: [paradoxe du singe savant, algorithme génétique, ruby, intermédiaire, hill-climbing]
---

{% level 2 %}

J'aime les algorithmes génétiques. Je les trouvent fascinants. Mais je ne
voudrais pas laisser croire qu'ils sont toujours *la* solution.
Aujourd'hui je parle de l'algorithme *Hill-Climbing*, qu'on peut considérer
comme un algorithme génétique dégénéré.

<!-- more -->

Hill-Climbing
-------------
Pourquoi dégénéré ? Parce que le *Hill-Climbing* est essentiellement un
algorithme génétique sans population et sans croisement… Le principe est
très simple: on produit une solution au hasard, puis on mute cette solution
en espérant qu'elle soit meilleure que la précédente. Dit comme ça, cela
semble un peu aventureux. Mais parfois, suivant le problème posé, ça
fonctionne vraiment bien. Gardons le thème des articles précédents,
c'est à dire le paradoxe du singe savant. On cherche toujours la même phrase,
à savoir «Mon royaume pour un cheval». C'est parti pour le code.


###Le code

``` ruby
def make_chromosome
  value = ""
  length = @search_value.size
  length.times { value += random_gene }
  value
end

def random_gene
  @genes[rand(@genes.size)]
end

def mutate(phrase)
  index = rand(@search_value.size)
  phrase[index] = random_gene
  phrase
end

def quality(phrase)
  score = 0
  phrase.split('').each_with_index do |character, index|
    score += 1 if @search_value[index] == character
  end
  score
end

@search_value = "Mon royaume pour un cheval"
@genes = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "
@solution = make_chromosome
@generation = 0
```

On a besoin de produire une phrase au hasard, que je continue à appeler
*chromosome*, et c'est la méthode `make_chromosome` qui s'en charge.
On a besoin de modifier une phrase, je continue à dire *muter*, et c'est
bien sûre le rôle de `mutate`. Enfin, on doit pouvoir évaluer la qualité
d'une phrase, avec `quality`. Rien de vraiment nouveau sous le soleil, ça
ressemble furieusement au code développé pour l'algorithme génétique
précédent.
On peut noter avec intérêt la ligne `@solution = make_chromosome`. Ici, on
ne parle pas d'individus puisqu'il n'y a pas de population.

Et maintenant le *Hill-Climbing* proprement dit. Attention les yeux, ça va
être rapide:

``` ruby
# Hill-Climbing
until @solution == @search_value do
  opponent = mutate(@solution.dup)
  @solution = opponent if quality(opponent) > quality(@solution)
  puts "Gen: #{@generation} #{@solution}"
  @generation += 1
end
```

Et voilà. Pas de population, pas de reproduction, pas de *mating pool*. Juste
une mutation et une comparaison de qualité. Mais est-ce que ça fonctionne ?

    [~/genetic]⇒ time ruby monkey_hill.rb
    Gen: 0    CwAEKaVBHW nTVWIsvhnwODtaL
    ...
    Gen: 449  CwAEKoVaHW  TouI vh wODtal
    ...
    Gen: 1446 Mnn royaiueUpoustun chFvml
    ...
    Gen: 4652 Mon royaume popr un cheval
    Gen: 4653 Mon royaume pour un cheval

    real  0m0.598s
    user  0m0.572s
    sys   0m0.024s

Un grand nombre de générations par rapport à l'algorithme génétique mais
un temps de calcul bien plus court (pour ce problème particulier).

###Moralité
Avant de se jeter dans l'écriture d'un algorithme génétique, il est
intéressant d'écrire d'abord un *Hill-Climbing*. Parfois on n'a pas
besoin de plus, parfois ça permet de valider la fonction d'évaluation.

À demain.

{% connexe %}

