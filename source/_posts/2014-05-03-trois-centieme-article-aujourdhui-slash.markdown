---
layout: post
title: "Trois-centième article aujourd'hui !"
date: 2014-05-03 21:56
comments: true
categories: [annonce, intermédiaire, ruby, rake, documentation]
---

{% level 2 %}

Aujourd'hui c'est le 300ème article de ce blog ! Voilà 300 jours que je
pond un article au quotidien. J'en reviens pas !

<!-- more -->

Encore 65 et j'aurais réussi le défi que je m'étais fixé il y a 300 jours:
écrire un article par jour pendant un an.

Bref, le contenu du jour sera : le fichier `.yardopts`. Qu'est-ce que c'est
encore que ça ?

Pour générer une documentation de vos gems Ruby avec
[Yard](http://yardoc.org/) vous écrivez peut-être comme moi une tâche Rake dans ce genre:

``` ruby
desc 'Create documentation'
task :doc do
  exec 'yardoc --title "Titre de la doc"'
end
```

Là j'ai mis une seule option, mais on en a souvent d'autres, plus des fichiers
à inclure (comme la licence, le changelog, etc).

Et bien j'ai appris aujourd'hui que ces options pouvaient être mises dans
un fichier `.yardopts`. En reprenant l'exemple précédant, cela deviendrait:

``` raw .yardopts
--title "Titre de la doc"
```

``` ruby
desc 'Create documentation'
task :doc do
  exec 'yardoc'
end
```

Non seulement ça évite de surcharger la tâche rake avec des informations
inutiles, mais surtout, ça permet à des service externes comme
[RubyDoc](http://www.rubydoc.info/) de savoir exactement ce que vous voulez.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

