---
layout: post
title: "Programmation concurrente pour Ruby avec eldritch - partie 2"
date: 2014-05-07 19:18
legacy: true
tags: [ruby, concurrence, parallèlisisme, intermédiaire]
---



Suite du test de la gem [eldritch](https://github.com/beraboris/eldritch)
qui facilite la programmation concurrente en Ruby.

<!-- more -->

Prenons le programme de référence suivant:

{% highlight ruby %}
def long_task
  sleep(1)
  Time.now
end

10.times do |i|
  puts "#{i} : #{long_task}"
end
{% endhighlight %}

La méthode `long_task` va *dormir* pendant une seconde puis renvoyer la
date courante. Si on l'appelle 10 fois de suite, voici la sortie:

    $ time ruby test.rb
    0 : 2014-05-07 18:15:52 +0200
    1 : 2014-05-07 18:15:53 +0200
    2 : 2014-05-07 18:15:54 +0200
    3 : 2014-05-07 18:15:55 +0200
    4 : 2014-05-07 18:15:56 +0200
    5 : 2014-05-07 18:15:57 +0200
    6 : 2014-05-07 18:15:58 +0200
    7 : 2014-05-07 18:15:59 +0200
    8 : 2014-05-07 18:16:00 +0200
    9 : 2014-05-07 18:16:01 +0200

    real	0m10.809s

Un appel par seconde, normal.

Maintenant on va se servir de **eldritch** pour que les 10 appels à
`long_task` soient concurrents:

{% highlight ruby %}
require 'eldritch'

def long_task
  sleep(1)
  Time.now
end

together do
  10.times do |i|
    async do
      puts "#{i} : #{long_task}"
    end
  end
end
{% endhighlight %}

Le bloc `together` permet au programme d'attendre que chacune des *tâches*
soient terminées avant d'aller plus loin. Voici ce que ça donne:

    $ time ruby test.rb
    0 : 2014-05-07 18:16:52 +02002 : 2014-05-07 18:16:52 +0200

    3 : 2014-05-07 18:16:52 +0200
    4 : 2014-05-07 18:16:52 +0200
    5 : 2014-05-07 18:16:52 +0200
    6 : 2014-05-07 18:16:52 +0200
    7 : 2014-05-07 18:16:52 +0200
    8 : 2014-05-07 18:16:52 +0200
    9 : 2014-05-07 18:16:52 +0200
    1 : 2014-05-07 18:16:52 +0200

    real	0m1.890s

Que nous apprend cette sortie ? Chacune des dix tâches a été démarrée à la
même seconde (pas en même temps exactement bien sûr). On voit bien aussi
que l'ordre de terminaison des 10 tâches est aléatoires, ce qui est normal
en programmation concurrente. Le programme s'est terminé 10 fois plus vite,
c'est normal puisque `long_task` passe son temps à ne rien faire ;)

À quoi sert exactement ce bloc `together` ? Voyons ce qu'il se passe si on le
retire:

{% highlight ruby %}
require 'eldritch'

def long_task
  sleep(1)
  Time.now
end

10.times do |i|
  async do
    puts "#{i} : #{long_task}"
  end
end
{% endhighlight %}

    $ time ruby test.rb

    real	0m0.846s

Oups ! Le programme s'est terminé *avant* la fin des tâches, elles sont
perdues !

Une autre façon de faire est de créer *explicitement* une tâche, avec
`task = async do ...` et d'utiliser `task.value` qui attend que la tâche
soit complètée:

{% highlight ruby %}
require 'eldritch'

long_task = async do
  sleep(1)
  Time.now
end

10.times do |i|
  puts "#{i} : #{long_task.value}"
end
{% endhighlight %}

    $ time ruby eldritch2.rb
    0 : 2014-05-07 18:38:20 +0200
    1 : 2014-05-07 18:38:20 +0200
    2 : 2014-05-07 18:38:20 +0200
    3 : 2014-05-07 18:38:20 +0200
    4 : 2014-05-07 18:38:20 +0200
    5 : 2014-05-07 18:38:20 +0200
    6 : 2014-05-07 18:38:20 +0200
    7 : 2014-05-07 18:38:20 +0200
    8 : 2014-05-07 18:38:20 +0200
    9 : 2014-05-07 18:38:20 +0200

    real	0m1.861s

Tout les tests que j'ai fait avec cette méthode montrent que l'ordre des
tâches est respecté, de 0 à 9. Est-ce que c'est vraiment le cas ou bien
est-ce une coincidence ? Je n'ai pas encore de réponses…

Quoiqu'il en soit, je suis pressé d'essayer **eldritch** avec les algorithmes génétiques, ce
qui par la même occasion me permettra d'en reparler (des algos) dans ce blog.



À demain.




