---
layout: post
title: "Les algorithmes génétiques démystifiés 22"
date: 2013-09-25 14:22
comments: true
categories: [problème des 8 dames, algorithme génétique, ruby, intermédiaire]
---

{% level 2 %}

Après avoir trouver comment représenter un chromosome pour le
problème des 8 dames ([article précédent](http://lkdjiin.github.io/blog/2013/09/24/les-algorithmes-genetiques-demystifies-21-probleme-des-8-dames/)),
on regarde aujourd'hui comment réaliser l'évaluation de la population.

<!-- more -->

Sans plus attendre, voici la classe `Evaluator` dans toute sa
splendeur, on la détaille après:

``` ruby
class Evaluator
  def initialize(board_size, population)
    @board_size = board_size
    @population = population
  end

  def evaluate
    @population.each {|individual| score(individual) }
    fitness
  end

  private

  def score(individual)
    individual.score = 1.0 / conflicts(individual)
  end

  def conflicts(individual)
    # Calcule et renvoie le nombre de paires de dames en conflits.
  end

  def fitness
    total = @population.inject(0) {|sum, individual| sum + individual.score }
    @population.each do |individual|
      individual.fitness = individual.score.to_f / total * @population.size
    end
  end
end
```

Tout d'abord le constucteur:

``` ruby
  def initialize(board_size, population)
```

Il prends comme paramêtre la taille de l'échiquier et la population à
évaluer. Trouver une solution pour un échiquier de 8 x 8 cases ne
devrait pas être trop difficile et il sera plus intéressant de voir
comment l'algorithme se débrouille avec des échiquiers de plus grande
taille.

La méthode `evalute` est identique à celle de la
[dernière fois](http://lkdjiin.github.io/blog/2013/09/19/les-algorithmes-genetiques-demystifies-18/):
elle calcule le *score* puis le *fitness* de chaque individu.

Passons à la méthode `conflicts`, qui n'est pas encore implémentée:

``` ruby
  def conflicts(individual)
    # Calcule et renvoie le nombre de paires de dames en conflits.
  end
```

C'est en calculant le nombre de paires de dames en conflits qu'on pourra
évaluer les différentes positions. Plus il y a de conflits, plus on est
loin d'une solution. À l'inverse, une solution possède zéro conflits.
L'implémentation sera pour la prochaine fois.

Voyons maintenant la méthode `score`:

``` ruby
  def score(individual)
    individual.score = 1.0 / conflicts(individual)
  end
```

Pourquoi diviser 1 par le nombre de conflits ? Pourquoi ne pas avoir écrit
simplement `individual.score = conflicts(individual)` ?
Parce que je ne trouve pas naturel qu'un score de zéro soit meilleur qu'un
score de 5, 10, 20, etc. Je préfère donc calculer l'inverse du nombre de
conflits. De cette manière si il y a 10 conflits, le score sera 0,1 et si il
y a 2 conflits le score sera 0,5. Et si il y a zéro conflits ? Ruby ne pose
pas de problème avec les nombres réèls:

``` irb
[~]⇒ irb
>> 1.0 / 0
Infinity
```

Je saurais donc que j'ai trouvé une solution quand un score sera supérieur
à 1. Avec d'autres langages on peut gérer ça avec des exceptions, des erreurs,
détecter la division par zéro avant de la faire, etc. Ou encore ajouter
une petite valeur au nombre de conflits, par exemple:

    score = 1.0 / (nombre_de_conflits + 0.1)

La prochaine fois on verra comment calculer le nombre de conflits.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

