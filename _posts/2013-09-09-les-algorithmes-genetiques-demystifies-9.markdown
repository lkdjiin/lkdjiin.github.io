---
layout: post
title: "Les algorithmes génétiques démystifiés 9"
date: 2013-09-09 12:26
legacy: true
tags: [algorithme génétique, ruby]
---



Dans [l'article précédent](http://lkdjiin.github.io/blog/2013/09/08/les-algorithmes-genetiques-demystifies-8-le-paradoxe-du-singe-savant/)
j'ai donné l'objectif de ce second algorithme, inspiré par le paradoxe du
singe savant, et on a vu comment construire la population de phrases.
Aujourd'hui, on se concentre sur la méthode d'évaluation, tout en
introduisant l'idée de «normaliser un score».

<!-- more -->

Une fois la population créée, il faut l'évaluer avant de pouvoir passer à
l'étape de sélection. Je rappelle que nos chromosomes (que j'appelle aussi
individus ou encore solutions potentielles) sont mémorisés dans une liste
contenant un score et une phrase (voir
[Les algorithmes génétiques démystifiés 8](http://lkdjiin.github.io/blog/2013/09/08/les-algorithmes-genetiques-demystifies-8-le-paradoxe-du-singe-savant/)).

Voici comment j'évalue la population:

{% highlight ruby %}
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
{% endhighlight %}

Je donne 1 point pour chaque lettre bien placée. C'est difficile de
faire plus simple. Je pense que dans un autre article, on expérimentera
une autre manière d'évaluer les phrases en attribuant aussi des points pour
les lettres mal placées.

Contrairement à l'algorithme précédent, je vais aller plus loin en
transformant ces scores en pourcentages. Utiliser les pourcentages sera
très utile pour la méthode de sélection que je développerais dans le
prochain article. Pour transformer les scores en pourcentages, on doit
d'abord les normaliser. Cela signifie qu'on va transformer chaque score en
un nombre compris entre 0 et 1. Pour normaliser, on calcule la somme de
tous les scores de la population et on divise chaque score par ce total.
Il suffit ensuite de multiplier par 100 pour avoir un pourcentage:

{% highlight ruby %}
def normalize_population_score
  total = @population.inject(0) {|sum, person| sum + person.first }
  @population.map! {|person| [person.first.to_f / total * 100, person.last] }
end
{% endhighlight %}

Finalement, on met tout ça ensemble dans une méthode:

{% highlight ruby %}
def score_population
  evaluate_population
  normalize_population_score
end
{% endhighlight %}

Voici notre programme `monkey.rb` pour l'instant:

{% highlight ruby %}
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

@search_value = "Mon royaume pour un cheval"
@genes = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "
@population_size = 100
@population = make_population
score_population
@population.each {|i| puts i.inspect }
{% endhighlight %}

Et voici ce que ça donne:

    [~/genetic]⇒ ruby monkey.rb 
    [2.083333333333333, "GPjvZUOnEHAwBuVPazOXXYhwaG"]
    [0.0, "yQdkKetHFCUpMSMjVFwepXREhT"]
    [4.166666666666666, "Fz pHfkVjyRoIhgGglvfWhXhpl"]
    [0.0, "fwjafrGAalfDRhpnpAtUoNfVNU"]
    [0.0, "zXxPlALVVKxGg sOUdKpSAdKNG"]
    [0.0, "myoLBtIbKhfNQPnHUzqHkw Mjz"]
    [0.0, "HXDVgzNAKoUhjbVPLLNikGdWqX"]
    [0.0, "XQIqLRKNzrxXJUqWRFQpYozNMB"]
    [0.0, "xuIIUHEwaAdFcVedVJXkTJjFEv"]
    .
    .
    .
    [6.25, " oFkamnafTYpazNMRPY KCEVLZ"]
    [2.083333333333333, "JqxvMEowRmEzeRPUwXJdCQQ UB"]

La prochaine fois, on parlera de la méthode de sélection dite de
«la roue de la fortune», secondée par une piscine d'accouplement
(oui, c'est bien le terme, véridique !).





À demain.


