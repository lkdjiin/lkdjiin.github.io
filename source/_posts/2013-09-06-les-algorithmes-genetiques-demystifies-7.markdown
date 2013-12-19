---
layout: post
title: "Les algorithmes génétiques démystifiés 7"
date: 2013-09-06 11:59
comments: true
categories: [algorithme génétique, ruby, intermédiaire]
---

{% level 2 %}

[Hier](http://lkdjiin.github.io/blog/2013/09/05/les-algorithmes-genetiques-demystifies-6/)
on a amélioré l'algorithme grâce à la mutation. C'est mieux mais on
peut encore faire mieux. Aujourd'hui on parle un peu plus en détail de
la sélection et de la diversité génétique.

<!-- more -->

La sélection
------------
Voici la méthode de sélection:

``` ruby
def selection
  @selected = @population[0...50].shuffle
end
```

C'est clair et limpide : on conserve la meilleure moitié de la population.
Mais ça pose des problèmes. Que faire si un gène important pour notre
solution se trouve dans la moitié supprimée ? On a vu hier qu'en *théorie*
la mutation régle le problème. Mais en *pratique* on a vu aussi qu'on pouvait
atteindre 10.000 générations sans trouver la solution. Autre problème de
taille : l'individu classé à la 1ère place va produire quatre enfants,
tout comme l'invidu classé à la 50ème place. Pourtant il y a un monde entre
les deux. De même, il y a peu de différence entre la 50ème place et la
51ème, et pourtant l'un se reproduira et pas l'autre. Tout ceci semble assez
bancal et arbitraire. Dans un prochain article on explorera une méthode de
sélection plus *naturelle*, pour l'instant on va essayer d'augmenter le
nombre d'individus sélectionnés, juste pour voir:

``` ruby
def selection
  @selected = @population[0...80].shuffle
end
```

La diversité génétique
-------------------

Voici la méthode utilisée hier pour produire une nouvelle génération:

``` ruby
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
```

On va la changer ainsi:

``` ruby
def next_generation
  @selection = selection
  @population = []
  40.times do
    parent1, parent2 = @selection.slice!(0, 2)
    child1, child2 = crossover(parent1, parent2)
    @population += [child1, child2]
  end
  20.times { @population << make_chromosome }
end
```

Tout d'abord on tient compte du fait que le nombre d'individus sélectionnés
a changé : il est maintenant de 80, on va donc former 40 couples. Ensuite,
chaque couple ne va produire que 2 enfants. Enfin, on complète notre
population avec 20 individus créés au hasard. Ce sont eux qui vont apporter
la diversité génétique qui nous faisait défaut.

J'ai testé plusieurs dizaines de fois, et la solution a toujours été
trouvée avant la 1000ème génération (généralement bien avant).
N'hésitez pas à faire des tests
en modifiant le nombre d'invidus sélectionnés, le taux de mutation,
la taille de la population initiale, etc.

La prochaine fois, j'aimerais trouver un problème (toujours très simple) où
les individus ne seraient pas codés sous forme de bits. Je vais chercher ça.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

