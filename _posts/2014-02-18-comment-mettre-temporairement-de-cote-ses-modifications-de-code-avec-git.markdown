---
layout: post
title: "Comment mettre temporairement de coté ses modifications de code avec Git"
date: 2014-02-18 21:03
legacy: true
tags: [git, débutant, stash, astuce]
---



**Scénario** : Vous êtes en train de travailler sur la branche
`ma-nouvelle-fonction` et on vous demande de réparer un bug de toute
urgence. Ce bug est sur la branche `master`.

**Problème** : votre branche
`ma-nouvelle-fonction` est dans un état instable, vous n'êtes pas prêt
à commiter les changements. Il se peut que le code ne fonctionne pas,
qu'il vous faille 10 minutes pour faire des commits propres, etc.

<!-- more -->

**Solution** : Utilisez `git stash`.

Il vous suffit d'entrer:

    git stash

et tous vos changements vont être mis dans la «zone de stashing». Une
espèce d'endroit à part. Votre branche `ma-nouvelle-fonction` se retrouve
dans l'état stable du dernier commit.

Vous pouvez maintenant créer une nouvelle branche `mon-fix` à partir de
`master`, travailler dessus, commiter, pusher, merger, enfin bref faire
ce que vous avez à faire.

Quand vous en avez fini, vous pouvez retourner sur la branche
`ma-nouvelle-fonction` et récupérer vos modifications:

    git checkout ma-nouvelle-fonction
    git stash pop

`git stash pop` va réintroduire vos modifications et effacer la zone de
stashing.

La commande `stash` peut faire bien d'autres choses que ce que je viens
de montrer, c'est tout juste le sommet de l'iceberg. Je vous recommande
donc un petit `git help stash` pour en savoir plus.



À demain.




