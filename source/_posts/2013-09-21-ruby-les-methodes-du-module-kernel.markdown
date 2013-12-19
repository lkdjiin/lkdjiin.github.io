---
layout: post
title: "Ruby: Les méthodes du module Kernel"
date: 2013-09-21 13:53
comments: true
categories: [ruby, débutant, kernel]
---

{% level 1 %}

Les méthodes définies dans le module Kernel de Ruby sont *à priori* des
méthodes très importantes. En effet le module Kernel est inclus d'office
dans la classe Object, et donc, ses méthodes sont toujours disponibles.
Elles s'utilisent directement sous la forme `method_name` et non pas
`object_name.method_name`. C'est cette différence de traitement qui
me donne à penser qu'elles sont importantes. Dans cette série d'articles,
je me propose de passer en revue chacune des méthodes du module Kernel
de Ruby version 2.0.

<!-- more -->

Aujourd'hui on voit les méthodes suivantes:

* Array(*arg*)
* Hash(*arg*)
* String(*arg*)

Ce sont toutes les trois des méthodes de conversions. Elles transforment
respectivement l'argument en un type Array, Hash ou String. Pour effectuer
cette conversion elles utilisent la méthode `to_*` sur l'argument. Par
exemple `String(self)` utilise `self.to_s`:

``` irb
[~]⇒ irb
>> String(self)
"main"
>> self.to_s
"main
```

La particularité de ces méthodes est que leur nom débutent par une majuscule,
ce qui va à l'encontre des conventions en Ruby et les fait ressembler un
peu comme à un constructeur en Java et consorts. D'un autre coté, le langage
n'empêche pas de nommer les méthodes ainsi:

``` irb
>> def Foo(arg)
>>   puts arg
>> end
nil
>> Foo("hello")
hello
nil
```

J'imagine que si ces méthodes débutent par une majuscule, c'est pour
permettre aux développeurs d'utiliser `array`, `hash` et `string` comme
nom de variable. Par contre je n'arrive pas à trouver une utilité à
ces méthodes… Je veux dire pourquoi utiliser `String(arg)` plutôt que
`arg.to_s` ?

Si toi, Lecteur, tu as une réponse, n'hésite pas à laisser un commentaire ;-)



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

