---
layout: post
title: "Astuce Ruby - Utiliser les variables d'environnement"
date: 2014-02-07 20:47
comments: true
categories: [ruby, débutant, astuce, environnement]
---

{% level 1 %}

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

``` irb
$ MYVAR=1 irb
>> p ENV['MYVAR']
"1"
>> exit
```

La syntaxe suivante crée une variable d'environnement avec une chaîne
vide:

``` irb
$ MYVAR= irb
>> p ENV['MYVAR']
""
```

Une variable d'environnement inexistante renverra `nil`:

``` irb
$ irb
>> ENV['MYVAR']
nil
```

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

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

