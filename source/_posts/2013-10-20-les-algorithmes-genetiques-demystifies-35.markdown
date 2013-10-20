---
layout: post
title: "Les algorithmes génétiques démystifiés 35"
date: 2013-10-20 21:21
comments: true
categories: [imagerie, algorithme génétique, intermédiaire, javascript]
---

{% level 2 %}

On continue aujourd'hui avec la mise en place de l'algorithme de *Hill-climbing*
pour s'assurer que la fonction d'évaluation de nos images est pertinente.

<!-- more -->

J'ai déjà parlé du *Hill-climbing* dans
[cet article](http://lkdjiin.github.io/blog/2013/09/17/les-algorithmes-genetiques-demystifies-16-le-hill-climbing/).
On peut le considérer comme une version très basique d'un algorithme
génétique, sans population et sans reproduction. Utile donc, pour
tester rapidement et facilement l'évaluation:

``` javascript
var solution = makeIndividual();
var generation = 0;
var htmlGeneration = document.getElementById("generation");
var htmlQuality = document.getElementById("quality");
var interval = setInterval(hillClimb, 150);


function hillClimb() {
  var opponent = mutate(copy(solution));
  var score_opponent = quality(opponent);
  var score_solution = quality(solution);
  if (score_opponent > score_solution) {
    solution = opponent;
  }
  generation++;
  if (generation % 100 == 0) renderIndividual(solution, ctx);
  htmlGeneration.innerHTML = generation;
  htmlQuality.innerHTML = score_solution;
  if (generation >= 100000) {
    clearInterval(interval);
  }
}
```

Les explications maintenant. À chaque tour on compare les scores obtenus
par la solution courante (la meilleure jusqu'ici) avec une version mutée
de lui-même (`opponent`). Si l'opposant est meilleur, il prend la place
de la solution:

    var opponent = mutate(copy(solution));
    var score_opponent = quality(opponent);
    var score_solution = quality(solution);
    if (score_opponent > score_solution) {
      solution = opponent;
    }

J'affiche ensuite la solution courante, toutes les 100 générations:

    generation++;
    if (generation % 100 == 0) renderIndividual(solution, ctx);

À chaque tour, j'affiche la génération courante et son score:

    htmlGeneration.innerHTML = generation;
    htmlQuality.innerHTML = score_solution;

Enfin, on stoppe tout au bout de 100.000 essais:

    if (generation >= 100000) {
      clearInterval(interval);
    }

La fonction de mutation est longue, mais simple. On sélectionne au hasard
un carré et une de ses propriétés puis on la modifie:

``` javascript
function mutate(individual) {
  var gene = Math.floor(Math.random() * TOTAL_SQUARES),
      squareProperty = Math.floor(Math.random() * 7);
  switch (squareProperty) {
    case 0:
      individual[gene].x = Math.floor(Math.random() * IMAGE_WIDTH);
      break;
    case 1:
      individual[gene].y = Math.floor(Math.random() * IMAGE_HEIGHT);
      break;
    case 2:
      individual[gene].size = Math.floor(Math.random() * SQUARE_MAX_SIZE);
      break;
    case 3:
      individual[gene].red = Math.floor(Math.random() * 256);
      break;
    case 4:
      individual[gene].green = Math.floor(Math.random() * 256);
      break;
    case 5:
      individual[gene].blue = Math.floor(Math.random() * 256);
      break;
    case 6:
      individual[gene].alpha = Math.random();
      break;
  }
  return individual;
}
```

La prochaine fois on verra deux dernières fonctions *techniques*:
`copy` et `renderIndividual` et on sera près à faire tourner
notre algorithme.

À demain.

{% connexe %}

