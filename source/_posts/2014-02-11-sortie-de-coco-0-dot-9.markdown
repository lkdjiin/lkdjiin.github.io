---
layout: post
title: "Sortie de coco 0.9"
date: 2014-02-11 20:40
comments: true
categories: [annonce, couverture de code, gem, ruby]
---

La version 0.9 de la gem coco est sortie il y a quelques jours.
Coco est une bibliothèque de couverture de code (code coverage) pour
Ruby de 1.9.2 à 2.1.

<!-- more -->

Cette nouvelle version ajoute une option de configuration qui permet
de dire à *coco* quand démarrer, ou quand ne pas démarrer.

Pour les projets où la suite de tests met beaucoup de temps à tourner,
on fini souvent par jouer un seul test quand on développe, et la suite
entière seulement avant de commiter et/ou pusher. Dans ce cas, le
comportement de *coco* pouvait être assez agaçant puisque la gem
reportait une longue liste de fichiers non-couverts. Maintenant c'est
arrangé, mettez ceci dans votre fichier de configuration:

    :always_run: false

Lorsque vous lancez les tests comme d'habitude (ou `rake`, ou un
seul fichier, etc):

    rspec spec/

*Coco* ne démarrera pas. Pour lui dire de faire son travail, il suffit
de définir la variable d'environnement `COCO`:

    COCO=1 rspec spec/


Vous pouvez [télécharger](https://github.com/lkdjiin/coco) coco sur Github.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
