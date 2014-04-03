---
layout: post
title: "ActiveRecord - Voir la requête SQL pendant l'écriture des tests"
date: 2014-04-03 20:58
comments: true
categories: [ruby, débutant, activerecord, sql]
---

{% level 1 %}

Cet après-midi, avec un collègue, on écrivait des tests pour une requête
en base de données avec ActiveRecord. Et on a eu besoin d'étudier le
code SQL qui était généré.

<!-- more -->

On aurait pu lancer une console et jouer avec ActiveRecord dedans, mais
le setup nécessaire pour accéder à l'objet sur lequel on travaillait est
assez long à mettre en place. On voulait plutôt faire rapidement:

1. On bidouille la requête ActiveRecord.
2. On lance le test.
3. On examine le code SQL.
4. On recommence tant que ça ne nous convient pas.

Pour ça, placez la ligne suivante dans votre fichier de test et le tour
est joué.

``` ruby
ActiveRecord::Base.logger = Logger.new(STDOUT)
```

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
