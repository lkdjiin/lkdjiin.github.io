---
layout: post
title: "Le jeu de la vie en Julia - partie 3"
date: 2014-12-26 15:06
legacy: true
tags: [jeu de la vie, julia]
---



C'est la troisième et dernière partie du jeu de la vie en Julia. Déjà.
J'aime tellement découvrir et utiliser ce langage que ça me rend triste.

Tout d'abord, le code du [jeu de la vie en Julia](https://github.com/lkdjiin/game-of-life-julia)
est disponible sur Github, pour celles et ceux qui veulent y jeter un oeil.

Calculer la génération suivante
-------------------------------

Maintenant, en avant pour la suite. Encore une fonction, et ça sera terminé. Il faut calculer la génération
suivante à partir de la génération courante:

{% highlight julia %}
generation = [ 0 1 0 1 ;
               1 1 1 1 ;
               0 0 0 0 ;
               1 0 1 0 ]

# ...

@test Generation.next(generation) == [ 1 1 0 1 ;
                                       1 1 0 1 ;
                                       1 0 0 1 ;
                                       0 0 0 0 ]
{% endhighlight %}

<!-- more -->

{% highlight julia %}
module Generation

using ..Neighborhood: extract, state
using ..Cell

# ...

function next(generation)
    duplicate = zeros(generation)
    height, width = size(generation)
    for x in 1:width
        for y in 1:height
            neighborhood = extract(generation, y, x)
            newstate = Cell.next(generation[y, x], state(neighborhood))
            duplicate[y, x] = newstate
        end
    end
    duplicate
end

# ...
{% endhighlight %}

Le code est un peu plus complexe que dans les 2 premiers articles, et il m'a
fallu un peu de temps avant de réussir à utiliser les modules.

Je vais utiliser les fonctions `extract` et `state` du module `Neighborhood`,
module qui est défini dans le module parent, d'où les `..`.

    using ..Neighborhood: extract, state

Je crée un nouveau tableau, aux mêmes dimensions que `generation`, et remplis
de zéros.

    duplicate = zeros(generation)

Ensuite, c'est une boucle dans une boucle qui se sert du code des articles
précédents, avant de renvoyer le tableau `duplicate`. C'est pas très beau, mais
comme le test passe, ça me va pour l'instant.

Il reste à se servir de ce code dans le fichier principal:

{% highlight julia %}
include("neighborhood.jl")
include("cell.jl")
include("generation.jl")
include("display.jl")

function main(height, width, number_of_generation)
    generation = Generation.create(height, width)
    for i in 1:number_of_generation
        Display.draw(generation)
        sleep(0.8)
        generation = Generation.next(generation)
    end
end

main(20, 80, 50)
{% endhighlight %}

Et voilà, c'est terminé ! Le reste de l'article se consacre à l'amélioration
de la fonction `Generation.next`.

Un peu de refactoring
---------------------

Pour améliorer `Generation.next`, il y a la fonction
[eachindex](http://julia.readthedocs.org/en/latest/stdlib/base/#Base.eachindex),
malheureusement elle n'est pas encore disponible dans la dernière version stable.
J'ai donc cherché autre chose.

Ma première tentative : utiliser une compréhension de liste avec `reshape`.

{% highlight julia %}
function next(generation)
    duplicate = zeros(generation)
    height, width = size(generation)
    indexes = reshape([(h,w) for h in 1:height, w in 1:width], length(generation))
    for (y, x) in indexes
        neighborhood = extract(generation, y, x)
        newstate = Cell.next(generation[y, x], state(neighborhood))
        duplicate[y, x] = newstate
    end
    duplicate
end
{% endhighlight %}

La compréhension de liste génère la liste des indexs:

    julia> [(h,w) for h in 1:3, w in 1:4]
    3x4 Array{(Int32,Int32),2}:
     (1,1)  (1,2)  (1,3)  (1,4)
     (2,1)  (2,2)  (2,3)  (2,4)
     (3,1)  (3,2)  (3,3)  (3,4)

Et `reshape` change les dimensions du tableau, ici pour une seule dimension de la bonne longueur:

    julia> reshape([(h,w) for h in 1:3, w in 1:4], 3 * 4)
    12-element Array{(Int32,Int32),1}:
     (1,1)
     (2,1)
     (3,1)
     (1,2)
     (2,2)
     (3,2)
     (1,3)
     (2,3)
     (3,3)
     (1,4)
     (2,4)
     (3,4)

Vous avez peut-être remarqué le pattern (a-t-il un nom ?):

1. Création d'une variable
2. Transformation de cette variable
3. Renvoi de la variable

En général, on peut se passer de la création et du retour explicite en utilisant
un `map`. Ici, j'ai créé une fonction `newstate` à l'intérieur de `next`.

{% highlight julia %}
function next(generation)
    height, width = size(generation)
    indexes = [(h,w) for h in 1:height, w in 1:width]
    function newstate(y,x)
        neighborhood = extract(generation, y, x)
        Cell.next(generation[y, x], state(neighborhood))
    end
    map((yx) -> newstate(first(yx), last(yx)), indexes)
end
{% endhighlight %}

On peut simplifier la fonction anonyme à l'aide du *splat*:

{% highlight julia %}
  map((yx) -> newstate(yx...), indexes)
{% endhighlight %}

Finalement, deux fonctions séparées me semble bien plus lisibles:

{% highlight julia %}
function next(generation)
    height, width = size(generation)
    indexes = [(y, x) for y in 1:height, x in 1:width]
    map((yx) -> newstate(generation, yx...), indexes)
end

function newstate(generation, y, x)
    neighborhood = extract(generation, y, x)
    Cell.next(generation[y, x], state(neighborhood))
end
{% endhighlight %}

Voilà. Le code est disponible sur Gitub : [le jeu de la vie en Julia](https://github.com/lkdjiin/game-of-life-julia).

La prochaine fois, ce sera du Haskell.




