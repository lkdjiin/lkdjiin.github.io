---
layout: post
title: "Astuce Ruby - Utiliser les variables d'environnement"
date: 2014-02-07 20:47
legacy: true
tags: [ruby, débutant, astuce, environnement]
---



Pour un projet en cours, je dois accéder à une variable d'environnement
passée par la ligne de commande. Voici comment faire, et pourquoi le
faire.

<!-- more -->

Comment faire ?
-------

Dans Ruby, on accède aux variables d'environnement à l'aide
du hash `ENV`. Pour créer une variable d'environnement qui ne sera
connue que de votre programme, il faut
l'affecter avant la commande:

{% highlight irb %}
$ MYVAR=1 irb
>> p ENV['MYVAR']
"1"
>> exit
{% endhighlight %}

La syntaxe suivante crée une variable d'environnement avec une chaîne
vide:

{% highlight irb %}
$ MYVAR= irb
>> p ENV['MYVAR']
""
{% endhighlight %}

Une variable d'environnement inexistante renverra `nil`:

{% highlight irb %}
$ irb
>> ENV['MYVAR']
nil
{% endhighlight %}

Pourquoi faire ?
--------

Pour prendre des décisions qui ne sont connues
qu'au lancement du programme, on se sert normalement des options en
ligne de commande, du genre:

    $ foo -a --bar

Mais quand un programme A est lancé par un autre programme B, ou
bien par le
déclenchement du programme B, on n'a pas forcement la possibilité
d'ajouter des options au programme A. Dans ce cas les variables
d'environnement sont une solution.



À demain.



