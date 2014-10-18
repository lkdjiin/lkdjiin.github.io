---
layout: post
title: "Le jeu de la vie en javascript - partie 3"
date: 2014-10-18 12:29
comments: true
categories: [jeu de la vie, javascript]
---

{% level 2 %}

C'est le moment de mettre ensemble tous les éléments codés jusqu'ici pour
contempler le jeu de la vie s'épanouir devant nos yeux.
Seulement je n'ai pas d'idée claire sur la manière dont ça peut-être fait
en javascript, et même sur les problèmes que ça pourrait poser, et encore
moins sur la manière de tester ça avec Jasmine.

Le TDD n'est pas une religion ! Ce n'est pas un précepte qu'on suit
aveuglement. On peut, et on doit, le questionner. Comment écrire un test quand
on n'a pas la moindre idée du problème à résoudre ?

<!-- more -->

Quand cette situation m'arrive, j'expérimente. Et voilà le résultat de mon
expérimentation:

``` javascript app/application.js
...

function draw(context2d, generation, totalGeneration) {
  var height = generation.length;
  var width = generation[0].length;

  clearBackground(context2d, width, height);
  drawCells(context2d, generation, width, height);

  if(totalGeneration > 0)
    setTimeout(update, 500, context2d, generation, totalGeneration);
}

...

function update(context2d, generation, totalGeneration) {
  var height = generation.length,
      width = generation[0].length;

  // Create an empty generation.
  var nextGeneration = new Array(height);
  for(var y = 0; y < height; y++) {
    nextGeneration[y] = new Array(width);
  }

  // Fill the next generation.
  for(var y = 0; y < height; y++) {
    for(var x = 0; x < width; x++) {
      var neighborhood = extractNeighborhood(generation, x, y);
      var state = nextCellState(neighborhood);
      nextGeneration[y][x] = state;
    }
  }

  setTimeout(draw, 500, context2d, nextGeneration, totalGeneration - 1);
}

(function() {
  var generation = createGeneration(100, 100);
  var c = document.getElementById('canvas');
  var context2d = c.getContext('2d');
  var totalGeneration = 100;

  draw(context2d, generation, totalGeneration);
})()
```

Maintenant que j'ai une meilleure connaissance du problème à résoudre, j'efface
toutes les modifications que je viens de faire et je recommence en TDD.

Enfin c'est ce que je ferais normalement sur un projet réèl. Là, j'ai la flemme.

Un meilleur affichage
---------------------

Je vais simplement faire un zoom 4x. Repérez `scale` dans le code suivant pour
savoir ce que j'ai modifié.

``` javascript app/application.js
function draw(context2d, generation, totalGeneration) {
  var height = generation.length;
  var width = generation[0].length;
  var scale = 4;

  clearBackground(context2d, width, height, scale);
  drawCells(context2d, generation, width, height, scale);

  if(totalGeneration > 0)
    setTimeout(update, 500, context2d, generation, totalGeneration);
}

function clearBackground(context2d, width, height, scale) {
  context2d.fillStyle = 'black';
  context2d.fillRect(0, 0, width * scale, height * scale);
}

function drawCells(context2d, generation, width, height, scale) {
  context2d.fillStyle = 'white';
  for(var y = 0; y < height; y++) {
    for(var x = 0; x < width; x++) {
      if(generation[x][y] === 1) {
        context2d.fillRect(x * scale, y * scale, scale, scale);
      }
    }
  }
}
```

Une surface de jeu «sans bord»
------------------------------

