---
layout: post
title: "Trois-centième article aujourd'hui !"
date: 2014-05-03 21:56
legacy: true
tags: [annonce, intermédiaire, ruby, rake, documentation]
---



Aujourd'hui c'est le 300ème article de ce blog ! Voilà 300 jours que je
pond un article au quotidien. J'en reviens pas !

<!-- more -->

Encore 65 et j'aurais réussi le défi que je m'étais fixé il y a 300 jours:
écrire un article par jour pendant un an.

Bref, le contenu du jour sera : le fichier `.yardopts`. Qu'est-ce que c'est
encore que ça ?

Pour générer une documentation de vos gems Ruby avec
[Yard](http://yardoc.org/) vous écrivez peut-être comme moi une tâche Rake dans ce genre:

{% highlight ruby %}
desc 'Create documentation'
task :doc do
  exec 'yardoc --title "Titre de la doc"'
end
{% endhighlight %}

Là j'ai mis une seule option, mais on en a souvent d'autres, plus des fichiers
à inclure (comme la licence, le changelog, etc).

Et bien j'ai appris aujourd'hui que ces options pouvaient être mises dans
un fichier `.yardopts`. En reprenant l'exemple précédant, cela deviendrait:

{% highlight raw %}
--title "Titre de la doc"
{% endhighlight %}

{% highlight ruby %}
desc 'Create documentation'
task :doc do
  exec 'yardoc'
end
{% endhighlight %}

Non seulement ça évite de surcharger la tâche rake avec des informations
inutiles, mais surtout, ça permet à des service externes comme
[RubyDoc](http://www.rubydoc.info/) de savoir exactement ce que vous voulez.



À demain.



