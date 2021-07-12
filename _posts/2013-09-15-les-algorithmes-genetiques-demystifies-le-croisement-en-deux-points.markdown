---
layout: post
title: "Les algorithmes génétiques démystifiés: le croisement en deux points"
date: 2013-09-15 11:40
legacy: true
tags: [algorithme génétique, ruby]
---



Aujourd'hui on parle plus en détail de la méthode de reproduction
utilisé jusqu'ici, à savoir le «croisement» de deux individus, et
je décris la variante du «croisement en deux points».

<!-- more -->

Croisement en un point (one point crossover)
--------------------------------------------
Pour l'instant on a utilisé la méthode du croisement en un point
(*one point crossover* in english). Pour mémoire, voici son
implémentation dans le dernier problème, le paradoxe du singe savant:

{% highlight ruby %}
def crossover(parent1, parent2)
  point = rand(1..@search_value.size)
  child = parent1.last[0...point] + parent2.last[point..-1]
  [nil, mutate(child)]
end
{% endhighlight %}

Et en voici une représentation, le caractère `:` représente le point
de croisement:

    parent A  123:45678
    parent B  abc:defgh
    
    enfant A  123:defgh
    enfant B  abc:45678

On remarque que je prends garde d'éviter les valeurs extrèmes pour le
point de croisement. Si ce point était par exemple zéro,
il n'y aurait pas croisement mais une simple copie conforme d'un parent.
Malgré tout, je ne voudrais pas laisser croire que c'est très important,
et on pourrait très bien écrire:

    point = rand(0..@search_value.size+1)

Il y aurait copie, et non croisement, dans 2/*l* cas (où *l* est la longueur
du chromosome). Plus les chromosomes sont long et moins c'est un problème.

On peut remarquer aussi que je ne crée qu'un seul enfant sur les deux
possibles. Un code plus générique devrait créer et renvoyer les deux
enfants, libre à nous d'en utiliser un seul ou les deux.

Croisement en deux points (two point crossover)
-------------------
Une autre méthode de croisement populaire est le croisement en deux
points. On intervertit le matériel génétique qui se trouve *entre* les
deux points de croisement. Voici une représentation de cette méthode:

    parent A  123:456:78
    parent B  abc:def:gh
    
    enfant A  123:def:78
    enfant B  abc:456:gh

Et voici une implémentation (toujours avec la création d'un seul
enfant):

{% highlight ruby %}
def two_point_crossover(parent1, parent2)
  point1 = rand(@search_value.size)
  point2 = rand(@search_value.size)
  point1, point2 = point2, point1 if point1 > point2
  child = parent1.last[0...point1] + parent2.last[point1..point2] +
          parent1.last[point2+1..-1]
  [nil, mutate(child)]
end
{% endhighlight %}

À ce stade, vous vous demandez sûrement quel est l'intérêt de cette
méthode ? Pour le comprendre, prenons un exemple. Le chromosome qu'on
recherche est `bonjour` et dans notre population on a le chromosome
suivant:

    bacdefr

Seul ces deux gènes extrèmes sont bons. On peut aussi le noter de cette
façon:

    b*****r

Le `*` indique un emplacement dont la valeur n'est pas significative pour
la discussion en cours. Si on applique le croisement en un point, les deux
bons gènes vont être séparés dans presque tout les cas (et même dans tous
les cas si on ne permet pas que le point de croisement se fasse aux valeurs
extrèmes). Comparez avec le chromosome suivant:

    bo*****

Les deux gènes `bo` seront rarement séparés. La probabilité est de
1/*l*-1 si on ne permet pas les valeurs extrèmes (*l* est la longueur du
chromosome). Donc avec la méthode du croisement en un point, le premier
et le dernier gène sont traités différement des autres.
Reste à savoir quelle incidence cela a sur la performance de l'algorithme.
Voici les mesures pour l'algorithme précédent (avec taille de population
et taux de mutation égal):

    =================================================
    | méthode de croisement | génération | secondes |
    =================================================
    | un point              |         81 |        5 |
    |-----------------------------------------------|
    | deux points           |         54 |        3 |
    |-----------------------------------------------|

L'amélioration se lit clairement. En attendant le prochain article,
n'hésitez pas à expérimenter ce qui vous passe par la tête (par exemple,
pourquoi se limiter à 2 parents ?).





À demain.



