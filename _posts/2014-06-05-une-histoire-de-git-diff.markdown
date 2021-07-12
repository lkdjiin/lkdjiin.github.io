---
layout: post
title: "Une histoire de git diff"
date: 2014-06-05 21:17
legacy: true
tags: [débutant, git, diff]
---



Je devais fusionner notre branche `development` dans la branche
`master` et envoyer cette nouvelle version en production.

Mais avant d'envoyer quoi que ce soit, en production ou même sur Github,
je lance toujours la suite de tests. Vu notre *workflow*, quand il s'agit
de *merger* `development` dans `master`, c'est plus une formalité, une
habitude, qu'autre chose.

Sauf que cette fois-ci, certains tests ne passaient pas.

<!-- more -->

Comme je l'ai dit, vu notre *workflow*, c'est normalement impossible !
À moins que…

À moins qu'un collêgue -* pas moi bien sûr ;) *- ai fusionné un *hotfix*
dans `master` et oublié de le mettre dans `development` ? Vu qu'on déploit
plusieurs fois par semaines, ça a été vite à controler. C'était pas ça…

En regardant de plus près ce que racontaient les tests qui échouaient, j'ai
remarqué un truc très bizarre. Une des lignes d'où était sensée partir
l'erreur dans le code était … vide ! `Rspec` me disait que l'erreur partait
de la ligne 6, alors qu'elle partait en réalité de la ligne 7 ! Et c'est pas
tout, `Rspec` me soutenait que j'envoyais deux arguments à telle méthode
(c'était ça les erreurs), alors
qu'en réalité j'en envoyais bien un seul ! J'avais le code sous les yeux !

Qui mentait ? `Rspec` ou le code ?

C'est là qu'intervient la commande Git du titre de cet article, si vous avez
lu jusqu'ici.

    git diff master..development

Ça m'a permis de voir les différences entre les deux branches. Il y avait
simplement un fichier qui avait été déplacé et remanié. Seulement l'ancienne
version de ce fichier était elle aussi toujours là, à son ancien emplacement.

Après la suppression de ce fichier indélicat, j'ai pu envoyer le tout
en production. Je ne sais toujours pas pourquoi il y avait cette différence.
Je n'ai pas eu (*pris ?*) le temps de chercher. Enfin bref, merci Git :)



À demain.


