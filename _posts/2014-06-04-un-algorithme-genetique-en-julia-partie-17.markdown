---
layout: post
title: "Un algorithme génétique en Julia - partie 17"
date: 2014-06-04 21:59
legacy: true
tags: [intermédiaire, julia, algorithme génétique]
---



Aujourd'hui j'ai envie de faire une version récursive de la fonction
`run`. Voici la version actuelle:

{% highlight julia %}
function run(population_size, genes_size, generations, fight_rate)
  current = create_population(population_size, genes_size)
  for i in 1:generations
    scores = score(current)
    best = maximum(scores)
    println("Generation $i Best $best")
    selection = tournament(scores, fight_rate)
    current = reproduction([], current, selection, population_size)
  end
end
{% endhighlight %}

<!-- more -->

Et en voici une version récursive (avec un *helper*):

{% highlight julia %}
function run(population_size, genes_size, generations, fight_rate)
  current = create_population(population_size, genes_size)
  run_helper(current, population_size, fight_rate, generations)
end

function run_helper(current, population_size, fight_rate, generations,
                    generation = 1)
  scores = score(current)
  best = maximum(scores)
  println("Generation $generation Best $best")
  if generation < generations
    selection = tournament(scores, fight_rate)
    current = reproduction([], current, selection, population_size)
    run_helper(current, population_size, fight_rate, generations, generation + 1)
  end
end
{% endhighlight %}

Alors je me doute que je suis sûrement assez maladroit avec Julia, que
j'apprend, et avec le style récursif, qui ne coule pas de source chez moi,
mais j'ai quand même l'impression que ça n'apporte rien du tout au
programme !

Pour l'instant, je pense que je vais me limiter souvent à des boucles
`for` ;)



À demain.


