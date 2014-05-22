---
layout: post
title: "Rechercher avec grep dans un fichier compressé"
date: 2014-05-22 21:10
comments: true
categories: [débutant, astuce, ligne de commande]
---

{% level 1 %}

Il vous arrive peut-être parfois d'avoir à fouiller des fichiers de log ?
Vous utiliser `grep` pour ça ? Et comment faire quand les logs sont
compressés ?

<!-- more -->

Lorsque le log est normal, c'est à dire non-compressé, on peut utiliser la
commande `grep` suivante:

``` bash
$ grep --color 'LOWER' test.log
  User Exists (0.8ms)  SELECT 1 AS one FROM "users" WHERE LOWER("users"."email")   = LOWER('foo@example.com') LIMIT 1
```

Elle va afficher toutes les lignes du fichier `test.log` qui contiennent le
mot `LOWER`.

Mais si on fait la même chose sur un log compressé:

``` bash
$ grep --color 'LOWER' test.log.1.gz
$ 1
```

Ça ne fonctionne pas. Ci-dessus, le `$ 1`, c'est mon shell qui m'affiche
une erreur sous la forme du code de retour (une idée pour un futur article).

Pour chercher dans un fichier compressé avec `grep`, on peut utiliser très
simplement la commande `zgrep`:

``` bash
$ zgrep --color 'LOWER' test.log.1.gz
  User Exists (0.8ms)  SELECT 1 AS one FROM "users" WHERE LOWER("users"."email")   = LOWER('foo@example.com') LIMIT 1
```

Et voilà.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

