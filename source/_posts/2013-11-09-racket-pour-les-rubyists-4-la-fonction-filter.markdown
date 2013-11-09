---
layout: post
title: "Racket pour les Rubyists 4: La fonction filter"
date: 2013-11-09 18:39
comments: true
categories: [Racket, Ruby, tutoriel, débutant]
---

{% level 1 %}

Aprés avoir vu comment faire un [test d'égalité](http://lkdjiin.github.io/blog/2013/11/08/racket-pour-les-rubyists-3-trouver-les-diviseurs/)
en Racket, on s'intéresse aujourd'hui à la fonction `filter`, en la
comparant à la méthode Ruby `select`.

<!-- more -->

select vs filter
----------------
Pour obtenir les nombres impairs d'une liste, voici comment on pourrait
faire en Ruby:
 
``` ruby
[1, 2, 3, 4].select {|i| i.odd? } #=> [1, 3]
```

D'une manière générale, on a:

    liste.select bloc

Et voici la façon de faire en Racket:

``` racket
(filter odd? '(1 2 3 4)) ;=> '(1 3)
```

Qu'on généralise en:

    (filter fonction liste)

Comme Ruby, Racket place un point d'interrogation à la fin du nom d'une
fonction qui retourne vrai ou faux. `odd?` s'utilise ainsi:

``` racket
(odd? 1) ;=> #t
(odd? 2) ;=> #f
```

On voit que dans `(filter odd? '(1 2 3 4))`, chaque élément de la liste est
fourni *implicitement* à la fonction `odd?`. De plus, on ne mets pas de
parenthèses autour de `odd?` car on ne veut pas l'évaluer mais seulement
fournir la référence. C'est quelque chose sur lequel je reviendrais souvent
et qu'il faudra expliquer plus en détail.

La prochaine fois on parlera des fonctions imbriquées en Racket.

À demain.

{% connexe %}

