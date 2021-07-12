---
layout: post
title: "Le jeu de la vie en Haskell - partie 4"
date: 2014-12-30 21:09
legacy: true
tags: [jeu de la vie, haskell]
---



Je dois maintenant pouvoir extraire 9 cellules d'une génération (la cellule
cible et ses 8 voisines). Pour cela, je vais avoir besoin de la fonction
suivante:

{% highlight haskell %}
extractNeighborhood :: Generation -> Int -> Int -> [Cell]
{% endhighlight %}

Elle prendra en entrée la génération, l'index de la rangée et l'index de la
colonne. Mais pour simplifier l'implémentation de `extractNeighborhood` j'ai
ressenti le besoin d'une fonction utilitaire `sliceAround` qui ferait ça:

    $ ghci
    > :load Slice.hs 
    > let list = [0,1,2,3,4,5]
    > sliceAround 1 list
    [0,1,2]
    > sliceAround 4 list
    [3,4,5]
    > sliceAround 0 list
    [0,1]
    > sliceAround 5 list
    [4,5]

<!-- more -->

J'ai donc écrit les tests (que vous pouvez trouvez sur [Github](https://github.com/lkdjiin/game-of-life-haskell)) et le module
`Slice` qui en découle:

{% highlight haskell %}
module Slice (sliceAround) where

sliceAround :: Int -> [a] -> [a]
sliceAround 0 list = take 2 list
sliceAround n list = take 3 $ drop (n-1) list
{% endhighlight %}

C'était facile. J'ai quand même été étonné de ne pas trouver une fonction
`slice` de base (ou j'ai mal cherché, c'est toujours possible ;) ). Même s'il
est vrai qu'avec `take` et `drop` c'est très simple à obtenir.
Ensuite j'utilise `sliceAround` pour écrire `extractNeighborhood`:

{% highlight haskell %}
extractNeighborhood :: Generation -> Int -> Int -> [Cell]
extractNeighborhood generation row column
  | row == 0 = row1 ++ row2
  | row == (length generation) - 1 = row0 ++ row1
  | otherwise = row0 ++ row1 ++ row2
    where row0 = getRow $ row - 1
          row1 = getRow row
          row2 = getRow $ row + 1
          getRow r = sliceAround column $ generation !! r
{% endhighlight %}

Je n'arrive pas à simplifier plus cette fonction, mais il doit y avoir moyen.
Si vous connaissez Haskell, j'aimerais beaucoup avoir votre avis.

Avant de pouvoir en terminé avec ce jeu de la vie en Haskell, il me faut une
fonction `nextGeneration`, et j'ai eu bien peur que celle-ci me fasse mal à la
tête.

En fait ça n'a pas été si violent que ça. En décomposant, j'y suis arrivé
rapidement:

{% highlight haskell %}
nextGeneration :: Generation -> Generation
nextGeneration generation = [(nextRow y generation) | y <- [0..height]]
  where height = (length generation) - 1

nextRow :: Int -> Generation -> [Cell]
nextRow y generation = [(nextCell y x generation) | x <- [0..width]]
  where row = generation !! y
        width = (length row) - 1

nextCell :: Int -> Int -> Generation -> Cell
nextCell y x generation = cellNextState cell neighborhood
  where neighborhood = extractNeighborhood generation y x
        cell = (generation !! y) !! x
{% endhighlight %}

Mais là encore, j'ai l'impression qu'il y a moyen de simplifier…

Il ne me reste plus qu'à faire une boucle:

{% highlight haskell %}
import System.Random
import GameOfLife
import Control.Concurrent

loop 0 _ = return ()
loop n g =
 do
   displayGeneration g
   threadDelay 1000000
   loop (n-1) (nextGeneration g)

main :: IO()
main =
  let width = 80
      height = 23
      cells = randomCells (width * height) (mkStdGen 1234)
      generation = createGeneration width cells
   in loop 40 generation
{% endhighlight %}

Notez `threadDelay`, pour faire une pause, qui prend un
nombre de micro-secondes ! Je ne sais pas si ça fonctionne à ce niveau de
granularité, mais ça m'impressionne.

Finalement, on peut compiler et lancer le programme \o/

    $ ghc -o gol Slice.hs GameOfLife.hs gol.hs
    $ ./gol

Je vous rappelle que le code se trouve sur [Github](https://github.com/lkdjiin/game-of-life-haskell) et que tous vos
commentaires sur ce code seront les bienvenus.

Voilà, j'en ai terminé avec Haskell. Je suis à la fois content, parce que
impatient de commencer la version Rust, et à la fois un peu triste parce que
je commence à peine à entrevoir les possibilités de Haskell. J'espère être en
mesure de me dégager un peu de temps pour continuer à étudier ce langage.




