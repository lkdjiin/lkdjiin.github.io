---
layout: post
title: "Un algorithme génétique en Julia - partie 13"
date: 2014-05-31 21:18
legacy: true
tags: [intermédiaire, julia, algorithme génétique]
---



On peut améliorer la fonction `fight`, pour qu'elle ne choisisse pas toujours
le meilleur individu. Il serait bon que, dans une faible proportion, elle
choisisse parfois le plus faible des deux combattants ; ceci pour assurer
qu'on ne perde pas de matériel génétique.

<!-- more -->

Voici donc la nouvelle fonction `fight`:

{% highlight julia %}
function fight(scores, index1, index2)
  if rand() < 0.8
    scores[index1] > scores[index2] ? index1 : index2
  else
    scores[index1] > scores[index2] ? index2 : index1
  end
end
{% endhighlight %}

Dans 80% des cas, elle selectionne le meilleur individu, et dans 20% des
cas, elle selectionne le plus faible.

Je pense qu'on a maintenant tous les éléments nécessaire à la finalisation
de l'algorithme.



À demain.


