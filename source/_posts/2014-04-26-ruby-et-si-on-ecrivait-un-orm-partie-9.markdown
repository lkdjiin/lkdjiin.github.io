---
layout: post
title: "Ruby - Et si on écrivait un ORM ? - partie 9"
date: 2014-04-26 14:23
comments: true
categories: [ruby, intermédiaire, orm, base de données, sqlite, sorm]
---

{% level 2 %}

Encore du refactoring, cette fois ci dans la classe `Base`. Regardons le
code suivant:

``` ruby
  class Base
    def self.sql(raw_query)
      Database.connection.execute(raw_query)
    end
```

Le `Database.connection.execute` me dérange. Il viole
[la loi de Demeter](http://fr.wikipedia.org/wiki/Loi_de_D%C3%A9m%C3%A9ter).

<!-- more -->

À bien y réfléchir, je n'ai tout simplement pas envie d'exposer la méthode
`connection`, qu'on trouve aussi un peu plus loin dans la class `Base`:

``` ruby
    def self.save(parameters)
      Recorder.new(Database.connection, self.to_s.downcase, parameters).save
      self.new(parameters)
    end
```

La classe `Database` est actuellement comme ça:

``` ruby
  class Database
    @@connection = false

    def self.connect(database_filename)
      @@connection = SQLite3::Database.open(database_filename)
    end

    def self.connected?
      !!@@connection
    end

    def self.connection
      @@connection
    end
  end
```

Je supprime purement et simplement la méthode `connection`:

``` ruby
  class Database
    @@connection = false

    def self.connect(database_filename)
      @@connection = SQLite3::Database.open(database_filename)
    end

    def self.connected?
      !!@@connection
    end
  end
```

Maintenant, on rejoue les tests, qui vont nous indiquer ce qui doit être
réécrit:

    $ rspec sorm_spec.rb 
    [...]
         NoMethodError:
           undefined method `connection' for SORM::Database:Class
         # ./sorm.rb:19:in `sql'
    [...]
         NoMethodError:
           undefined method `connection' for SORM::Database:Class
         # ./sorm.rb:23:in `save'
    [...]
    7 examples, 5 failures

On va simplement créer une méthode `Database.execute`, qui elle, pourra
utiliser l'objet `connection`:

``` ruby
  class Database
    @@connection = false

    def self.connect(database_filename)
      @@connection = SQLite3::Database.open(database_filename)
    end

    def self.connected?
      !!@@connection
    end

    def self.execute(sql)
      @@connection.execute(sql)
    end
  end

  class Base
    def self.sql(raw_query)
      Database.execute(raw_query)
    end
  # ...
```

À y regarder de près, je ne suis plus certain de trouver un intérêt à
`Base.sql`. Il faudrait la supprimer puisqu'elle peut être remplacée par
`Database.execute`. Mais il faudra attendre car il y a encore des tests qui ne
passent plus, à cause de ce code:

``` ruby
    def self.save(parameters)
      Recorder.new(Database.connection, self.to_s.downcase, parameters).save
      self.new(parameters)
    end
```

On s'en occupera la prochaine fois.

*To be continued*

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

