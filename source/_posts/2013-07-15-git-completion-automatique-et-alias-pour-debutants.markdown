---
layout: post
title: "Git: complétion automatique et alias pour débutants"
date: 2013-07-15 07:50
comments: true
categories: [git, débutant, tutoriel]
---

{% level 1 %}

Utilisez git en ligne de commande, c'est taper encore et encore les mêmes
commandes sur votre clavier. Si vous êtes comme moi, vous utilisez la
ligne de commande parce que vous savez que c'est ce qu'il y a de plus
rapide. C'est puissant, mais ça peut aussi finir par lasser. On va voir
comment accélerer encore les choses.

<!-- more -->

Complétion automatique
----------------------
Il y a tout d'abord la complétion automatique, si votre système est
configuré pour. Si par exemple je tape `git c`, suivi de la touche
tabulation ([Tab]), voici ce qu'il se passe:

``` bash
xavier:~$ git c
checkout      cherry-pick   clean         clone         commit 
cherry        ci            cleanup       co            config 
xavier:~$ git c
```

Je suis informé de toutes les commandes commençant par la lettre `c`. Et la
ligne de commande est reprise automatiquement sur une nouvelle ligne, prête à
être complétée. Si je tape `git chec` puis [Tab], la commande s'étends de suite
en `git checkout` puisqu'il n'y a plus d'ambiguités. C'est un bon moyen pour se
rafraichir la mémoire sur les différentes commandes disponibles, et ça accélère
un peu la frappe au clavier. Mais on doit pouvoir faire mieux.


Les alias git
---------
Git permet de définir des alias (littéralement: pseudonyme ou nom d'emprunt) sur
ses commandes. Un classique du genre est `git co`, à la place de `git
checkout`. Pour faire ça, on utilise la commande `config` de git:

    git config --global alias.co 'checkout'

Maintenant, partout où vous utilisiez `checkout` vous pouvez vous contentez
de `co`, par exemple:

``` bash
# Grâce à son système d'alias, git transforme la ligne suivante
# en 'git checkout master'.
git co master
```

Il faut noter que la complétion automatique fonctionne aussi sur le nom de
la branche. Ainsi `git co m[Tab]` sera étendu en `git co master` (si la
branche `master` est la seule commençant par la lettre `m`, bien entendu).

Le fichier .gitconfig
---------------------
Git enregistre vos alias dans le fichier `~/.gitconfig`. Si vous vous sentez
à l'aise avec l'idée d'éditer ce fichier, vous pouvez le faire. Je trouve
que c'est plus simple que d'avoir à se souvenir de la syntaxe de la
commande `git config`. Voyons ce que ça donne avec notre alias `co`:

``` ini section [alias] de .gitconfig - exemple 1
[alias]
	co = checkout
```

Ajoutons un autre classique du genre, `ci` pour `commit`:

``` ini section [alias] de .gitconfig - exemple 2
[alias]
	co = checkout
	ci = commit
```

Voilà, maintenant vous pouvez écrire:

    git ci -a ...

à la place de

    git commit -a ...

Les alias peuvent aussi contenir des options. Par exemple, pour afficher les
3 derniers commits, on peut ajouter un alias sur la commande `log` de cette
manière:

``` ini section [alias] de .gitconfig - exemple 3
[alias]
	co = checkout
	ci = commit
  last = log -3
```

Pour conclure
-------------
Je vous ai présenté les fonctionnalités basiques des alias de git. On a vu
notamment deux manières de les créer. Les alias git
peuvent se révéler beaucoup plus puissants que ce que j'ai abordé dans
ce tutoriel d'introduction. En attendant un possible futur article sur
le sujet, si vous
cherchez un peu sur internet vous trouverez des tas de définitions
d'alias, certaines très utiles et d'autres moins. À vous de faire le tri
selon vos besoins.



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.
{% connexe %}
