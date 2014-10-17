---
layout: post
title: "Le jeu de la vie en javascript - partie 2"
date: 2014-10-17 21:12
comments: true
categories: [jeu de la vie, javascript]
---

{% level 2 %}

[Précédement](http://lkdjiin.github.io/blog/2014/10/16/le-jeu-de-la-vie-en-javascript-partie-1/) nous avons écrit une fonction pour produire une génération de
cellules au hasard. Nous allons aujourd'hui afficher une telle génération.
Je veux maintenant calculer le prochain état d'une cellule, en fonction de son
voisinage. Pour rappel:

- Si la somme des 9 cellules du voisinage est 3, le nouvel état est «vivant».
- Si la somme des 9 cellules du voisinage est 4, le nouvel état est le même
  que l'ancien.
- Dans tous les autres cas, le nouvel état est «mort».

<!-- more -->

Calculer le prochain état d'une cellule
---------------------------------------

Voici les différents tests qui m'ont conduits à l'écriture de la fonction
`nextCellState`. Notez bien que, selon les principes du TDD, je ne les ai pas
écrit tous d'un coup, mais bien un par un, en implémentant la fonction
minimale à chaque nouveau test.

``` javascript
describe("nextCellState", function() {

  it("returns an integer", function() {
    var cells = [1, 1, 1, 0, 0, 0, 0, 0, 0];
    var result = nextCellState(cells);
    expect(Number.isInteger(result)).toBe(true);
  });

  it("returns 1 when it'll be alive", function() {
    var cells = [
      [1, 1, 1, 0, 0, 0, 0, 0, 0],
      [0, 1, 1, 0, 0, 1, 0, 0, 0],
      [0, 1, 0, 0, 0, 1, 0, 1, 0]
    ];
    for(var i = 0; i < cells.length; i++) {
      expect(nextCellState(cells[i])).toBe(1);
    }
  });

  it("returns 0 when it'll be dead", function() {
    var cells = [
      [1, 1, 1, 1, 1, 1, 1, 1, 1],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 1, 0, 0, 0, 0, 0, 0, 0]
    ];
    for(var i = 0; i < cells.length; i++) {
      expect(nextCellState(cells[i])).toBe(0);
    }
  });

  it("returns current state as next state", function() {
    var cells = [
      [1, 1, 1, 1, 0, 0, 0, 0, 0],
      [0, 1, 0, 0, 1, 1, 1, 0, 0]
    ];
    expect(nextCellState(cells[0])).toBe(0);
    expect(nextCellState(cells[1])).toBe(1);
  });

});
```

Et voici cette fonction.

``` javascript app/application.js
function nextCellState(neighborhood) {
  var result = neighborhood.reduce(function(a, b) {
    return a + b
  }, 0);

  if(result === 3)
    return 1;
  else if(result === 4)
    return neighborhood[4];
  else
    return 0;
}
```

Maintenant il me faut une fonction qui extrait un *voisinage* à partir d'une
position dans une génération. C'est la partie la plus complexe. Comme toujours,
je commence doucement avec un test très simple et son code d'implémentation.

``` javascript
describe("extractNeighborhood", function() {

  it("returns an array", function() {
    var result = extractNeighborhood();
    expect(Array.isArray(result)).toBe(true);
  });

});
```

``` javascript app/application.js
function extractNeighborhood() {
  return [];
}
```

Je peux commencer à *specer* les choses sérieuses.

``` javascript
describe("extractNeighborhood", function() {

  beforeEach(function() {
    this.generation = [
      [0, 1, 0, 1],
      [1, 0, 1, 0],
      [0, 1, 1, 0]];
  });

  it("returns an array", function() {
    var result = extractNeighborhood(this.generation, 1, 1);
    expect(Array.isArray(result)).toBe(true);
  });

  it("returns the neighborhood of a cell at x, y", function() {
    var x = 1,
        y = 1,
        result = extractNeighborhood(this.generation, x, y);

    expect(result).toEqual([0, 1, 0, 1, 0, 1, 0, 1, 1]);
  });

});
```

On note l'utilisation de `toEqual` pour tester l'égalité de deux tableaux,
`toBe()` testant l'identité d'après ce que j'ai compris.
Et voici le code qui fait passer tout ça, moche mais pragmatique.

``` javascript app/application.js
function extractNeighborhood(generation, x, y) {
  return [
    generation[y-1][x-1], generation[y-1][x], generation[y-1][x+1],
    generation[y][x-1], generation[y][x], generation[y][x+1],
    generation[y+1][x-1], generation[y+1][x], generation[y+1][x+1] ];
}
```

C'est au tour des cellules du bord, d'abord en haut.

``` javascript
describe("extractNeighborhood", function() {

  ...

  describe("returns the neighborhood of a border's cell", function() {
    it("x=2, y=0", function() {
      var x = 2,
          y = 0,
          result = extractNeighborhood(this.generation, x, y);
      expect(result).toEqual([0, 0, 0, 0, 0, 1, 0, 1, 0]);
    });
  });

});
```

Le code devient de plus en plus moche.

``` javascript app/application.js
function extractNeighborhood(generation, x, y) {
  return firstLine(generation, x, y-1).concat(
    [generation[y][x-1], generation[y][x], generation[y][x+1],
    generation[y+1][x-1], generation[y+1][x], generation[y+1][x+1] ]);
}

function firstLine(generation, x, y) {
  if(y < 0)
    return [0, 0, 0];
  else
    return [generation[y][x-1], generation[y][x], generation[y][x+1]];
}
```

Puisqu'il passe les tests, je cherche à l'améliorer un peu.

``` javascript app/application.js
function extractNeighborhood(generation, x, y) {
  return firstLine(generation[y-1], x).concat(
    [generation[y][x-1], generation[y][x], generation[y][x+1],
    generation[y+1][x-1], generation[y+1][x], generation[y+1][x+1] ]);
}

function firstLine(line, x) {
  if(line === void 0)
    return [0, 0, 0];
  else
    return [line[x-1], line[x], line[x+1]];
}
```

Cellule du bord en bas, maintenant.

``` javascript
  describe("returns the neighborhood of a border's cell", function() {
    it("x=2, y=0", function() {
      ...
    });

    it("x=2, y=2", function() {
      var x = 2,
          y = 2,
          result = extractNeighborhood(this.generation, x, y);
      expect(result).toEqual([0, 1, 0, 1, 1, 0, 0, 0, 0]);
    });
  });
```

``` javascript app/application.js
function extractNeighborhood(generation, x, y) {
  return extractLine(generation[y-1], x).concat(
    [generation[y][x-1], generation[y][x], generation[y][x+1]],
    extractLine(generation[y+1], x));
}

function extractLine(line, x) {
  if(line === void 0)
    return [0, 0, 0];
  else
    return [line[x-1], line[x], line[x+1]];
}
```

Puis refactoring.

``` javascript app/application.js
function extractNeighborhood(generation, x, y) {
  return extractLine(generation[y-1], x).concat(
         extractLine(generation[y], x),
         extractLine(generation[y+1], x));
}
```

On passe au bord gauche.

``` javascript
  describe("returns the neighborhood of a border's cell", function() {
    it("x=2, y=0", function() {
      ...
    });

    it("x=2, y=2", function() {
      ...
    });

    it("x=0, y=1", function() {
      var x = 0,
          y = 1,
          result = extractNeighborhood(this.generation, x, y);
      expect(result).toEqual([0, 0, 1, 0, 1, 0, 0, 0, 1]);
    });
  });
```

La réponse de Jasmine à ce test est:

    Expected [ undefined, 0, 1, undefined, 1, 0, undefined, 0, 1 ] to equal [ 0, 0, 1, 0, 1, 0, 0, 0, 1 ].

Si on suit les principes du TDD, il faut écrire le code tout juste suffisant
pour faire passer ce test. Je me contente donc de mapper les `undefined` en `0`.

``` javascript app/application.js
function extractNeighborhood(generation, x, y) {
  var cells = extractLine(generation[y-1], x).concat(
              extractLine(generation[y], x),
              extractLine(generation[y+1], x));
  return cells.map(function(cell) {
    return cell === undefined ? 0 : cell;
  });
}
```

Si j'ajoute un test pour une cellule du bord droit, il passe.

``` javascript
    it("x=3, y=1", function() {
      var x = 3,
          y = 1,
          result = extractNeighborhood(this.generation, x, y);
      expect(result).toEqual([0, 1, 0, 1, 0, 0, 1, 0, 0]);
    });
```

Très bien, il faut maintenant s'occuper des cellules de coins. Je me rends
compte que les quatres tests suivants passent sans que je n'ai rien à modifier
dans le code.

``` javascript
  describe("returns the neighborhood of a corner's cell", function() {
    it("x=0, y=0", function() {
      var x = 0,
          y = 0,
          result = extractNeighborhood(this.generation, x, y);
      expect(result).toEqual([0, 0, 0, 0, 0, 1, 0, 1, 0]);
    });

    it("x=3, y=0", function() {
      var x = 3,
          y = 0,
          result = extractNeighborhood(this.generation, x, y);
      expect(result).toEqual([0, 0, 0, 0, 1, 0, 1, 0, 0]);
    });

    it("x=0, y=2", function() {
      var x = 0,
          y = 2,
          result = extractNeighborhood(this.generation, x, y);
      expect(result).toEqual([0, 1, 0, 0, 0, 1, 0, 0, 0]);
    });

    it("x=3, y=2", function() {
      var x = 3,
          y = 2,
          result = extractNeighborhood(this.generation, x, y);
      expect(result).toEqual([1, 0, 0, 1, 0, 0, 0, 0, 0]);
    });
  });
```

Je suis donc prêt à tout mettre ensemble. Ce sera pour le prochain article car
celui-ci est déjà bien long.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

{% connexe %}
