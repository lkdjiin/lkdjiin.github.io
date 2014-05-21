---
layout: post
title: "Utiliser une version particulière d'une gem Ruby... dans une gem"
date: 2014-05-21 20:48
comments: true
categories: [débutant, ruby, gem]
---

{% level 1 %}

On connait tous le moyen d'utiliser une gem d'une version précise dans un
projet Rails. Il suffit de mettre ceci dans le Gemfile:

``` ruby Gemfile
gem 'foo', '=1.2.3'
```

Et hop, Rails, avec son coté *magique*, fait automatiquement le `require`
nécéssaire pour charger la gem `foo`, avec la version `1.2.3`.
Mais qu'en est-il lorsqu'on veut faire la même chose dans une gem, ou bien
dans un simple script ?

<!-- more -->

Si j'écris un article sur ce sujet c'est parce que j'oublie régulièrement
comment faire. Et qu'à chaque fois je dois perdre quelques minutes à chercher.
En l'écrivant une fois pour toutes, j'éspère que ça va rentrer ;)

La solution est évidemment très simple, on écrit ce qui suit dans son script:

``` ruby
gem 'foo', '=1.2.3'
require 'foo'
```

Et voilà.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

