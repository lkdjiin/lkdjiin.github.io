---
layout: post
title: "Git et les alias: la suite"
date: 2013-07-16 09:10
comments: true
categories: [git, intermédiaire, tutoriel]
---

{% level 2 %}

*Hier, j'abordai les bases de la
[création d'alias avec Git](http://lkdjiin.github.io/blog/2013/07/15/git-completion-automatique-et-alias-pour-debutants/).
Aujourd'hui je pousse un peu plus loin en montrant comment intégrer
des commandes externes dans ces alias.*

J'ai constaté récemment que j'utilisai énormément Git:

``` bash
xavier:~$ wc -l .bash_history 
500 .bash_history
xavier:~$ sed -n '/^git/p' .bash_history | wc -l
238
```

Sur 500 lignes d'historique, 238 sont consacrées à Git ! Ça m'a décidé
à approfondir la question des alias.

<!-- more -->

L'opérateur !
--------------
Git permet d'utiliser des commandes externes dans la définitions des
alias à l'aide de l'opérateur `!`. L'exemple qui suit est parfaitement
inutile mais illustre bien ce qui est possible.

``` ini
[alias]
  ls = !ls
```

``` bash
xavier:~$ git ls
bin	   Documents  Images		    Modèles    Téléchargements	www
[...]
```

C'est pas tout, Git accepte aussi les arguments des commandes externes:

``` bash
xavier:~$ git ls -a
.	       .fonts		.javafx_eula_accepted	.remmina
[...]
```

Vous imaginez un peu ce qu'on va pouvoir faire avec ça ? Prenons un
workflow simple : nouvelle branche, ajout de fichier, commit, retour à au
master et merge.

``` bash
    git checkout -b new_branch
    # Édition du code
    git add . # 1 fois sur 2 j'oublie celle-là.
    git commit -a
    git checkout master
    git merge new_branch
```

Il est clair que `git add . ; git commit -a` va se répéter plusieurs fois.
Je cherche donc a optimiser cette partie. Pour cela je modifie mon vieil
alias `ci` ([voir article précédent](http://lkdjiin.github.io/blog/2013/07/15/git-completion-automatique-et-alias-pour-debutants/)).

*Dans les exemples suivants, je n'écris plus `[alias]`, cette ligne est
désormais sous-entendue.*

    ci = !git add . && git commit -a

Git traite `git` comme une commande externe comme les autres -
*logique mais marrant* -, quant à `&&`, cela permet à Bash de n'exécuter
la commande de droite que si la commande de gauche réussie. Il n'y a pas
de raison de douter que `git add .` va crasher et vous pouvez remplacer
`&&` par `;` si vous voulez.

Pour finir sur une note d'humour de geek, voici la commande `la` (pour
list alias) qui va afficher tout les alias.

    # Lister tout les alias.
    la = !git config -l | sed -n '/alias/s/alias\\.//p' | sort

Tout d'abord `git` est utilisé pour lister le contenu du fichier .gitconfig.
Ensuite `sed` sélectionne seulement les lignes commençant par `alias` et en
même temps supprime `alias.` de la ligne. Et enfin `sort` nous trie tout
ça par ordre alphabétique. Notez au passage que le fichier `.gitconfig`
accepte les commentaires.

Conclusion
-----------
On a là un sacré terrain de jeu. Si vous aimez écrire des oneliners, vous
allez pouvoir vous amuser. Voici par exemple une page où vous trouverez
[des définitions d'alias](http://durdn.com/blog/2012/11/22/must-have-git-aliases-advanced-examples/)
bien plus complexe que ce que j'ai montré ici.
Malgré tout, je ne pense pas que les alias de Git soient la réponse à tout 
les problèmes.
Écrire une commande sur une seule ligne va vite devenir illisible si
vous avez besoin de faire quelque chose d'un peu élaboré. Dans un
prochain article je montrerais comment créer vos propres commandes Git
à l'aide de scripts, et non plus simplement d'alias.

À demain.

{% connexe %}
