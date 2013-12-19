---
layout: post
title: "Les algorithmes génétiques démystifiés 34"
date: 2013-10-18 20:44
comments: true
categories: [imagerie, algorithme génétique, intermédiaire, javascript]
---

{% level 2 %}

Après avoir vu comment créer un individu qui représente une image,
on regarde aujourd'hui comment évaluer une image.

<!-- more -->

N'étant pas familier du traitement d'image et de tout ce qui s'y rapporte,
j'avoue avoir eu un petit instant de panique quand je me suis demandé:
«Comment savoir, entre deux images, laquelle est *la plus proche* d'une image
de référence ?».

Et puis j'ai respiré un bon coup: après tout une image n'est rien d'autre
qu'une liste de données, on a qu'à faire au plus simple, c'est à dire
comparer chaque pixel. Y'avait vraiment pas de quoi paniquer ! Voilà donc
la fonction `quality` qui mesure la similitude entre une image d'origine
et une image candidate:

``` javascript
function quality(individual) {
  var imgOrigin = ctxOrigin.getImageData(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
  var pixelArrayOrigin = imgOrigin.data;
  var score = 0;
  renderIndividual(individual, ctxBuffer);
  var imgBuffer = ctxBuffer.getImageData(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
  var pixelArrayCandidate = imgBuffer.data;
  for (var i = 0, n = pixelArrayOrigin.length; i < n; i += 4) {
    score += Math.abs(pixelArrayOrigin[i] - pixelArrayCandidate[i]);
    score += Math.abs(pixelArrayOrigin[i+1] - pixelArrayCandidate[i+1]);
    score += Math.abs(pixelArrayOrigin[i+2] - pixelArrayCandidate[i+2]);
  }
  return 1 / score;
}
```

C'est parti pour quelques explications. On récupère les pixels de
l'image d'origine (qui se trouve dans un canvas) dans la variable
`pixelArrayOrigin`:

    var imgOrigin = ctxOrigin.getImageData(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
    var pixelArrayOrigin = imgOrigin.data;

Ensuite, on construit l'image candidate dans un canvas non-affiché. La
fonction `renderIndividual` sera détaillée plus tard:

    renderIndividual(individual, ctxBuffer);

On récupère les pixels de cette image candidate dans `pixelArrayCandidate`:

    var imgBuffer = ctxBuffer.getImageData(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
    var pixelArrayCandidate = imgBuffer.data;

Maintenant on vérifie les pixels un à un. Un pixel est représenté par quatre
nombres, respectivement rouge, vert, bleu et alpha. Le score augmente de la
différence entre les composantes rouges, vertes et bleues:

    for (var i = 0, n = pixelArrayOrigin.length; i < n; i += 4) {
      score += Math.abs(pixelArrayOrigin[i] - pixelArrayCandidate[i]);
      score += Math.abs(pixelArrayOrigin[i+1] - pixelArrayCandidate[i+1]);
      score += Math.abs(pixelArrayOrigin[i+2] - pixelArrayCandidate[i+2]);
    }

Finalement on retourne l'inverse pour avoir un score compris entre
0 et 1:

    return 1 / score;

La prochaine fois, on met l'algorithme de *Hill-Climbing* en place.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

