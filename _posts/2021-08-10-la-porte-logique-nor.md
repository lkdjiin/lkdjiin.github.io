---
layout: post
title:  "La porte logique NOR"
date:   2021-08-10 13:30:18 +0200
comments: true
tags:
---

La dernière fois j'ai montré le fonctionnement d'une
[porte logique NOT](/blog/2021/08/01/la-porte-logique-not)
avec un transistor. Aujourd'hui on va plus loin en ajoutant un second transistor pour
fabriquer une porte logique NOR (NOR gate en anglais)

| a | b | out |
|---|---|-----|
| 0 | 0 |  1  |
| 0 | 1 |  0  |
| 1 | 0 |  0  |
| 1 | 1 |  0  |

NOR signifie Not OR. C'est donc l'inverse d'une porte OR. La table précédente
montre que la sortie est toujours un 0 logique, sauf quand les deux entrées sont
simultanéement à 0. Quand les deux entrées sont en même temps à 0, la sortie est
alors le 1 logique.

On note que la porte NOR possède deux entrées, contrairement à la
porte NOT vue précédemment qui n'en possède qu'une seule.

Sans plus attendre voici le symbole de la porte NOR :

{% img /images/nor-symbole.png %}

Et maintenant voici comment la construire avec deux transistors et trois
résistances.

{% img /images/nor.png %}

On remarque que cette porte NOR ressemble fortement à deux
[portes NOT](/blog/2021/08/01/la-porte-logique-not), fournissant
respectivement les entrées A et B, et reliées ensembles par leur collecteur.

Analyse/modélisation
--------------------
Je vais maintenant analyser ce circuit, comme je l'ai fait pour NOT, en
m'appuyant sur le raccourci suivant : la base d'un transistor agit comme un
interrupteur. (Si ce n'est pas déjà fait, je vous encourage vivement à lire
l'article sur
[la porte logique NOT](/blog/2021/08/01/la-porte-logique-not))

Quand les deux entrées sont à zéro, on voit que l'unique chemin vers OUT vient
du 9 volts, via R1. D'où la sortie avec le 1 logique :

{% img /images/nor-on.png %}

Par contre, quand l'entrée B passe à 1, la sortie OUT se retrouve connectée
directement avec le ground. D'où la sortie avec le 0 logique :

{% img /images/nor-off.png %}

La mécanique est exactement la même lorsque c'est l'entrée A qui est à 1 et
l'entrée B qui est à 0, et à fortiori quand les deux entrées sont à 1. Je vous
laisse faire les petits dessins vous-même pour vous en convaincre.

Porte universelle
---------------
Une caractèristique intéressante de la porte NOR (qu'elle partage d'ailleurs avec la
porte NAND) est d'être une porte logique universelle : En utilisant uniquement
des portes NOR on peut construire toutes les autres portes logiques sans exceptions.

Voici par exemple comment construire un NOT à partir d'un NOR :

{% img /images/nor-not.png %}

Ou comment construire un OR avec deux NOR :

{% img /images/nor-or.png %}

Attention, personne ne dit que c'est d'une efficacité redoutable ;)

Dans le prochain article on va commencer à additionner des bits.


{% include serie_001.md %}
