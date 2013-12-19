---
layout: post
title: "Couverture de code pour Ruby avec coco"
date: 2013-10-26 18:07
comments: true
categories: [ruby, annonce, coco, test, couverture de code]
---

Il y a 3 ans, j'ai écrit une gem Ruby pour faire de la couverture de
code (*code coverage*). [SimpleCov](https://github.com/colszowka/simplecov),
la gem la plus utilisée pour cette tâche venait tout juste de voir le
jour et ne me convenait pas entièrement. À l'époque je trouvais SimpleCov
trop ennuyeuse à configurer et à faire fonctionner.

<!-- more -->

Qu'on ne me fasse pas dire ce que je n'ai pas écrit : SimpleCov remplie
*parfaitement* sa tâche. C'est juste que je voulais un truc plus simple.
Je voulais quelque chose qui fonctionne en une ligne, avec configuration
optionnelle et surtout, avec un rapport de couverture
super simple et dépouillé. C'est comme ça qu'est née la gem
[coco](https://github.com/lkdjiin/coco). Bon ok, il m'est arrivé de me
demander si je ne l'avais pas écrit juste pour le jeu de mot…

Pour utiliser coco, il suffit de charger la gem au tout début des tests
comme ceci:

``` ruby
require 'coco'
```

Et… c'est tout ! Chaque fois que vous lancerez les tests, coco produira un
rapport si (et seulement si) au moins un fichier n'est pas couvert à 100%.

La configuration, au besoin, se fait dans un fichier caché au format yaml,
à la racine du projet. Par exemple si vous trouvez qu'un taux de couverture
de 90% est acceptable, vous pouvez le changer comme ça:

    :threshold: 90

Si vous voulez exclure un fichier et un dossier complet du rapport vous
pouvez écrire:

    :excludes:
    - lib/project/file1.rb
    - config/initializers

Il y a plusieurs autres exemples de configuration sur le
[wiki du projet](https://github.com/lkdjiin/coco/wiki). Enfin, pour une
présentation rapide de coco, en anglais, il y a le
[site web](http://lkdjiin.github.io/coco/).



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

