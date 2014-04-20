---
layout: post
title: "Ruby - Et si on écrivait un ORM ? - partie 6"
date: 2014-04-20 12:53
comments: true
categories: [ruby, intermédiaire, orm, base de données, sqlite]
---

{% level 2 %}

Hier je m'étais arrêté sur cette implémentation de `SORM.save`:

``` ruby
  def self.save(parameters)
    table = self.to_s.downcase
    columns = parameters.keys.join(',')
    values = parameters.values.map do |item|
      item.class == String ? "'#{item}'" : item
    end.join(',')
    query = "INSERT INTO #{table} (#{columns}) VALUES(#{values});"
    @@db.execute(query)
  end
```

Cette méthode est déja bien trop longue selon mes critères, et si on ne fait
pas quelque chose tout de suite on va vite se retrouver avec un tas de
méthodes de classe impossibles à remanier.

<!-- more -->

Une première partie du refactoring va consister à extraire une classe que
je vais nommer `Recorder`:

``` ruby
  def self.save(parameters)
    recorder = Recorder.new(@@db, self.to_s.downcase, parameters)
    recorder.save
  end

  class Recorder
    def initialize(connection, table, parameters)
      @connection = connection
      @table = table
      @parameters = parameters
    end

    def save
      @connection.execute(query)
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
```

Ça permet d'avoir des méthodes simples, faciles à comprendre.

Une seconde partie du refactoring consistera à *namespacer* correctement
les différentes parties de SORM. Pour ça il faudra aussi modifier les tests.

*To be continued*

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

