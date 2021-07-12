---
layout: post
title: "Les algorithmes génétiques démystifiés 47: Économie"
date: 2013-12-23 16:13
legacy: true
tags: [algorithme génétique, ruby]
---



La dernière fois on a vu [la classe GeneticAlgorithm](http://lkdjiin.github.io/blog/2013/12/19/les-algorithmes-genetiques-demystifies-46-economie-la-boucle-principale/), qui faisait usage
d'une classe IndividualFormatter. Cette classe est le sujet de l'article
d'aujourd'hui.

<!-- more -->

Cette classe, `IndividualFormatter`, est responsable de la transformation
d'un individu de la population en une chaîne de caractères qui véhicule
des informations *affichables* sur cet individu:

{% highlight ruby %}
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
{% endhighlight %}

La méthode `display` est utilisée à chaque génération, pour afficher succintement
le meilleur individu trouvé jusqu'ici.

La méthode `display_best_ever` est elle, utilisée à la fin de l'algorithme,
pour afficher la meilleure solution avec plus de détails.



À demain.


