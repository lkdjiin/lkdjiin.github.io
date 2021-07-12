---
layout: post
title: "Les algorithmes génétiques démystifiés 15: croisement uniforme"
date: 2013-09-16 13:19
legacy: true
tags: [algorithme génétique, ruby]
---



Après le croisement en un point et le croisement en deux points, on
discute aujourd'hui d'une troisième méthode: le croisement uniforme.

<!-- more -->

Croisement uniforme (uniform crossover)
-----------------
Pourquoi s'arrêter au croisement en deux points ? Pourquoi pas trois points ?
Ou encore quatre ? Si on pousse cette démarche, on arrive au croisement
uniforme. Le principe est le suivant: on prend deux parents, A et B ; pour
chaque gènes on lance une pièce de monnaie ; si c'est face l'enfant prend
le gène du parent A ; si c'est pile l'enfant prend le gène du parent B.

{% highlight ruby %}
def uniform_crossover(parent1, parent2)
  child = ""
  parent1.last.split('').each_with_index do |bit, index|
    if 0.5 >= rand
      child += parent2.last[index]
    else
      child += parent1.last[index]
    end
  end
  [nil, mutate(child)]
end
{% endhighlight %}

Alors voyons les performances pour un nombre d'individus égal et un taux de
mutation égal:

    =================================================
    | méthode de croisement | génération | secondes |
    =================================================
    | un point              |         81 |        5 |
    |-----------------------------------------------|
    | deux points           |         54 |        3 |
    |-----------------------------------------------|
    | uniforme              |         47 |        6 |
    |-----------------------------------------------|

Le nombre de générations nécéssaires pour trouver la solution diminue
significativement mais en même temps le nombre de secondes a doublé
par rapport au croisement en deux points. Est-ce qu'il faut jetter la
méthode du croisement uniforme aux oubliettes ? Je ne pense pas. On peut
imaginer que si le croisement uniforme prends 2 fois plus de temps que
le croisement en deux points, c'est parce que celle-ci (croisement uniforme)
génère un nombre aléatoire pour chaque gènes. Si la méthode d'évaluation
était plus gourmande en temps de calcul, les quelques générations gagnées
par le croisement uniforme s'avéreraient payantes.





À demain.



