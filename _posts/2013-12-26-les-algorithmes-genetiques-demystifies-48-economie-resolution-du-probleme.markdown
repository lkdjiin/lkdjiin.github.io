---
layout: post
title: "Les algorithmes génétiques démystifiés 48: Économie - Résolution du problème"
date: 2013-12-26 20:41
legacy: true
tags: [algorithme génétique, ruby]
---



On termine le problème d'investissement, qui je le rappelle est basiquement
un problème de sac à dos avec des objets multiples.

<!-- more -->

Le code complet sur trouve sur Github: [invest.rb](https://github.com/lkdjiin/knapsack_genetic_algorithm/blob/master/invest.rb).

Il restait à voir la classe `Mutator`:

{% highlight ruby %}
class Mutator
  def initialize(mutation_rate:, items:)
    @rate = mutation_rate
    @items = items
  end

  def mutate(chromosome)
    chromosome.map.with_index do |gene, index|
      if rand < @rate
        rand(0..@items[index].number)
      else
        gene
      end
    end
  end
end
{% endhighlight %}

La formule pour muter un gène est basique, on crée aléatoirement un
nombre compris entre 0 et le nombre d'actions maximum pour cette 
action particulière:

{% highlight ruby %}
      if rand < @rate
        rand(0..@items[index].number)
{% endhighlight %}

Il reste à initialiser l'algorithme et à le lancer:

{% highlight ruby %}
population = Population.new(Knapsack::ITEMS, 1000)
puts "Initialized!"
GeneticAlgorithm.new(
  generations: 1_000,
  population: population,
  capacity: 15_000,
  mutation_rate: 1.0 / 1000,
  items: Knapsack::ITEMS).run
{% endhighlight %}

On dispose de 1 000 individus dans la population. On s'arrête
à la 1 000ème génération. Notre capacité d'investissement est
de 15 000 €. Et le taux de mutation est fixé classiquement
comme étant l'inverse du nombre d'individus.

Et c'est parti:

{% highlight bash %}
[~]⇒ ruby invest.rb 
Initialized!
<invalid> Gen: 0 Profit: 4202 Cost: 35599
<invalid> Gen: 1 Profit: 3567 Cost: 34133
.
.
.
VALID     Gen: 999 Profit: 3430 Cost: 14067
----------------------
Best ever
----------------------
Profit: 3430
Cost:   14067
Listing:
49 ACCOR
0 AIR_LIQUIDE
5 ALSTOM
42 ARCELORMITTAL_REG
1 AXA
3 BNP_PARIBAS
37 BOUYGUES
0 CAP_GEMINI
7 CARREFOUR
94 CREDIT_AGRICOLE_SA
0 DANONE
7 EADS
70 EDF
1 ESSILOR_INTERNATIONAL
6 GDF_SUEZ
2 GEMALTO
1 KERING
2 L'OREAL
0 LAFARGE
0 LEGRAND_SA
1 LVMH_MOET_VUITTON
2 MICHELIN
1 ORANGE
1 PERNOD_RICARD
1 PUBLICIS_GROUPE
0 RENAULT
1 SAFRAN
21 SAINT_GOBAIN
0 SANOFI
1 SCHNEIDER_ELECTRIC
7 SOCIETE_GENERALE
0 SOLVAY
73 STMICROELECTRONICS
1 TECHNIP
90 TOTAL
1 UNIBAIL-RODAMCO
8 VALLOUREC
0 VEOLIA_ENVIRONNEMENT
1 VINCI
36 VIVENDI
{% endhighlight %}

Si vous pensez à quelques améliorations, et il y en a,
n'hésitez pas à les tester et/ou à m'en faire part dans un
commentaire.

La prochaine fois, on s'attaquera sûrement à un problème de
sac à dos multiple. C'est à dire plusieurs objets de chaque
sortes et plusieurs sacs à dos.



À demain.


