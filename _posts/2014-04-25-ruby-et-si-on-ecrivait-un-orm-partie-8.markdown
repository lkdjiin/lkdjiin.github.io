---
layout: post
title: "Ruby - Et si on écrivait un ORM ? - partie 8"
date: 2014-04-25 21:17
legacy: true
tags: [ruby, intermédiaire, orm, base de données, sqlite, sorm]
---



Je continue le refactoring de SORM. Voici la classe `Database` dans son
état actuel:

{% highlight ruby %}
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
{% endhighlight %}

<!-- more -->

La première chose que j'ai envie de faire, c'est de supprimer l'abbréviation
`db`. De plus, comme il s'agit plutôt d'établir une *connexion*, je change
pour `connection`:

{% highlight ruby %}
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
{% endhighlight %}

À ce sujet, j'applique [mes propres principes](http://lkdjiin.github.io/blog/2013/08/21/code-propre-non-aux-abreviations/) ;)

Ensuite je vais modifier l'implémentation de la méthode `.connected?`. Elle
va passer de:

{% highlight ruby %}
    def self.connected?
      @@db ? true : false
    end
{% endhighlight %}

À quelque chose de plus expressif:

{% highlight ruby %}
    def self.connected?
      !!@@connection
    end
{% endhighlight %}

J'ai écris récemment un article sur [le double bang](http://lkdjiin.github.io/blog/2014/04/23/le-double-bang-en-ruby/) si vous vous
demandez ce que c'est ;)

La prochaine fois, on *refactorera* un peu plus la classe `Base`.

*To be continued*



À demain.



