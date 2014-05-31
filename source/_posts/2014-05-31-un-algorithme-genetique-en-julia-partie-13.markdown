---
layout: post
title: "Un algorithme génétique en Julia - partie 13"
date: 2014-05-31 21:18
comments: true
categories: [intermédiaire, julia, algorithme génétique]
---

{% level 2 %}

On peut améliorer la fonction `fight`, pour qu'elle ne choisisse pas toujours
le meilleur individu. Il serait bon que, dans une faible proportion, elle
choisisse parfois le plus faible des deux combattants ; ceci pour assurer
qu'on ne perde pas de matériel génétique.

<!-- more -->

Voici donc la nouvelle fonction `fight`:

``` julia
function fight(scores, index1, index2)
  if rand() < 0.8
    scores[index1] > scores[index2] ? index1 : index2
  else
    scores[index1] > scores[index2] ? index2 : index1
  end
end
```

Dans 80% des cas, elle selectionne le meilleur individu, et dans 20% des
cas, elle selectionne le plus faible.

Je pense qu'on a maintenant tous les éléments nécessaire à la finalisation
de l'algorithme.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
