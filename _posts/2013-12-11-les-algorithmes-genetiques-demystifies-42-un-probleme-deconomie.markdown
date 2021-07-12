---
layout: post
title: "Les algorithmes génétiques démystifiés 42: Un problème d'économie"
date: 2013-12-11 20:56
legacy: true
tags: [algorithme génétique, intermédiaire, ruby, problème du sac à dos, économie, investissement]
---



Jusqu'ici les problèmes abordés dans cette série d'articles ont été très
*théoriques*.  Le dernier algorithme génétique qu'on a exploré a permis de
résoudre
[le problème du sac à dos](http://lkdjiin.github.io/blog/2013/11/12/les-algorithmes-genetiques-demystifies-37-le-probleme-du-sac-a-dos/). Ce problème du sac à dos est une bonne base
*théorique* pour aborder certains problèmes plus *concrets*. On va justement
se rapprocher un peu du monde réel en tentant de résoudre un problème
d'économie: optimiser un investissement.

<!-- more -->

Voici l'énoncé du problème: Vous êtes un investisseur et vous disposez
d'une somme de 15 000 € pour acheter des actions du CAC 40.
Vous connaissez le coût
d'une action (son prix), vous savez combien elle rapportera dans, disons un
an, et vous connaissez le nombre d'actions disponibles (combien vous pouvez
en acheter). L'objectif est de savoir combien d'actions acheter pour chaque
entreprise du CAC 40, histoire de faire un maximum de profit.

Alors si on se rapproche du monde réel, on est encore dans un monde
fantastique, puisque pour savoir combien rapportera
une action, soit vous avez un super-pouvoir, soit vous connaissez un
ami médium. Quoiqu'il en soit, il me semble que c'est un problème intéressant,
donc c'est parti.

Ce problème est très proche du problème du sac à dos, je vais donc me baser
sur le code développé dans les derniers articles, et qui est
[disponible sur Github](https://github.com/lkdjiin/knapsack_genetic_algorithm/blob/master/knapsack3.rb).

Dans le problème du sac à dos, on devait choisir des objets ; ici les actions
remplacent les objets. Les objets avaient un poid ; ici les actions ont un
coût. Les objets avaient une valeur ; ici aussi les actions ont une
valeur, qu'on nommera «profit». La différence, c'est qu'ici on va pouvoir
choisir plusieurs actions de même type.

Voici comment on peut représenter une action:

{% highlight ruby %}
KnapsackItem = Struct.new(:name, :cost, :profit, :number)
{% endhighlight %}

On a le nom de l'action (`name`), son coût en euros (`cost`), le profit
attendu en euros (`profit`) et le nombre d'actions disponibles (`number`).

Pour le stock d'actions dans lequel on va puiser, j'ai été voir le CAC 40,
j'ai pris la valeur réelle des actions (arrondi à l'entier) et j'ai
généré aléatoirement les champs profit et number:

{% highlight ruby %}
module Knapsack
  ITEMS = [
    KnapsackItem.new('ACCOR', 32, 9, 60),
    KnapsackItem.new('AIR_LIQUIDE', 97, 7, 32),
    KnapsackItem.new('ALSTOM', 25, 5, 6),
    KnapsackItem.new('ARCELORMITTAL_REG', 12, 9, 43),
    KnapsackItem.new('AXA', 18, 2, 65),
    KnapsackItem.new('BNP_PARIBAS', 53, 3, 24),
    KnapsackItem.new('BOUYGUES', 25, 9, 38),
    KnapsackItem.new('CAP_GEMINI', 46, 1, 47),
    KnapsackItem.new('CARREFOUR', 27, 3, 37),
    KnapsackItem.new('CREDIT_AGRICOLE_SA', 8, 4, 99),
    KnapsackItem.new('DANONE', 51, 1, 43),
    KnapsackItem.new('EADS', 49, 6, 63),
    KnapsackItem.new('EDF', 26, 5, 87),
    KnapsackItem.new('ESSILOR_INTERNATIONAL', 73, 6, 49),
    KnapsackItem.new('GDF_SUEZ', 16, 1, 42),
    KnapsackItem.new('GEMALTO', 76, 2, 53),
    KnapsackItem.new('KERING', 150, 5, 97),
    KnapsackItem.new("L'OREAL", 126, 7, 100),
    KnapsackItem.new('LAFARGE', 49, 3, 93),
    KnapsackItem.new('LEGRAND_SA', 39, 2, 49),
    KnapsackItem.new('LVMH_MOET_VUITTON', 129, 9, 8),
    KnapsackItem.new('MICHELIN', 75, 4, 43),
    KnapsackItem.new('ORANGE', 8, 7, 1),
    KnapsackItem.new('PERNOD_RICARD', 80, 4, 53),
    KnapsackItem.new('PUBLICIS_GROUPE', 63, 11, 49),
    KnapsackItem.new('RENAULT', 58, 4, 32),
    KnapsackItem.new('SAFRAN', 47, 2, 61),
    KnapsackItem.new('SAINT_GOBAIN', 36, 7, 33),
    KnapsackItem.new('SANOFI', 73, 9, 70),
    KnapsackItem.new('SCHNEIDER_ELECTRIC', 58, 6, 21),
    KnapsackItem.new('SOCIETE_GENERALE', 40, 3, 93),
    KnapsackItem.new('SOLVAY', 108, 5, 33),
    KnapsackItem.new('STMICROELECTRONICS', 5, 1, 75),
    KnapsackItem.new('TECHNIP', 72, 3, 47),
    KnapsackItem.new('TOTAL', 42, 10, 95),
    KnapsackItem.new('UNIBAIL-RODAMCO', 184, 9, 82),
    KnapsackItem.new('VALLOUREC', 39, 4, 51),
    KnapsackItem.new('VEOLIA_ENVIRONNEMENT', 11, 10, 2),
    KnapsackItem.new('VINCI', 45, 6, 53),
    KnapsackItem.new('VIVENDI', 17, 5, 38)
  ]
end
{% endhighlight %}

La prochaine fois on s'occupera de générer la population initiale.





À demain.



