---
layout: post
title: "Le jeu de la vie en Haskell - partie 2"
date: 2014-12-29 15:07
legacy: true
tags: [jeu de la vie, haskell]
---



Je vais commencer par une amélioration du code du
[dernier article](http://lkdjiin.github.io/blog/2014/12/28/le-jeu-de-la-vie-en-haskell-partie-1/)
(merci [@julienXX](https://twitter.com/julienXX) pour les indices).

La fonction `createGeneration` était comme ceci:

{% highlight haskell %}
createGeneration :: [Int] -> Int -> [[Int]] -> [[Int]]
createGeneration [] width generation = generation
createGeneration cells width generation =
    let line = take width cells
     in createGeneration (drop width cells) width (line:generation)
{% endhighlight %}

Je l'ai transformé comme cela:

{% highlight haskell %}
type Cell = Int

createGeneration :: Int -> [Cell] -> [[Cell]]
createGeneration _ [] = []
createGeneration width cells = line:(createGeneration width rest)
  where (line, rest) = splitAt width cells
{% endhighlight %}

<!-- more -->

Elle utilise maintenant `splitAt`, une fonction de base, qui simplifie la
transformation d'une liste en une liste de listes. J'ai aussi créé un type
`Cell`, qui me semble utile à des fins de documentation.

Affichage d'une génération
--------------------------

Le sujet principal de cet article, c'est l'affichage d'une génération dans le
terminal. Voici ma solution:

{% highlight haskell %}
import Data.List

formatGeneration :: [[Cell]] -> String
formatGeneration generation =
  let rows = intercalate "\n" (map (concatMap show) generation)
   in map replaceChar rows

replaceChar :: Char -> Char
replaceChar '1' = '@'
replaceChar '0' = ' '
replaceChar c   = c
{% endhighlight %}

En avant pour les explications pas à pas. `concat` concatène une liste de
*string* et `show` transforme un élément en *string*.

    > concat ["1", "0"]
    "10"
    > show 1
    "1"

Je *mappe* la fonction `show` sur chaque élément d'une liste de nombres.

    > map show [1,0]
    ["1","0"]

Puis je peux les concaténer.

    > concat (map show [1,0])
    "10"

`concatMap` est un raccourci pour `concat (map ...)`.

    > concatMap show [1,0]
    "10"

On *mappe* le code précédent sur une génération complête.

    > map (concatMap show) [[1,0], [0,0], [1,1]]
    ["10","00","11"]

Puis, grâce à `intercalate`, on joint les éléments avec un saut de ligne.

    > import Data.List
    > intercalate "\n" (map (concatMap show) [[1,0], [0,0], [1,1]]) 
    "10\n00\n11"

Pour ce qui est de `replaceChar`, l'exemple suivant parle de lui-même.

    > :load gol.hs 
    > map replaceChar "10\n00\n11"
    "@ \n  \n@@"

Voici le code actuel, n'hésitez pas à me faire part des améliorations possibles.

{% highlight haskell %}
import System.Random
import Data.List

type Cell = Int

randomCells :: Int -> StdGen -> [Cell]
randomCells size gen = take size $ randomRs (0, 1) gen

createGeneration :: Int -> [Cell] -> [[Cell]]
createGeneration _ [] = []
createGeneration width cells = line:(createGeneration width rest)
  where (line, rest) = splitAt width cells

formatGeneration :: [[Cell]] -> String
formatGeneration generation =
  let rows = intercalate "\n" (map (concatMap show) generation)
   in map replaceChar rows

replaceChar :: Char -> Char
replaceChar '1' = '@'
replaceChar '0' = ' '
replaceChar c   = c

main :: IO()
main =
    let width = 80
        height = 24
        cells = randomCells (width * height) (mkStdGen 123)
        generation = createGeneration width cells
     in putStrLn $ formatGeneration generation
{% endhighlight %}

    $ runhaskell gol.hs
    @@@    @  @ @@@ @@@@@@ @ @  @ @   @ @ @  @@@@   @   @@  @  @@@@ @ @ @@@ @@  @  @
      @  @ @@ @@@ @@@@  @@ @@@@ @ @@@    @@ @ @ @@  @          @ @@@ @ @@@ @@@ @  @ 
      @ @@@ @@ @ @@ @@      @   @@@  @@    @  @ @@ @@ @@@   @@@@@@     @@  @@@@ @@ @
    [...]




