---
layout: post
title: "Le jeu de la vie en logo - partie 1"
date: 2014-12-16 18:01
comments: true
categories: [jeu de la vie, logo]
---

{% level 2 %}

C'est parti pour la version Logo du jeu de la vie. J'utiliserais
[ucblogo](http://www.cs.berkeley.edu/~bh/logo.html) en version 5.5, qui est celle qu'on trouve dans les paquets Debian.
Sur leur site vous trouverez la version 6, si vous souhaitez la compiler.

    $ logo
    Welcome to Berkeley Logo version 5.5

Introduction
------------

Attention ! Le monde de Logo est autre. Je n'ai pas d'autres formules qui me
viennent à l'esprit.  Si vous utilisez Vim, j'ai écrit un fichier de
[coloration syntaxique pour Logo](https://github.com/lkdjiin/logo.vim),
minimal, mais toujours utile pour ne pas se sentir coincé dans les années 80.
Et comme il n'existe pas de frameworks de test (ou alors ils sont bien cachés),
j'en ai écrit un rudimentaire : [Logo unit test](https://github.com/lkdjiin/logo-unit).

Bref, vous aurez compris que l'éco-système Logo open source est assez pauvre,
voir inexistant.  Je crois qu'il n'y a même pas de tag `logo` sur
stackoverflow.

<!-- more -->

Création d'une génération
-------------------------

Créons un fichier pour les tests, et un fichier pour l'implémentation.

    $ tree
    .
    ├── generation.lg
    └── test.generation.lg

En avant pour le premier test, je veux m'assurer que la procédure
`create.generation` renvoie une liste.

``` raw test.generation.lg
load "generation.lg

to t.create.generation.returns.a.list
assert.list create.generation
end
```

### Premières remarques sur Logo

Tout d'abord, les points n'ont rien à voir avec des appels de
méthode/fonction/procédure.  C'est juste une manière de nommer les choses. En
Ruby on aurait `assert_list`, en Java `assertList`, en Racket `assert-list`, en
Logo c'est plutôt `assert.list`.

Ensuite, la première ligne `load "generation.lg`, qui charge le fichier
`generation.lg`, ne contient pas de faute de frappe ! Il y a bien un seul
guillement double (`"`). C'est la façon de dire que `generation.lg` doit être
pris dans son sens littéral, pas en tant que variable ou procédure, mais bien en
tant que nom.

### Lancer les tests

On lance les tests en chargeant la procédure `tt`. Logo nous dit *je ne sais
pas comment faire pour create.generation*. Normal puisque cette procédure
n'existe pas encore.

    $ logo
    Welcome to Berkeley Logo version 5.5
    ? tt "test.generation.lg
    I don't know how  to create.generation  in t.create.generation.returns.a.list
    [assert.list create.generation]

### Notre première procédure

Il suffit de renvoyer une liste vide pour faire passer le test. Notez que
`output` est l'équivalent du plus commun `return`.

``` raw generation.lg
to create.generation
output []
end
```

    ? tt "test.generation.lg
    .

    1 tests. 0 fail.

### Une liste à plusieurs dimensions

Notre liste devra avoir une largeur (x) et une hauteur (y), commençons par
tester la hauteur.

``` raw test.generation.lg
load "generation.lg

to t.create.generation.returns.a.list
assert.list create.generation 3
end

to t.create.generation.have.a.height
assert.equal 3 count create.generation 3
end
```

Voici le code permettant de faire passer nos nouveaux tests.

``` raw generation.lg
to create.generation :height
output cascade :height [lput # ?] []
end
```

`cascade` prend un nombre d'itération, un template et une valeur de départ.
`lput` (pour *last put*) ajoute une valeur à la fin d'une liste. `#` dans le
template est remplacé par l'itération.

Ensuite, nouveaux tests pour s'assurer qu'on a aussi une largeur.

``` raw test.generation.lg
load "generation.lg

to t.create.generation.returns.a.list
assert.list create.generation 4 3
end

to t.create.generation.have.a.height
assert.equal 3 count create.generation 4 3
end

to t.create.generation.have.a.width
assert.equal 4 count first create.generation 4 3
end
```

On implémente notre liste à 2 dimensions.

``` raw generation.lg
to create.generation :width :height
output cascade :height [lput (p.create.line :width) ?] []
end

to p.create.line :width
output cascade :width [lput 0 ?] []
end
```

Le `p.` en tête d'un nom de procédure est une convention que j'ai utilié pour
signifier que la procédure est privée.

Les tests passent.

    ? tt "test.generation.lg
    ...

    3 tests. 0 fail.

On peut regarder à quoi ressemble la sortie de notre procédure.

    ? print create.generation 4 3
    [0 0 0 0] [0 0 0 0] [0 0 0 0]

### Un peu de hasard

Les cellules du jeu de la vie sont représentées soit par un 0 (cellule
morte), soit par un 1 (cellule vivante). Je teste que `create.generation`
produit bien une suite de 0 et de 1.

``` raw test.generation.lg
to t.create.generation.produces.0s.or.1s
rerandom
localmake "result create.generation 3 2
assert.equal :result [[1 0 1] [1 1 1]]
end
```

`rerandom` place le générateur de nombre aléatoire dans un état reproductible,
pour pouvoir tester facilement. `localmake` déclare une variable locale, ici
`result` qui va contenir la sortie de `create.generation 3 2`.

Et j'implémente avec la procédure `random` qui renvoie un nombre aléatoire.

``` raw generation.lg
to p.create.line :width
output cascade :width [lput (random 2) ?] []
end
```

Et voilà, les tests passent.

    ? tt "test.generation.lg
    ....

    4 tests. 0 fail.
    ? print create.generation 9 3
    [0 0 1 0 1 1 0 0 0] [1 1 1 1 0 0 0 1 1] [1 0 1 0 1 1 1 1 0]

La portée des variables en Logo
-------------------------------

Le code précédent fonctionne très bien, par contre on peut faire un refactoring
intéressant qui va me permettre de parler d'un phénomène étrange en Logo.

``` raw generation.lg
to create.generation :width :height
output cascade :height [lput p.create.line ?] []
end

to p.create.line
output cascade :width [lput (random 2) ?] []
end
```

Vous remarquerez que j'ai enlevé le paramêtre `width` de la procédure
`p.create.line` et que ce `width` n'est plus passé par `create.generation`.
Pourtant le code continue de fonctionner comme un charme.

C'est que Logo a une notion toute particulière de la *localité* des variables.
Une variable locale à une procédure est connue dans cette même procédure
**et aussi** dans les sous-procédures appelées par cette même procédure.
Autrement dit, `p.create.line` connait les variables `width` et `height`
puisqu'elle est appelée par `create.generation`.

Ce n'est pas le seul langage à fonctionner comme ça (les premiers Lisp et
Perl, il me semble). Par contre je me demande toujours si c'est génial, ou
irresponsable.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

{% connexe %}
