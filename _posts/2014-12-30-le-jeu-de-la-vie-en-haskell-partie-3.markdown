---
layout: post
title: "Le jeu de la vie en Haskell - partie 3"
date: 2014-12-30 08:53
legacy: true
tags: [jeu de la vie, haskell]
---



Cette fois je met des tests en place avec [HUnit](https://www.haskell.org/haskellwiki/HUnit_1.0_User%27s_Guide).
Pour cela, je dois d'abord *modulariser* mon code. J'ai donc déplacé le code
de la dernière fois, sans la fonction `main`, dans un fichier `GameOfLife`.
Puis j'ai ajouté la déclaration du module.

<!-- more -->

{% highlight haskell %}
module GameOfLife
( randomCells
, createGeneration
, formatGeneration
) where

import System.Random
import Data.List

type Cell = Int
type Generation = [[Cell]]

randomCells :: Int -> StdGen -> [Cell]
randomCells size gen = take size $ randomRs (0, 1) gen

createGeneration :: Int -> [Cell] -> Generation
createGeneration _ [] = []
createGeneration width cells = line:(createGeneration width rest)
  where (line, rest) = splitAt width cells

formatGeneration :: Generation -> String
formatGeneration generation =
  let rows = intercalate "\n" (map (concatMap show) generation)
   in map replaceChar rows

replaceChar :: Char -> Char
replaceChar '1' = '@'
replaceChar '0' = ' '
replaceChar c   = c
{% endhighlight %}

Une déclaration de module, c'est ça:

{% highlight haskell %}
module GameOfLife
( randomCells
, createGeneration
, formatGeneration
) where
{% endhighlight %}

J'ai donc un module `GameOfLife` qui exporte, pour l'instant, trois fonctions.
Au fait, le code est sur [Github](https://github.com/lkdjiin/game-of-life-haskell).

Je vais créer la fonction `cellNextState`, je la rajoute donc dans les exports
du module:

{% highlight haskell %}
module GameOfLife
( randomCells
, createGeneration
, formatGeneration
, cellNextState
) where
{% endhighlight %}

Et j'en crée une version qui ne fonctionne pas ;)

{% highlight haskell %}
cellNextState :: Cell -> [Cell] -> Cell
cellNextState cell neighborhood = undefined
{% endhighlight %}

C'est parti pour mon premier test en Haskell. Je crée un fichier
`GameOfLife_Test.hs`:

{% highlight haskell %}
module GameOfLife_Test where

import GameOfLife(cellNextState)
import Test.HUnit

testCellNextState3 = TestCase $ assertEqual
  "Gets live cell when neighborhood'sum is 3" 1 (cellNextState 0 [1,1,1,0])

main = runTestTT testCellNextState3
{% endhighlight %}

C'est du bon vieux test unitaire à l'ancienne. Je mentirais en disant que
je trouve la syntaxe sexy.

    $ runhaskell GameOfLife_Test.hs 
    ### Error:                                
    Prelude.undefined
    Cases: 1  Tried: 1  Errors: 1  Failures: 0
    Counts {cases = 1, tried = 1, errors = 1, failures = 0}

Bon, si maintenant ma fonction renvoie 1, le test devrait passer.

{% highlight haskell %}
cellNextState cell neighborhood = 1
{% endhighlight %}

    $ runhaskell GameOfLife_Test.hs 
    Cases: 1  Tried: 1  Errors: 0  Failures: 0
    Counts {cases = 1, tried = 1, errors = 0, failures = 0}

J'aimerais bien avoir une sortie en couleur. Si il y a moyen, je n'ai pas
encore trouvé…

Quoiqu'il en soit, je peux tester mon code Haskell, et ça c'est cool. Je vais
donc en finir avec `cellNextState` en faisant quelques tests de plus:

{% highlight haskell %}
module GameOfLife_Test where

import GameOfLife(cellNextState)
import Test.HUnit

testCellNextState3 = TestCase $ assertEqual
  "Gets 1 when neighborhood's sum is 3"
  1 (cellNextState 0 [1,1,1,0])

testCellNextState4AndAlive = TestCase $ assertEqual
  "Gets 1 when neighborhood's sum is 4 and cell is alive"
  1 (cellNextState 1 [1,1,1,0,1])

testCellNextState4AndDead = TestCase $ assertEqual
  "Gets 0 when neighborhood's sum is 4 and cell is dead"
  0 (cellNextState 0 [1,1,1,0,1])

testCellNextState6 = TestCase $ assertEqual
  "Gets 0 when neighborhood's sum is 6"
  0 (cellNextState 1 [1,1,1,0,1,1,1])

main = runTestTT $ TestList [testCellNextState3,
                            testCellNextState4AndAlive,
                            testCellNextState4AndDead,
                            testCellNextState6]
{% endhighlight %}

    $ runhaskell GameOfLife_Test.hs 
    ### Failure in: 2                         
    Gets 0 when neighborhood's sum is 4 and cell is dead
    expected: 0
     but got: 1
    ### Failure in: 3                         
    Gets 0 when neighborhood's sum is 6
    expected: 0
     but got: 1
    Cases: 4  Tried: 4  Errors: 0  Failures: 2
    Counts {cases = 4, tried = 4, errors = 0, failures = 2}

{% highlight haskell %}
cellNextState :: Cell -> [Cell] -> Cell
cellNextState cell neighborhood
  | total == 4 = cell
  | total == 3 = 1
  | otherwise = 0
    where total = sum neighborhood
{% endhighlight %}

    $ runhaskell GameOfLife_Test.hs 
    Cases: 4  Tried: 4  Errors: 0  Failures: 0
    Counts {cases = 4, tried = 4, errors = 0, failures = 0}




