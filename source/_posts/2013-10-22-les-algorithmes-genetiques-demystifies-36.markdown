---
layout: post
title: "Les algorithmes génétiques démystifiés 36"
date: 2013-10-22 08:25
comments: true
categories: [imagerie, algorithme génétique, intermédiaire, javascript]
---

{% level 2 %}

Il reste à voir deux fonctions *techniques* pour faire tourner notre
programme: la copie d'un individu et le rendu d'une image. Je les appelle
*techniques* car elles n'ont rien à voir avec l'algorithme lui-même. La
copie d'un individu est rendue nécessaire par le langage utilisé, Javascript,
et le rendu d'une image est nécessaire puisqu'on veut …et bien… afficher
des images, quoi…

<!-- more -->

Voyons d'abord la copie d'un individu:

``` javascript
function copy(individual) {
  var indiCopy = [];
  for(var i = 0; i < TOTAL_SQUARES; i++) {
    var objectCopy = {},
        prop;
    for(prop in individual[i]) {
      objectCopy[prop] = individual[i][prop];
    }
    indiCopy.push(objectCopy);
  }
  return indiCopy;
}
```

Un individu est un tableau, contenant des objets, chaque objets contenants
des propriétés… *Là, je m'interroge et je demande l'avis de spécialistes:
est-ce-qu'il ne vaudrait pas mieux utiliser une librairie pour faire ça,
comme jQuery ou Underscore.js ?*

Maintenant le rendu d'une image:

``` javascript
function renderIndividual(individual, ctx) {
  ctx.fillStyle = "white";
  ctx.fillRect(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
  for (var i = 0; i < TOTAL_SQUARES; i++) {
    ctx.globalAlpha = individual[i].alpha;
    ctx.fillStyle = 'rgb(' + individual[i].red + ',' +
      individual[i].green + ',' + individual[i].blue + ')';
    ctx.fillRect(individual[i].x, individual[i].y,
      individual[i].size, individual[i].size);
  }
}
```

`ctx` est un contexte de Canvas. Je vois ça tout simplement comme un objet
dans lequel on peut dessiner. Tout d'abord on *efface* l'image en la
remplissant de blanc:

    ctx.fillStyle = "white";
    ctx.fillRect(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);

Puis on dessine chacuns des carrés:

    for (var i = 0; i < TOTAL_SQUARES; i++) {

Pour chaque carré il faut sélectionner sa transparence:

    ctx.globalAlpha = individual[i].alpha;

Puis sa couleur:

    ctx.fillStyle = 'rgb(' + individual[i].red + ',' +
      individual[i].green + ',' + individual[i].blue + ')';

On peut alors dessiner un carré:

    ctx.fillRect(individual[i].x, individual[i].y,
      individual[i].size, individual[i].size);

Voilà. Reste à voir maintenant le programme dans son ensemble. Voici les
fichiers HTML et CSS:

``` html
<!DOCTYPE html>
<html lang="fr">
  <head>
    <meta charset="utf-8" />
    <link rel="stylesheet" type="text/css" href="picture.css" /> 
  </head>
  <body>
    <canvas width="400" height="400" id="canvas1"></canvas>
    <canvas width="400" height="400" id="canvas2"></canvas>
    <p id="generation">0</p>
    <p id="quality">0</p>
    <script src="picture.js"></script>
  </body>
</html>
```

``` css
body {
  background-color: #222;
}

p {
  color: #ccc;
}
```

Et voici le programme Javascript complet:

``` javascript
var canvasImgOrigin = document.getElementById('canvas1');
var canvasGenetic = document.getElementById('canvas2');
var ctxOrigin = canvas1.getContext('2d');
var ctx = canvas2.getContext('2d');
var TOTAL_SQUARES = 400;
var IMAGE_WIDTH = 400;
var IMAGE_HEIGHT = 400;
var SQUARE_MAX_SIZE = 40;
var img = new Image();
var generation = 0;
var htmlGeneration = document.getElementById("generation");
var htmlQuality = document.getElementById("quality");
var solution = [];
var canvasBuffer = document.createElement('canvas');
canvasBuffer.width = IMAGE_WIDTH;
canvasBuffer.height = IMAGE_HEIGHT;
var ctxBuffer = canvasBuffer.getContext('2d');

img.onload = function() { ctxOrigin.drawImage(img, 0, 0); };
img.src = 'photo.jpg';
solution = makeIndividual();

var interval = setInterval(hillClimb, 150);

function makeIndividual() {
  var individual = [];
  for (var i = 0; i < TOTAL_SQUARES; i++) {
    individual.push({
      x: Math.floor(Math.random() * IMAGE_WIDTH),
      y: Math.floor(Math.random() * IMAGE_HEIGHT),
      size: Math.floor(Math.random() * SQUARE_MAX_SIZE),
      red: Math.floor(Math.random() * 256),
      green: Math.floor(Math.random() * 256),
      blue: Math.floor(Math.random() * 256),
      alpha: Math.random()
    });
  }
  return individual;
}

function renderIndividual(individual, ctx) {
  ctx.fillStyle = "white";
  ctx.fillRect(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
  for (var i = 0; i < TOTAL_SQUARES; i++) {
    ctx.globalAlpha = individual[i].alpha;
    ctx.fillStyle = 'rgb(' + individual[i].red + ',' +
      individual[i].green + ',' + individual[i].blue + ')';
    ctx.fillRect(individual[i].x, individual[i].y,
      individual[i].size, individual[i].size);
  }
}

function quality(individual) {
  var imgOrigin = ctxOrigin.getImageData(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
  var pixelArrayOrigin = imgOrigin.data;
  var score = 0;
  renderIndividual(individual, ctxBuffer);
  var imgBuffer = ctxBuffer.getImageData(0, 0, 400, 400);
  var pixelArrayCandidate = imgBuffer.data;
  for (var i = 0, n = pixelArrayOrigin.length; i < n; i += 4) {
    score += Math.abs(pixelArrayOrigin[i] - pixelArrayCandidate[i]);
    score += Math.abs(pixelArrayOrigin[i+1] - pixelArrayCandidate[i+1]);
    score += Math.abs(pixelArrayOrigin[i+2] - pixelArrayCandidate[i+2]);
  }
  return 1 / score;
}

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

function copy(individual) {
  var indiCopy = [];
  for(var i = 0; i < TOTAL_SQUARES; i++) {
    var objectCopy = {},
        prop;
    for(prop in individual[i]) {
      objectCopy[prop] = individual[i][prop];
    }
    indiCopy.push(objectCopy);
  }
  return indiCopy;
}

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

Pour le faire tourner vous aurez besoin d'une photo de 400x400 pixels et
de beaucoup de patience… Avec Firefox, ça marche tout seul mais avec
Chrome il faudra passer par un serveur Web. Si Ruby est installé sur
votre machine, vous pouvez démarrer un serveur en entrant ceci dans un
terminal (même répertoire que votre fichier HTML):

    ruby -rwebrick -e'WEBrick::HTTPServer.new(:Port => 3000, :DocumentRoot => Dir.pwd).start'

Le code se trouve aussi sur Github: [github.com/lkdjiin/picture_genetic_algorithm](https://github.com/lkdjiin/picture_genetic_algorithm).
Je suis sûr que certains d'entre-vous connaissent Javascript bien mieux que
moi et peuvent l'améliorer, alors n'hésitez pas.

À demain.

{% connexe %}

