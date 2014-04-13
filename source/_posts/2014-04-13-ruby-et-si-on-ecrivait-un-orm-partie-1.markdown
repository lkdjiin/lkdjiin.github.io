---
layout: post
title: "Ruby - Et si on écrivait un ORM ? - partie 1"
date: 2014-04-13 21:29
comments: true
categories: [ruby, intermédiaire, orm, base de données]
---

{% level 2 %}

Les derniers articles sur la méta programmation m'ont donnés envie d'écrire
un [ORM](http://fr.wikipedia.org/wiki/Mapping_objet-relationnel).
Un truc simple, basé sur la base de données [Sqlite](https://www.sqlite.org/sqlite.html).
D'ailleurs on va l'appeller SORM, pour *Simple Object Relational Mapping* ;)

<!-- more -->

Dans ce premier article, on va prendre contact avec Sqlite. Une fois ce dernier
installé sur votre machine, le client console est `sqlite3`.
Pour créer une nouvelle base de données, `test1.db`, il suffit de:

    $ sqlite3 test1.db
    Enter SQL statements terminated with a ";"

Pour créer une table article:

    sqlite> create table article(id int, name varchar(100));

Pour enregistrer quelques articles:

    sqlite> insert into article values(1, 'foo');
    sqlite> insert into article values(2, 'bar');
    sqlite> insert into article values(3, 'baz');

Pour faire une requête:

    sqlite> select * from article;
    1|foo
    2|bar
    3|baz

Enfin pour sortir du programme, tapez Control+D.

Passons maintenant à la partie Ruby. J'avais pensé dans un premier temps à
écrire le driver pour communiquer avec Sqlite, mais ça nous entrainerait trop
loin. On va donc utiliser la gem [sqlite3-ruby](https://github.com/sparklemotion/sqlite3-ruby):

    gem install sqlite3

L'utilisation est fort simple:

``` irb
$ irb
>> require 'sqlite3'
>> db = SQLite3::Database.open "test1.db"
>> db.execute 'select * from article;'
[[1, "foo"], [2, "bar"], [3, "baz"]]
```

*To be continued*

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

