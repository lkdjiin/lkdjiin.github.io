---
layout: post
title: "Le jeu de la vie en javascript - partie 1"
date: 2014-10-16 22:27
comments: true
categories: 
categories: [jeu de la vie, javascript]
---

{% level 2 %}

C'est parti pour le jeu de la vie version Javascript. Dans ce premier article
nous allons créer une génération de cellules au hasard et l'afficher.

*J'avais annoncé dans [l'article précédent](blog/2014/10/08/le-jeu-de-la-vie-dans-sept-langages-differents/) que je commencerais par la
version Ruby/Opal. Je l'ai écrite mais je n'en suis pas satisfait. Les
performances sont très pauvres et j'ai écrit plus de code que nécessaire.
Je prendrais donc le temps de la nettoyer un peu avant de la publier.*

<!-- more -->

Pour les tests, j'utiliserais [Jasmine](http://jasmine.github.io/) et la structure du projet sera la
suivante:

    $ tree
    .
    ├── app
    │   └── application.js
    ├── index.html
    ├── jasmine
    │   └── lib
    │       └── jasmine-2.0.3
    │           ├── boot.js
    │           ├── console.js
    │           ├── jasmine.css
    │           ├── jasmine_favicon.png
    │           ├── jasmine-html.js
    │           └── jasmine.js
    ├── spec
    │   └── test.js
    └── test.html

Dans le fichier `test.html` on charge les dépendances de Jasmine, puis notre
application (`app/application.js`) et enfin nos tests (`spec/test.js`).

``` html test.html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <title>Test Game of Life</title>
    <link rel="shortcut icon" type="image/png" href="jasmine/lib/jasmine-2.0.3/jasmine_favicon.png">
    <link rel="stylesheet" type="text/css" href="jasmine/lib/jasmine-2.0.3/jasmine.css">

    <script type="text/javascript" src="jasmine/lib/jasmine-2.0.3/jasmine.js"></script>
    <script type="text/javascript" src="jasmine/lib/jasmine-2.0.3/jasmine-html.js"></script>
    <script type="text/javascript" src="jasmine/lib/jasmine-2.0.3/boot.js"></script>
  </head>
  <body>
    <script type="text/javascript" src="app/application.js"></script>
    <script type="text/javascript" src="spec/test.js"></script>
  </body>
</html>
```

Créer une génération de cellules au hasard
------------------------------------------

Nous allons écrire la fonction `createGeneration` qui
devra *fabriquer* un ensemble de cellules, mortes (`0`) ou vivantes (`1`), au
hasard. Mon premier test avec Jasmine est de m'assurer que cette fonction
renvoie un tableau (`Array`).

``` javascript spec/test.js
describe("createGeneration", function() {

  it("returns an array", function() {
    var result = createGeneration();
    expect(Array.isArray(result)).toBe(true);
  });

});
```

Lorsqu'on lance `test.html` Jasmine nous dit que `createGeneration` n'existe
pas. Le code javascript permettant de faire passer ce test consiste donc à
renvoyer un tableau vide.

``` javascript app/application.js
function createGeneration(x, y) {
  return [];
}
```

Maintenant il nous faut un tableau à 2 dimensions:

``` javascript spec/test.js
describe("createGeneration", function() {

  ...

  it("creates a 2D array", function() {
    var result = createGeneration(3, 5);
    expect(result.length).toBe(5);
    expect(result[0].length).toBe(3);
  });

});
```

La fonction suivante est suffisante pour faire passer le test.

``` javascript app/application.js
function createGeneration(x, y) {
  var generation = new Array(y);

  for(var i = 0; i < y; i++) {
    generation[i] = new Array(x);
  }
  return generation;
}
```

Et maintenant on rempli notre tableau 2D avec des `1` ou des `0`. D'abord un
test pour vérifier que chaque cellule du tableau contient `1` ou `0`.

``` javascript spec/test.js
describe("createGeneration", function() {

  ...

  it("fills each room with 1 or 0", function() {
    var generation = createGeneration(2, 3);
    for(var y = 0; y < 3; y++) {
      for(var x = 0; x < 2; x++) {
        var cell = generation[y][x];
        var result = cell === 0 || cell === 1;
        expect(result).toBe(true);
      }
    }
  });

});
```

Puis l'implémentation.

``` javascript app/application.js
function createGeneration(x, y) {
  var generation = new Array(y);

  for(var i = 0; i < y; i++) {
    generation[i] = [];
    for(var j = 0; j < x; j++) {
      generation[i][j] = Math.floor(Math.random() * 2);
    }
  }
  return generation;
}
```

Voilà, cette première partie du jeu de la vie en Javascript était simple et
rapide à coder. Je vais maintenant mettre les tests de coté pour me
concentrer sur l'affichage d'une génération.

Afficher une génération
-----------------------

Voyons pour commencer le contenu du fichier `index.html`.

``` html index.html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <title>Game of Life</title>
  </head>
  <body>
    <canvas width="100" height="100" id="canvas"></canvas>
    <script src="app/application.js"></script>
  </body>
</html>
```

Nous référençons bien entendu notre `application.js` et nous créons un
`canvas` de (petite) dimension 100x100. C'est dans ce `canvas` que nous allons
*dessiner* nos cellules.

Sans plus attendre, voici le contenu de `application.js`.

``` javascript app/application.js
function createGeneration(width, height) {
  var generation = new Array(height);

  for(var y = 0; y < height; y++) {
    generation[y] = [];
    for(var x = 0; x < width; x++) {
      generation[y][x] = Math.floor(Math.random() * 2);
    }
  }
  return generation;
}

function draw(context2d, generation) {
  var height = generation.length;
  var width = generation[0].length;

  clearBackground(context2d, width, height);
  drawCells(context2d, generation, width, height);
}

function clearBackground(context2d, width, height) {
  context2d.fillStyle = 'black';
  context2d.fillRect(0, 0, width, height);
}

function drawCells(context2d, generation, width, height) {
  context2d.fillStyle = 'white';
  for(var y = 0; y < height; y++) {
    for(var x = 0; x < width; x++) {
      if(generation[x][y] === 1) {
        context2d.fillRect(x, y, 1, 1);
      }
    }
  }
}

(function() {
  var generation = createGeneration(100, 100);
  var c = document.getElementById('canvas');
  var ctx = c.getContext('2d');

  draw(ctx, generation);
})()
```

Ces quelques petites fonctions sont bien suffisantes pour afficher un
ensemble de cellules.

Dans le prochain article nous calculerons l'état des générations suivantes.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

{% connexe %}
