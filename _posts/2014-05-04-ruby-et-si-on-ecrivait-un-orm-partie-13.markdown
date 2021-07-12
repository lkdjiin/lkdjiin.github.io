---
layout: post
title: "Ruby - Et si on écrivait un ORM ? - partie 13"
date: 2014-05-04 21:09
legacy: true
tags: [ruby, intermédiaire, orm, base de données, sqlite, sorm]
---



Aujourd'hui on termine de structurer quelque peu le projet. Voici ce que je
veux obtenir:

    $ tree -a
    .
    ├── lib/
    │   ├── base.rb
    │   ├── database.rb
    │   └── recorder.rb
    ├── .rspec
    ├── sorm.rb
    ├── spec/
    │   ├── base_spec.rb
    │   └── database_spec.rb
    └── test.db

<!-- more -->

Le fichier `sorm.rb` à la racine du projet va contenir nos require:

{% highlight ruby %}
require 'sqlite3'
require './lib/database'
require './lib/base'
require './lib/recorder'
{% endhighlight %}

Quant aux 3 fichiers sous `lib/` ils contiennent chacun une classe
de notre ancien fichier `sorm.rb`, qui était un fourre-tout.
Voici ces fichiers:

{% highlight ruby %}
module SORM
  class Base
    def self.save(parameters)
      Recorder.new(self.to_s.downcase, parameters).save
      self.new(parameters)
    end

    def initialize(attributes)
      attributes.each do |name, value|
        instance_variable_set("@#{name}", value)
        singleton_class.class_eval{attr_reader name.to_sym}
      end
    end
  end
end
{% endhighlight %}

{% highlight ruby %}
module SORM
  class Database
    @@connection = false

    def self.connect(database_filename)
      @@connection = SQLite3::Database.open(database_filename)
    end

    def self.disconnect
      @@connection = false
    end

    def self.connected?
      !!@@connection
    end

    def self.execute(sql)
      @@connection.execute(sql)
    end
  end
end
{% endhighlight %}

{% highlight ruby %}
module SORM
  class Recorder
    def initialize(table, parameters)
      @table = table
      @parameters = parameters
    end

    def save
      Database.execute(query)
    end

    def query
      "INSERT INTO #@table (#{columns}) VALUES(#{values});"
    end

    def columns
      @parameters.keys.join(',')
    end

    def values
      @parameters.values.map do |item|
        item.class == String ? "'#{item}'" : item
      end.join(',')
    end
  end
end
{% endhighlight %}

On va enfin pouvoir ajouter de nouvelles fonctionnalités à notre ORM !
C'est pas trop tôt, je commençais à m'ennuyer ;)

Je tâcherais aussi de mettre le projet sur Github prochainement pour
qu'il soit plus facile à suivre.

*To be continued*



À demain.



