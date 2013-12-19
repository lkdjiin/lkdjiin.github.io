---
layout: post
title: "Les algorithmes génétiques démystifiés: Imagerie"
date: 2013-10-16 16:31
comments: true
categories: [imagerie, algorithme génétique, intermédiaire, javascript]
---

{% level 2 %}

Bonjour, aujourd'hui on commence une nouvelle étude sur les algorithmes
génétiques avec un problème sympa : recréer une photo à partir de plusieurs
carrés de tailles et de couleurs différentes. Au début, l'image est
générée au hasard:

{% img /images/Capture-13.jpg %}

Puis, petit à petit, elle converge vers la photo d'origine:

{% img /images/Capture-11.jpg %}

<!-- more -->

Avant tout, il faut réfléchir à deux choses: la représentation des individus
et l'évaluation. De plus, comme je l'ai déjà mentionné, Javascript n'est pas
mon fort. Alors plutôt que d'écrire tout de suite un algorithme génétique, je
vais d'abord essayer de mettre en place un algorithme de *Hill Climbing*.

Les individus
---------------
Chaque *solution/individu* sera composé de quelques centaines de petits carrés.
Chaque carré pourra être personnalisé grâce à:

- sa position x
- sa position y
- sa taille
- sa couleur (rouge, vert et bleu)
- sa transparence

Voici comment je traduis ça en Javascript:

``` javascript
function makeIndividual() {
  var individual = [];
  for (var i = 0; i < TOTAL_SQUARES; i++) {
    individual.push({
      x: Math.floor(Math.random() * IMAGE_WIDTH),
      y: Math.floor(Math.random() * IMAGE_HEIGHT),
      size: Math.floor(Math.random() * IMAGE_WIDTH),
      red: Math.floor(Math.random() * 256),
      green: Math.floor(Math.random() * 256),
      blue: Math.floor(Math.random() * 256),
      alpha: Math.random()
    });
  }
  return individual;
}
```

Techniquement, un individu est donc une liste de gènes, et un gène est un
objet avec les propriétés x, y, size, red, green, blue et alpha.

La prochaine fois on verra comment on peut évaluer nos images.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

