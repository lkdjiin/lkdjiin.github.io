---
layout: post
title: "Les algorithmes génétiques démystifiés 47: Économie"
date: 2013-12-23 16:13
comments: true
categories: [algorithme génétique, intermédiaire, ruby, problème du sac à dos, économie, investissement]
---

{% level 2 %}

La dernière fois on a vu [la classe GeneticAlgorithm](http://lkdjiin.github.io/blog/2013/12/19/les-algorithmes-genetiques-demystifies-46-economie-la-boucle-principale/), qui faisait usage
d'une classe IndividualFormatter. Cette classe est le sujet de l'article
d'aujourd'hui.

<!-- more -->

Cette classe, `IndividualFormatter`, est responsable de la transformation
d'un individu de la population en une chaîne de caractères qui véhicule
des informations *affichables* sur cet individu:

``` ruby
class IndividualFormatter

  def self.display(individual:, generation:, items:, capacity:)
    profit, cost = Score.profit_and_cost individual, items
    if cost > capacity
      "<invalid> Gen: #{generation} Profit: #{profit} Cost: #{cost}"
    else
      "VALID     Gen: #{generation} Profit: #{profit} Cost: #{cost}"
    end
  end

  def self.display_best_ever(individual:, items:)
    profit, cost = Score.profit_and_cost individual, items
    "----------------------\n"\
    "Best ever\n"\
    "----------------------\n"\
    "Profit: #{profit}\n"\
    "Cost:   #{cost}\n"\
    "Listing:\n"\
    "#{Individual.listing(chromosome: individual.chromosome, items: items)}"
  end
end
```

La méthode `display` est utilisée à chaque génération, pour afficher succintement
le meilleur individu trouvé jusqu'ici.

La méthode `display_best_ever` est elle, utilisée à la fin de l'algorithme,
pour afficher la meilleure solution avec plus de détails.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
