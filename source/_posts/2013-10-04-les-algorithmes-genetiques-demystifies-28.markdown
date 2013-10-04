---
layout: post
title: "Les algorithmes génétiques démystifiés 28"
date: 2013-10-04 18:43
comments: true
categories: [problème des 8 dames, extremum local, algorithme génétique, ruby, intermédiaire]
---

{% level 2 %}

Dans le [dernier article](http://lkdjiin.github.io/blog/2013/10/02/les-algorithmes-genetiques-demystifies-27/) on a vu quelle forme concrete prenait un extremum
local dans nos algorithmes génétiques: les chromosomes tendent à devenir
identiques. On doit maintenant comprendre pourquoi on bloque sur un
extremum local dans ce problème particulier des 8 dames, alors qu'on avait
bien supprimé ce souci dans le [paradoxe du singe savant](http://lkdjiin.github.io/blog/2013/09/08/les-algorithmes-genetiques-demystifies-8-le-paradoxe-du-singe-savant/).

<!-- more -->

On reprend [le code](http://lkdjiin.github.io/blog/2013/09/18/les-algorithmes-genetiques-demystifies-17-oriente-objet/) pour le paradoxe du singe savant et on modifie
la méthode `run` de la classe `GeneticAlgorithm` pour inspecter l'état des
chromosomes une fois la solution trouvée:

``` ruby
  def run
    @generations.times do |generation|
      Evaluator.new(@search_value, @population).evaluate
      best = @population.best
      # display(generation, best)
      # exit if best.score == @search_value.size
      if best.score == @search_value.size
        @population.each {|i| p i.chromosome}
        exit
      end
      next_generation
    end
  end
```

En se servant du [petit script d'analyse](http://lkdjiin.github.io/blog/2013/10/02/les-algorithmes-genetiques-demystifies-27/) du dernier article, vous vous
apercevrez que pratiquement chaque chromosome est unique. Pourquoi cela
fonctionne ici et pas là ?

Lorsque, dans le paradoxe du singe savant, on mute une phrase, chaque
mutation a une chance réelle d'améliorer la phrase. Bien sûr, pour améliorer
la phrase, il faut que toutes les conditions soit réunies. Il faut
premièrement, que le gène qui mute soit un «mauvais» gène et deuxièmement,
que le remplaçant soit un «bon» gène. Par contre, quelque soit le gène
mutant, les autres gènes n'entrent pas en ligne de compte. Dans la phrase,
chaque gène est totalement indépendant des autres. Voici un exemple pour
clarifier mon propos. On cherche la phrase "bonjour" et on a pour l'instant
ceci:

    xxxxxxx

Cette phrase n'a que des mauvais gènes, son score est de zéro. Si on mute
le premier gène en "b":

    bxxxxxx

La phrase s'est améliorée, son score a augmenté. Vous remarquez que quelque soit
les autres gènes, bons ou mauvais, le score augmente de toutes manières de 1.
C'est ce que j'appelle des *gènes indépendants*.

Dans le problème des 8 dames, c'est très différent. Il me manque malheureusement
les outils mathématiques et/ou statistiques pour conceptualiser tout ça mais
je vais néanmoins essayer d'expliquer. Lorsqu'on déplace une dame sur le
plateau, c'est à dire quand un gène mute, son déplacement à un effet
potentiel sur les autres dames, elle peut entrer en conflit avec une ou
plusieurs. Donc dans le problème des 8 dames les gènes sont dépendants les
uns des autres. On ne peut pas en muter un sans affecter *potentiellement*
les autres. Ça signifie qu'il doit y avoir certains chromosomes pour lequels
la mutation d'un seul gène, quel qu'il soit (ou même de plusieurs en
augmentant la taille de l'échiquier), ne peut pas améliorer ce chromosome.
Comme le taux de mutation doit être petit pour permettre
[l'exploitation](http://lkdjiin.github.io/blog/2013/10/01/les-algorithmes-genetiques-demystifies-exploration-vs-exploitation/) des chromosomes, la probabilité qu'un chromosome voit
suffisament de ses gènes mutés comme il faut est infime, quasi-inexistante.

J'espère avoir été suffisament clair, n'hésitez pas à me demander des précisions
le cas échéant, je ferais de mon mieux pour y répondre. Je vous proposerais
une solution dans le prochain article.

À demain.

{% connexe %}

