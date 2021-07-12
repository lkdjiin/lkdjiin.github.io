---
layout: post
title: "Le jeu de la vie en Julia - partie 2"
date: 2014-12-24 10:03
legacy: true
tags: [jeu de la vie, julia]
---



Calcul du prochain état d'un cellule
------------------------------------

Au départ je voulais écrire une fonction `nextcellstate`. C'est la convention
en Julia: séparer les mots par des underscores seulement si c'est
incompréhensible.  Je ne sais pas pour vous, mais moi je trouve `nextcellstate`
incompréhensible.  Donc ça devient `next_cell_state`. C'est mieux. Mais on te
dis aussi que si tu ressens le besoin de mettre des underscores, c'est
peut-être parce que ta fonction en fait trop. Bon conseil.

Alors, cette fonction pourrait appartenir à un module `Cell`. Elle devient donc
`Cell.nextstate`. Pardon, `Cell.next_state`, c'est mieux. Mais j'ai encore `next` et
`state`, qui font deux choses différentes.

`state` calcule l'état d'un voisinage (*neighborhood*) de cellules, c'est à dire le
nombre de `1` (cellule vivante) parmi 9 cellules: celle qui nous intéresse et ses
8 voisines.

`next` calcule le prochain état d'une cellule (1 ou 0, vivante ou morte) selon son
état actuel et l'état de son voisinage.

J'ai donc décidé d'avoir une fonction `Neighborhood.state` plus une fonction
`Cell.next`.  Voici le test pour `Neighborhood.state`, c'est loin d'être
exhaustif, mais j'ai envie d'avancer:

{% highlight julia %}
include("generation.jl")
include("neighborhood.jl")

# ...

@test Neighborhood.state([ 0 1 1 0 0 0 1 1 1]) == 5
{% endhighlight %}

Et la fonction:

{% highlight julia %}
module Neighborhood

state(cells) = countnz(cells)

end
{% endhighlight %}

<!-- more -->

`countnz` compte tout simplement le nombre d'éléments différents de zéro.

Passons à `Cell.next`:

{% highlight julia %}
include("generation.jl")
include("neighborhood.jl")
include("cell.jl")

# ...

ALIVE = 1
DEAD  = 0

@test Cell.next(ALIVE, 5) == 0
@test Cell.next(DEAD, 3) == 1
@test Cell.next(DEAD, 4) == 0
@test Cell.next(ALIVE, 4) == 1
{% endhighlight %}

{% highlight julia %}
module Cell

function next(cell, neighborhood)
    if neighborhood == 3
        1
    elseif neighborhood == 4
        cell
    else
        0
    end
end

end
{% endhighlight %}

Il semble que Julia n'ai pas de switch/case, dommage.

Maintenant je passe à l'extraction d'une génération, c'est à dire les 9 cellules
composées de notre cellule cible et de ses 8 voisines.

{% highlight julia %}
# ...

generation = [ 0 1 0 1 ;
               1 1 1 1 ;
               0 0 0 0 ;
               1 0 1 0 ]
@test Neighborhood.extract(generation, 2, 3) == [ 1 0 1 ; 1 1 1 ; 0 0 0 ]
@test Neighborhood.extract(generation, 3, 2) == [ 1 1 1 ; 0 0 0 ; 1 0 1 ]
{% endhighlight %}

{% highlight julia %}
extract(generation, y, x) = generation[y-1:y+1, x-1:x+1]
{% endhighlight %}

C'est tellement simple à implémenter... J'aime de plus en plus Julia.

Ensuite viennent les tests des cas exceptionnels. Je ne vous en montre que 3:

{% highlight julia %}
generation = [ 0 1 0 1 ;
               1 1 1 1 ;
               0 0 0 0 ;
               1 0 1 0 ]

# ...

@test Neighborhood.extract(generation, 1, 2) == [ 0 1 0 ; 1 1 1 ]

@test Neighborhood.extract(generation, 3, 1) == [ 1 1 ; 0 0 ; 1 0 ]

@test Neighborhood.extract(generation, 1, 1) == [ 0 1 ; 1 1 ]
{% endhighlight %}

Là encore, l'implémentation est simple:

{% highlight julia %}
function extract(generation, y, x)
    height, width = size(generation)
    y_low = y == 1 ? 1 : y - 1
    y_up  = y == height ? height : y + 1
    x_low = x == 1 ? 1 : x - 1
    x_up  = x == width ? width : x + 1
    generation[y_low:y_up, x_low:x_up]
end
{% endhighlight %}

Ce qu'on peut ré-arrenger un peu, par exemple ainsi:

{% highlight julia %}
function extract(generation, y, x)
    height, width = size(generation)
    yrange = range_for(y, height)
    xrange = range_for(x, width)
    generation[yrange, xrange]
end

function range_for(coordinate, dimension)
    low = coordinate == 1 ? 1 : coordinate - 1
    up  = coordinate == dimension ? dimension : coordinate + 1
    low:up
end
{% endhighlight %}

Rendez-vous dans le prochain article pour la fin du jeu de la vie en Julia.




