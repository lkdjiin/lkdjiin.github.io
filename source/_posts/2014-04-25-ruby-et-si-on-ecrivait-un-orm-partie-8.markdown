---
layout: post
title: "Ruby - Et si on écrivait un ORM ? - partie 8"
date: 2014-04-25 21:17
comments: true
categories: [ruby, intermédiaire, orm, base de données, sqlite, sorm]
---

{% level 2 %}

Je continue le refactoring de SORM. Voici la classe `Database` dans son
état actuel:

``` ruby sorm.rb
require 'sqlite3'

module SORM

  class Database
    @@db = false

    def self.connect(database_filename)
      @@db = SQLite3::Database.open(database_filename)
    end

    def self.connected?
      @@db ? true : false
    end

    def self.connection
      @@db
    end
  end

# ...
end
```

<!-- more -->

La première chose que j'ai envie de faire, c'est de supprimer l'abbréviation
`db`. De plus, comme il s'agit plutôt d'établir une *connexion*, je change
pour `connection`:

``` ruby
  class Database
    @@connection = false

    def self.connect(database_filename)
      @@connection = SQLite3::Database.open(database_filename)
    end

    def self.connected?
      @@connection ? true : false
    end

    def self.connection
      @@connection
    end
  end
```

À ce sujet, j'applique [mes propres principes](http://lkdjiin.github.io/blog/2013/08/21/code-propre-non-aux-abreviations/) ;)

Ensuite je vais modifier l'implémentation de la méthode `.connected?`. Elle
va passer de:

``` ruby
    def self.connected?
      @@db ? true : false
    end
```

À quelque chose de plus expressif:

``` ruby
    def self.connected?
      !!@@connection
    end
```

J'ai écris récemment un article sur [le double bang](http://lkdjiin.github.io/blog/2014/04/23/le-double-bang-en-ruby/) si vous vous
demandez ce que c'est ;)

La prochaine fois, on *refactorera* un peu plus la classe `Base`.

*To be continued*

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

