---
layout: post
title: "Les algorithmes génétiques démystifiés 32"
date: 2013-10-11 20:48
legacy: true
tags: [algorithme génétique]
---



Je vais arrêter d'écrire sur le problème des 8 dames, temporairement. On a
réussi à développer un programme qui permet de trouver des solutions pour
un échiquier de 50 x 50 cases en un temps acceptable. Voici un joli
graphique avec en x, la taille d'un coté de l'échiquier et en y, le nombre
de secondes requis pour obtenir une solution:

{% img /images/secondes-pour-tailles.png %}

<!-- more -->

26 minutes pour un échiquier de 50 x 50 cases, je trouve que ça n'est pas
si mal. Par contre on voit bien comme le temps augmente de manière
exponentielle ! J'aimerais parvenir à trouver des solutions pour un
échiquier de 100 x 100 cases (voir même 1000 x 1000) en un temps raisonable,
disons quelques heures. Pour ça, il faudra améliorer le programme. Peut-être
explorer d'autres méthodes de sélection et/ou croisement ; utiliser les
multiples coeurs de nos machines ; peut-être changer de langage (je pense
en ce moment à Elixir ou Scala, mais je suis ouvert aux suggestions).
Enfin, tout ça sera pour plus tard.

En attendant, je voudrais aborder un problème d'imagerie: un algorithme
génétique qui copierait au mieux une photo à partir de petits carrés de
couleurs et de tailles quelconques. Je compte le faire en Javascript
mais je dois vous prévenir que Javascript et moi, ça fait deux.
Je vais commencer à regarder ça ce week-end, et je compte sur vous pour
pointer les erreurs et les maladresses de mon futur code…





À demain.



