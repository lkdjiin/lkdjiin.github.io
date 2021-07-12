---
layout: post
title: "Le jeu de la vie en Haskell - partie 1"
date: 2014-12-28 18:05
legacy: true
tags: [jeu de la vie, haskell]
---



Première rencontre avec Haskell
-------------------------------

L'histoire qui suit a du arriver à de nombreux développeurs rencontrant Haskell
pour la première fois.

— Bon, comment produire un nombre aléatoire ?  
— Ah OK, je vois.  
— Euh, attends, tu veux dire que je dois passer un générateur avec une *seed* à
chaque fois ?  
— Ah OK, c'est l'histoire des fonctions *pures*, quand tu as le même argument en
entrée, tu produis **toujours** la même valeur en sortie. Du coup, tu ne peux
pas avoir une fonction `random` qui te sortirait une valeur différente à chaque
appel. Oui, d'accord, c'est logique.  
— Ah mais non, attends, je fais comment pour lui donner une *seed* différente à
chaque lancement du programme ? Ah, bin oui, j'ai qu'a prendre l'heure système,
ou un truc comme ça.  
— Comment ça le générateur n'accepte pas mon heure système comme *seed* !?
— Comment ça c'est pas le bon type ?! Qu'est-ce que c'est que cette histoire de
monade IO ? Qu'est-ce que c'est que ce langage où je ne peux pas convertir
l'heure système en un entier qui me servirait à quelque chose ???!!!

Bref, bonjour Haskell…

<!-- more -->

Création d'une génération
-------------------------

Toute cette histoire n'est peut-être pas si importante. Une fois
accepté que Haskell a certainement une bonne raison de ne pas nous laisser faire
une chose particulière, on peut avancer. Finalement, si je produis toujours les
mêmes nombres, ça devrait être plus simple pour tester.

Le code suivant produit une liste de `0` et de `1`. En entrée, la fonction
prend la taille de la liste et un générateur de nombre aléatoire.

{% highlight haskell %}
import System.Random

randomCells :: Int -> StdGen -> [Int]
randomCells size gen = take size $ randomRs (0, 1) gen
{% endhighlight %}

Pour essayer ce code, j'utilise `ghci`, le REPL Haskell. C'est une vieille
version qui était déjà installée sur ma machine.

    $ ghci
    GHCi, version 6.12.1: http://www.haskell.org/ghc/  :? for help

Dans `ghci`, on charge notre fichier avec `:l gol.hs`. (`:l` est l'abbréviation
de `:load`).

    Prelude> :l gol.hs 
    [1 of 1] Compiling Main             ( gol.hs, interpreted )
    Ok, modules loaded: Main.

On va produire une liste de 12 nombres. Pour obtenir un générateur de nombre
aléatoire, on utilise `mkStdGen`, que j'initialise ici avec le nombre `4567`.

    *Main> randomCells 12 (mkStdGen 4567)
    [1,0,1,0,1,1,1,1,1,0,1,0]

Alors, on pourrait s'arrêter là pour la création des cellules. On pourrait très
bien se débrouiller avec une liste simple. Mais je préfère quand même avoir une
liste de listes (une liste de rangées).

Voilà donc une jolie fonction récursive `createGeneration` qui prend en entrée
la liste de cellules aléatoires, la largeur d'une rangée, et la génération en
cours de production (l'accumulateur).

{% highlight haskell %}
createGeneration :: [Int] -> Int -> [[Int]] -> [[Int]]
createGeneration [] width generation = generation
createGeneration cells width generation =
    let line = take width cells
     in createGeneration (drop width cells) width (line:generation)
{% endhighlight %}

    *Main> let cells = randomCells 12 (mkStdGen 4567)
    *Main> createGeneration cells 4 []
    [[1,0,1,0],[1,1,1,1],[1,0,1,0]]

Pour finir, voici le listing complet du fichier `gol.hs`.

{% highlight haskell %}
import System.Random

randomCells :: Int -> StdGen -> [Int]
randomCells size gen = take size $ randomRs (0, 1) gen

createGeneration :: [Int] -> Int -> [[Int]] -> [[Int]]
createGeneration [] width generation = generation
createGeneration cells width generation =
    let line = take width cells
     in createGeneration (drop width cells) width (line:generation)

main =
    let cells = randomCells 12 (mkStdGen 123)
     in print (createGeneration cells 4 [])
{% endhighlight %}

    $ runhaskell gol.hs 
    [[0,0,1,0],[0,0,0,1],[1,1,1,0]]

Comme il s'agit de mon tout premier code en Haskell, n'hésitez surtout pas à me
remonter mes erreurs, ou bien des trucs pour améliorer le code.

**P.S.**

Vous avez peut-être remarqué que je n'ai pas écrit de tests ?
J'avais remarqué [Hspec](http://hspec.github.io/), que j'aurais aimé utilisé.
Mais `cabal` refuse de l'installer. Je pense que ma version d'Haskell est trop
datée et qu'il me faudrait refaire une installation sans passer par les paquets
de mon OS. Je sais qu'il y a [HUnit](https://www.haskell.org/haskellwiki/HUnit_1.0_User%27s_Guide)
de base, mais ça m'a l'air bien compliqué à mettre en place pour mon niveau de
débutant. Si je continue Haskell après avoir écrit le jeu de la vie, il est sûr
que je m'y mettrais.