Autre amélioration, mais non des moindres, on va connecter les bords du
haut et du bas, ainsi que les bords de gauche et de droite. On aura ainsi un
[tore](http://fr.wikipedia.org/wiki/Tore).

Cette nouvelle fonctionnalité simule assez bien ce qu'il se passe dans le
boulot du monde réèl. Je pourrais modifier le code, le regarder fonctionner,
puis modifier les tests en conséquence. Je vois ça souvent. Seulement cette
façon de faire revient à écrire les tests **après** le code. Et ça, ça n'est
pas du TDD. Je vais d'abord modifier les test, quitte à en désactiver certains
temporairement, **puis** modifier le code pour faire passer les nouveaux tests.

C'est la fonction `extractNeighborhood` qui doit être modifée. Je vais donc
réécrire les *expect*s de:


    describe("returns the neighborhood of a border's cell", function() {

et de

    describe("returns the neighborhood of a corner's cell", function() {

Cela fait 8 tests à réécrire. Je les ai tous désactivés, sauf le premier.

``` javascript
  describe("returns the neighborhood of a border's cell", function() {
    it("x=2, y=0", function() {
      var x = 2,
          y = 0,
          result = extractNeighborhood(this.generation, x, y);
      expect(result).toEqual([1, 1, 0, 1, 0, 1, 0, 1, 0]);
    });

    xit("x=2, y=2", function() {
      var x = 2,
          y = 2,
          result = extractNeighborhood(this.generation, x, y);
      expect(result).toEqual([0, 1, 0, 1, 1, 0, 1, 0, 1]);
    });

    xit("x=0, y=1", function() {
      var x = 0,
          y = 1,
          result = extractNeighborhood(this.generation, x, y);
      expect(result).toEqual([1, 0, 1, 0, 1, 0, 0, 0, 1]);
    });

    xit("x=3, y=1", function() {
      var x = 3,
          y = 1,
          result = extractNeighborhood(this.generation, x, y);
      expect(result).toEqual([0, 1, 0, 1, 0, 1, 1, 0, 0]);
    });
  });

  xdescribe("returns the neighborhood of a corner's cell", function() {
    it("x=0, y=0", function() {
      var x = 0,
          y = 0,
          result = extractNeighborhood(this.generation, x, y);
      expect(result).toEqual([0, 0, 1, 1, 0, 1, 0, 1, 0]);
    });

    it("x=3, y=0", function() {
      var x = 3,
          y = 0,
          result = extractNeighborhood(this.generation, x, y);
      expect(result).toEqual([1, 0, 0, 0, 1, 0, 1, 0, 1]);
    });

    it("x=0, y=2", function() {
      var x = 0,
          y = 2,
          result = extractNeighborhood(this.generation, x, y);
      expect(result).toEqual([0, 1, 0, 0, 0, 1, 1, 0, 1]);
    });

    it("x=3, y=2", function() {
      var x = 3,
          y = 2,
          result = extractNeighborhood(this.generation, x, y);
      expect(result).toEqual([1, 0, 1, 1, 0, 0, 0, 1, 0]);
    });
  });
```

Je vais donc les refaire passer un par un. Pour mémoire, voici l'ancien code:

``` javascript app/application.js
function extractNeighborhood(generation, x, y) {
  var cells = extractLine(generation[y-1], x).concat(
              extractLine(generation[y], x),
              extractLine(generation[y+1], x));
  return cells.map(function(cell) {
    return cell === undefined ? 0 : cell;
  });
}

function extractLine(line, x) {
  if(line === void 0)
    return [0, 0, 0];
  else
    return [line[x-1], line[x], line[x+1]];
}
```

Et voici le code réécrit pour faire passer ce premier test:

``` javascript app/application.js
function extractNeighborhood(generation, x, y) {
  var cells,
      line1,
      line2,
      line3;

  if(y > 0)
    line1 = extractLine(generation[y-1], x);
  else
    line1 = extractLine(generation[generation.length-1], x);

  line2 = extractLine(generation[y], x);
  line3 = extractLine(generation[y+1], x);

  cells = line1.concat(line2, line3);

  return cells.map(function(cell) {
    return cell === undefined ? 0 : cell;
  });
}

function extractLine(line, x) {
  return [line[x-1], line[x], line[x+1]];
}
```

Je réactive le second test, lance la suite de test pour confirmer qu'il
échoue, et voici le nouveau code:

``` javascript app/application.js
function extractNeighborhood(generation, x, y) {

  ...

  if(y > 0)
    line1 = extractLine(generation[y-1], x);
  else
    line1 = extractLine(generation[generation.length-1], x);

  line2 = extractLine(generation[y], x);

  if(y === generation.length - 1)
    line3 = extractLine(generation[0], x);
  else
    line3 = extractLine(generation[y+1], x);

  ...
}
```

Au tour du 3ème test. Pour le faire passer c'est `extractLine` que je dois
modifier.

``` javascript app/application.js
function extractLine(line, x) {
  if(x === 0)
    return [line[line.length-1], line[x], line[x+1]];
  else
    return [line[x-1], line[x], line[x+1]];
}
```

Et enfin je réactive le 4ème test.


``` javascript app/application.js
function extractLine(line, x) {
  if(x === 0)
    return [line[line.length-1], line[x], line[x+1]];
  else if(x === line.length-1)
    return [line[x-1], line[x], line[0]];
  else
    return [line[x-1], line[x], line[x+1]];
}
```

Puis je réactive les 4 tests restants (ceux des coins) et je vérifie que tout
passe. C'est un bon moment pour lancer le programme et vérifier visuellement
que des objets *traversent* bien les bords.

J'ai ensuite fait un peu de refactoring:


``` javascript app/application.js
function extractNeighborhood(generation, x, y) {
  var cells = line1(generation, x, y)
              .concat(line2(generation, x, y), line3(generation, x, y));

  return cells.map(function(cell) {
    return cell === undefined ? 0 : cell;
  });
}

function line1(generation, x, y) {
  if(y > 0)
    return extractLine(generation[y-1], x);
  else
    return extractLine(generation[generation.length - 1], x);
}

function line2(generation, x, y) {
  return extractLine(generation[y], x);
}

function line3(generation, x, y) {
  if(y === generation.length - 1)
    return extractLine(generation[0], x);
  else
    return extractLine(generation[y+1], x);
}

function extractLine(line, x) {
  var left = x - 1,
      right = x + 1;

  if(x === 0)
    left = line.length - 1;
  else if(x === line.length-1)
    right = 0;

  return [line[left], line[x], line[right]];
}
```

J'avoue que je ne sais pas si c'est mieux. Quoiqu'il en soit, vous pouvez
trouver le [code complet sur Github](https://github.com/lkdjiin/game-of-life-javascript).

La prochaine fois je m'attaquerais à la version Ruby/Opal.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

{% connexe %}
