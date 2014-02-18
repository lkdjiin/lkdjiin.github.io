---
layout: post
title: "Comment mettre temporairement de coté ses modifications de code avec Git"
date: 2014-02-18 21:03
comments: true
categories: [git, débutant, stash, astuce]
---

{% level 1 %}

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

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}


