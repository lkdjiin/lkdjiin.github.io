---
layout: post
title: "Rechercher avec grep dans un fichier compressé"
date: 2014-05-22 21:10
legacy: true
tags: [débutant, astuce, ligne de commande]
---



Il vous arrive peut-être parfois d'avoir à fouiller des fichiers de log ?
Vous utiliser `grep` pour ça ? Et comment faire quand les logs sont
compressés ?

<!-- more -->

Lorsque le log est normal, c'est à dire non-compressé, on peut utiliser la
commande `grep` suivante:

{% highlight bash %}
$ grep --color 'LOWER' test.log
  User Exists (0.8ms)  SELECT 1 AS one FROM "users" WHERE LOWER("users"."email")   = LOWER('foo@example.com') LIMIT 1
{% endhighlight %}

Elle va afficher toutes les lignes du fichier `test.log` qui contiennent le
mot `LOWER`.

Mais si on fait la même chose sur un log compressé:

{% highlight bash %}
$ grep --color 'LOWER' test.log.1.gz
$ 1
{% endhighlight %}

Ça ne fonctionne pas. Ci-dessus, le `$ 1`, c'est mon shell qui m'affiche
une erreur sous la forme du code de retour (une idée pour un futur article).

Pour chercher dans un fichier compressé avec `grep`, on peut utiliser très
simplement la commande `zgrep`:

{% highlight bash %}
$ zgrep --color 'LOWER' test.log.1.gz
  User Exists (0.8ms)  SELECT 1 AS one FROM "users" WHERE LOWER("users"."email")   = LOWER('foo@example.com') LIMIT 1
{% endhighlight %}

Et voilà.



À demain.



