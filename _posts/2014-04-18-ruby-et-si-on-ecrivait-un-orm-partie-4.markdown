---
layout: post
title: "Ruby - Et si on écrivait un ORM ? - partie 4"
date: 2014-04-18 21:01
legacy: true
tags: [ruby, intermédiaire, orm, base de données]
---



Maintenant qu'on peut se connecter à une base sqlite, je pense qu'il faut
qu'on puisse écrire des requêtes en pur SQL à partir d'un objet qui
hérite de SORM.

<!-- more -->

Voilà donc mon nouveau test:

{% highlight ruby %}
require './sorm'

describe SORM do
  describe 'connection' do
    # ...

    describe 'after connection' do
      # ...
    end
  end

  class Article < SORM
  end

  describe '.sql' do
    it 'executes raw sql query on a table' do
      Article.sql("INSERT INTO article VALUES(1, 'Foo');")
      Article.sql("INSERT INTO article VALUES(2, 'Bar');")
      rows = Article.sql("SELECT * FROM article;")
      expect(rows.size).to eq 2
    end
  end
end
{% endhighlight %}

Je veux enregistrer deux lignes en base et les récupérer. Si on lance les
tests, Rspec se plaint que la méthode `sql` n'existe pas. Jusqu'ici tout
va bien:

    $ rspec sorm_spec.rb 
    ..F

    Failures:

      1) SORM.sql executes raw sql query on a table
         Failure/Error: Article.sql("INSERT INTO article VALUES(1, 'Foo');")
         NoMethodError:
           undefined method `sql' for Article:Class

Pour faire passer ce test, le code est simple, on ajoute la méthode `sql`:

{% highlight ruby %}
require 'sqlite3'

class SORM

  @@db = false

  def self.connect(database_filename)
    @@db = SQLite3::Database.open(database_filename)
  end

  def self.connected?
    @@db ? true : false
  end

  def self.sql(raw_query)
    @@db.execute(raw_query)
  end
end
{% endhighlight %}

Et hop:

    $ rspec sorm_spec.rb 
    ...

    Finished in 0.01381 seconds
    3 examples, 0 failures

Comme je suis curieux, j'ai envie de voir à quoi ressemble le contenu de
`rows` dans le test:

{% highlight ruby %}
  describe '.sql' do
    it 'executes raw sql query on a table' do
      Article.sql("INSERT INTO article VALUES(1, 'Foo');")
      Article.sql("INSERT INTO article VALUES(2, 'Bar');")
      rows = Article.sql("SELECT * FROM article;")
      p rows
      expect(rows.size).to eq 2
    end
  end
{% endhighlight %}

Et là, une petite surprise m'attend au tournant:

    $ rspec sorm_spec.rb 
    ..[[1, "Foo"], [2, "Bar"], [1, "Foo"], [2, "Bar"]]
    F

    Failures:

      1) SORM.sql executes raw sql query on a table
         Failure/Error: expect(rows.size).to eq 2
           
           expected: 2
                got: 4
           
           (compared using ==)
         # ./sorm_spec.rb:26:in `block (3 levels) in <top (required)>'

Tout d'abord, j'ai oublié de vider la table après le test qui fait des
insertions. Et ensuite j'ai négligé de spécifier `id` comme clé primaire !
Bref, j'ai encore du boulot pour que SORM fonctionne ;)

*To be continued*



À demain.



