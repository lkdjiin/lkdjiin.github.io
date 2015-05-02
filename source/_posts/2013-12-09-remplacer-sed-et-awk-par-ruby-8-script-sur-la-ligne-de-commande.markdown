---
layout: post
title: "Remplacer Sed et Awk par Ruby 8: Script sur la ligne de commande"
date: 2013-12-09 20:36
comments: true
categories: [sed, awk, ruby, débutant, one liner]
---

{% level 1 %}

Il est temps de se passer d'un fichier pour notre script… Lorsque celui-ci
est suffisament court, on peut l'écrire directement sur la ligne de
commande.

<!-- more -->

Si on reprend l'exemple tout simple du [dernier article](http://lkdjiin.github.io/blog/2013/12/08/remplacer-sed-et-awk-par-ruby-7-modifier-slash-sauvegarder-les-donnees/),
nous avions le fichier de données suivant à transformer *en place* en
majuscule:

``` raw data.txt
alice
bob
```

Ce qu'on a fait à l'aide du script suivant:

``` ruby test.rb
$_.upcase!
```

Autrement une seule ligne ! Est-ce que ça vaut vraiment la peine d'écrire
un fichier pour ça ? Bien sûr que non. On va donc se passer du fichier
script en donnant le code sur la ligne de commande grâce à l'option `-e`:

``` bash
ruby -p -i.2 -e '$_.upcase!' data.txt
```

Et voilà, vous êtes maintenant prêts à écrire des *one liners*. Notez
quand même qu'il vaut mieux utiliser les guillemets simples (`'`) autour
du code plutôt que les doubles (`"`), pour empêcher Bash d'interpréter
certains caractères (comme ici le `!`).



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
