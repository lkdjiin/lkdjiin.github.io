---
layout: post
title: "Programmation concurrente pour Ruby avec eldritch"
date: 2014-05-06 21:38
comments: true
categories: [ruby, concurrence, parallèlisisme, intermédiaire]
---

{% level 2 %}

Ce matin j'ai découvert la gem [eldritch](https://github.com/beraboris/eldritch),
pour faire de la programmation concurrente. Son API m'a paru vraiment
simple et élégante. Ce soir j'ai seulement 5 minutes pour faire un premier
test, alors on y va sans fioritures.

<!-- more -->

Tout d'abord, je vais utiliser Rubinius, puisqu'un ruby MRI ne permet pas
l'utilisation de plusieurs coeurs.

    $ rvm use rbx-2.0.0
    Using /home/xavier/.rvm/gems/rbx-2.0.0

Ensuite, installation de la gem:

    gem install eldritch

Il me faut un programme simple pour tester rapidement. Le voici:

``` ruby eldritch.rb
def long_method1
  sleep(2)
  "1"
end

def long_method2
  sleep(2)
  "2"
end

puts long_method1
puts long_method2
```

Je simule deux méthodes assez longues grâce à `sleep(2)`, qui *endort* le
programme pendant 2 secondes. Le temps d'exécution est conforme à mes
attentes:

    $ time ruby eldritch.rb
    1
    2

    real	0m4.821s

Maintenant on va utiliser la gem eldritch et son concept de **tâche** pour
réécrire le programme:

``` ruby eldritch.rb
require 'eldritch'

long_task1 = async do
  sleep(2)
  "1"
end

long_task2 = async do
  sleep(2)
  "2"
end

puts long_task1.value
puts long_task2.value
```

Et voici le résultat:

    $ time ruby eldritch.rb
    1
    2

    real	0m2.869s

**Tada !** Mes deux *tâches* ont tournées en parallèle.

Ça me plait ce concept de tâche. Mais ce n'était qu'un premier test
rapide, eldritch nous réserve encore de bonne surprises. J'espère pouvoir
tester le reste demain.

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}


