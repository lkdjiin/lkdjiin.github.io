---
layout: post
title: "Utiliser une version particulière d'une gem Ruby... dans une gem"
date: 2014-05-21 20:48
legacy: true
tags: [débutant, ruby, gem]
---



On connait tous le moyen d'utiliser une gem d'une version précise dans un
projet Rails. Il suffit de mettre ceci dans le Gemfile:

{% highlight ruby %}
gem 'foo', '=1.2.3'
{% endhighlight %}

Et hop, Rails, avec son coté *magique*, fait automatiquement le `require`
nécéssaire pour charger la gem `foo`, avec la version `1.2.3`.
Mais qu'en est-il lorsqu'on veut faire la même chose dans une gem, ou bien
dans un simple script ?

<!-- more -->

Si j'écris un article sur ce sujet c'est parce que j'oublie régulièrement
comment faire. Et qu'à chaque fois je dois perdre quelques minutes à chercher.
En l'écrivant une fois pour toutes, j'éspère que ça va rentrer ;)

La solution est évidemment très simple, on écrit ce qui suit dans son script:

{% highlight ruby %}
gem 'foo', '=1.2.3'
require 'foo'
{% endhighlight %}

Et voilà.



À demain.



