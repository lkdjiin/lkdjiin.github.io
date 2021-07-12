---
layout: post
title: "Comment étendre Git avec ses propres scripts: la suite"
date: 2013-07-18 07:39
legacy: true
tags: [git]
---



*Hier j'ai montré comment ajouter une commande à Git à l'aide d'un script.
Aujourd'hui je fais quelque chose d'utile grâce à ce nouveau pouvoir.*

Ce que je fais régulierement avec Git c'est:

1. ajouter une fonctionnalité dans la branche `ma_branche`
2. quand c'est terminé, passer sur la branche `master`
3. fusionner `ma_branche` dans `master`

Comme je ne travaille jamais directement dans la branche master, ce genre
de *merge* n'offre jamais de conflits. J'aimerais regrouper les
étapes 2 et 3 en une seule commande: `git merge-me`.

<!-- more -->

Trouver la branche courante
---------------------------
La première étape consiste à retrouver
et retenir le nom de la branche courante. Étant un grand fan de Sed, je
procederais naturellement comme ça:

    git branch | sed -n '/\* /s///p'

Mais je sais que Sed n'a pas les faveurs de tout le monde. J'ai donc fais une
recherche sur StackOverflow pour trouver une autre manière d'obtenir le
même résultat:

    git rev-parse --abbrev-ref HEAD

Je pense que cette seconde solution est meilleure puisque moins fragile, même
si il y a peu de chance que Git change la sortie de `git branch`. Pour
retenir le nom de la branche, on place la sortie de cette commande dans une
variable Bash:

{% highlight bash %}
#!/bin/bash

BRANCH_TO_MERGE=`git rev-parse --abbrev-ref HEAD`
echo $BRANCH_TO_MERGE
{% endhighlight %}

Comme en Ruby, les backticks déclenchent la commande et retournent sa
sortie. Le résultat:

    xavier:~$ git merge-me
    ma_branche

Maintenant que j'ai vu que ça fonctionnait bien, le reste est un jeu
d'enfant.

Le script final
---------------

On ajoute les deux commandes Git, ce qui donne:

{% highlight bash %}
#!/bin/bash

BRANCH_TO_MERGE=`git rev-parse --abbrev-ref HEAD`
git checkout master
git merge $BRANCH_TO_MERGE
{% endhighlight %}

Et voici le script en action:

    xavier:~$ git merge-me
    Switched to branch 'master'
    Updating 48540e6..c584593
    Fast-forward
     TODO |    1 +
     1 files changed, 1 insertions(+), 0 deletions(-)
    xavier:~$ git branch
    * master
      ma_branche

Ma nouvelle commande fait bien le travail que je lui demande.

Pour aller plus loin
--------------------
Vous n'êtes pas limité à l'utilisation de Bash. Vous pouvez utiliser le
langage que vous voulez. À titre d'exemple, voici l'équivalent du script
précédent, cette fois en Ruby.
Toutefois comme ce genre de script va utiliser beaucoup de commandes
système, Ruby n'est peut-être pas le mieux placé. À vous de voir.

{% highlight ruby %}
#!/usr/bin/env ruby

branch_to_merge = `git rev-parse --abbrev-ref HEAD`
system 'git checkout master'
system "git merge #{branch_to_merge.chomp}"
{% endhighlight %}

On peut aussi combiner script et alias. On donne un nom bien explicite
à notre fichier, comme `git-merge-me-into-master` et on crée un alias
`mm = merge-me-into-master`. Ainsi on a une commande rapide sous les
doigts et on peut facilement retrouver le fichier grâce à son nom quand
on doit le modifier.





À demain.


