---
layout: post
title: "Le jeu de la vie en Julia - partie 1"
date: 2014-12-23 14:50
legacy: true
tags: [jeu de la vie, julia]
---



Voici la première partie du jeu de la vie en Julia.
Pour installer la dernière version stable (0.3.3), rendez-vous sur le
[Github de Julia](https://github.com/JuliaLang/julia).

Julia est un langage jeune et en pleine effervescence et plusieurs frameworks
de tests sont en cours de création. J'ai notamment remarqué:

- [FactCheck.jl](https://github.com/JuliaLang/FactCheck.jl)
- [JulieTest.jl](https://github.com/arypurnomoz/JulieTest.jl)
- [testfast.jl](https://github.com/Veraticus/testfast.jl)

Création d'une génération
-------------------------

Mais pour ce que je compte faire ici, Julia possède une macro très simple,
[@test](http://julia.readthedocs.org/en/latest/stdlib/test/). Même si `@test`
est très minimal, ça sera suffisant pour ce programme. Voici donc les
tests de la fonction `create` du module `Generation`:

{% highlight julia %}
include("generation.jl")

using Base.Test

HEIGHT = 3
WIDTH = 4

created_generation = Generation.create(HEIGHT, WIDTH)
@test typeof(created_generation) == Array{Int,2}
@test size(created_generation) == (HEIGHT, WIDTH)
for i in 1:length(created_generation)
    @test created_generation[i] in 0:1
end
{% endhighlight %}

<!-- more -->

Et voici les explications ligne par ligne. D'abord je rends disponible le code du futur fichier `generation.jl`:

    include("generation.jl")

Ensuite je demande à utiliser le module `Test`, pour avoir accès à la macro `@test`:

    using Base.Test

Définition des *constantes* pour la hauteur et la largeur de la génération:

    HEIGHT = 3
    WIDTH = 4

Création d'une génération, c'est cette fonction qu'il m'intéresse de tester:

    created_generation = Generation.create(HEIGHT, WIDTH)

Je m'assure que `create` renvoie un tableau d'entiers à 2 dimensions:

    @test typeof(created_generation) == Array{Int,2}

Je m'assure que le tableau renvoyé par `create` possède bien les dimensions
voulues:

    @test size(created_generation) == (HEIGHT, WIDTH)

Je m'assure enfin que chaque cellule du tableau est un 1 ou un 0:

    for i in 1:length(created_generation)
        @test created_generation[i] in 0:1
    end

Pour lancer ces tests : `julia test.jl`.

Voici maintenant la fonction `create` qui fera passer les tests ci-dessus:

{% highlight julia %}
module Generation

create(height, width) = rand(0:1, height, width)

end
{% endhighlight %}

Notez l'efficacité de la fonction `rand`. Sans argument, elle produit
classiquement un nombre aléatoire entre 0 et 1:

    julia> rand()
    0.7084513868758786

Avec un *range*, elle sort un nombre compris dans ce *range*:

    julia> rand(0:1)
    1

Si j'ajoute en plus une dimension, elle renvoie un tableau:

    julia> rand(0:1, 3)
    3-element Array{Int32,1}:
     0
     0
     1

Avec deux dimensions:

    julia> rand(0:1, 3, 4)
    3x4 Array{Int32,2}:
     0  0  0  1
     1  1  1  1
     1  1  0  0

Et même pour le fun, avec 3 dimensions:

    julia> rand(0:1, 3, 4, 3)
    3x4x3 Array{Int32,3}:
    [:, :, 1] =
     1  1  1  1
     0  1  0  0
     0  0  1  0

    [:, :, 2] =
     1  1  0  1
     0  0  0  0
     1  1  1  1

    [:, :, 3] =
     0  0  0  1
     1  0  0  1
     1  1  0  0

Vous pouvez aussi tester avec encore plus de dimensions, ça fonctionnera.

Affichage d'une génération
--------------------------

Bon, Julia est jeune, je l'ai déjà dit. Je n'ai rien trouvé de simple pour faire
un peu de graphisme, donc je vais faire les sorties dans la console.

{% highlight julia %}
module Display

function draw(generation)
    run(`clear`)
    println(replace(repr(generation)[2:end-1], " ", ""))
end

end
{% endhighlight %}

La première ligne de la fonction, `run`, appelle la commande système
`clear`, qui efface l'écran du terminal.

La seconde demande à être décomposée. Soit la génération suivante:

    julia> generation = rand(0:1, 2, 3)
    2x3 Array{Int32,2}:
     0  0  1
     0  1  0

`repr` nous donne la représentation en chaîne de caractères:

    julia> repr(generation)
    "[0 0 1\n 0 1 0]"

On peut accéder à une chaîne comme un tableau, ici je conserve ce qui se trouve
entre le second et l'avant-dernier élément:

    julia> repr(generation)[2:end-1]
    "0 0 1\n 0 1 0"

**Je m'aperçois que j'ai oublié de parler d'un truc important: l'indexation les
tableaux en Julia commence à 1.**

Pour finir je supprime les espaces avec `replace`:

    julia> replace(repr(generation)[2:end-1], " ", "")
    "001\n010"

Et quand on combine tout ça dans un fichier `main.jl`, voici le résultat:

{% highlight julia %}
include("generation.jl")
include("display.jl")

height = 20
width = 80

generation = Generation.create(height, width)
Display.draw(generation)
{% endhighlight %}

    $ julia main.jl
    00010111100111000011100111001010001101000010110111000111101101110101000011100000
    00001101010010101111001010110101100101001000001011010001010110010100011011011011
    01001000011101000001101110010010110000100101011110001001110110101111010001001001
    11111110011101100001111010110101110000101011011000000011110000010011011100111111
    11100100000011100001111111101010011000110011010101011100011110101110111111001111
    11110011000101101010110010110011101101000111000111111111001110010100011101010101
    10011101010110011110100101110110111101111101100110011011011001011100000110110000
    01001110010101111101110001000110110100001101100100000010011101111000001010111100
    00011001011000000000000111010000100001100000001110101110000010100010101111011111
    00101011011010000001111001001011111101101110111000101100000100001101110110101100
    10000010100100011111111101010101001010001010111111001111100001010001011010000001
    11000011000001001101011001111101111111111111011111100101100101010000101111101001
    11010111011111101001111110100000001011100100010100100100000010001011000010101110
    10011000100111111100011010010100110001101110001001100100100000010100111001111011
    11110001001011000101100001001110010100010011100101001101010111111100011100111101
    11001111000101101111001110010010101001110010101100010100101011101011000101000000
    01001111111101010010001100010011000001110110001110110101010101010000111010111000
    01101001011011011001110010010010000101000111111111010101001011101011111001101010
    00101111001100011111110110000110011100001011011100101101011001111111111100011110
    01110001110010001001011100100000100000010110001100011011101001010011111011110100

Pour rendre la sortie écran un peu plus présentable, *effaçons* les 0, en les
remplaçant par des espaces, et remplaçons les 1 par des @:

{% highlight julia %}
module Display

function draw(generation)
    run(`clear`)
    output = replace(repr(generation)[2:end-1], " ", "")
    output = replace(output, "1", "@")
    output = replace(output, "0", " ")

    println(output)
end

end
{% endhighlight %}

Pour terminer, voici une petite boucle pour afficher une dizaine de générations:

{% highlight julia %}
include("generation.jl")
include("display.jl")

height = 20
width = 80

for _ in 1:10
    generation = Generation.create(height, width)
    sleep(0.8)
    Display.draw(generation)
end
{% endhighlight %}




