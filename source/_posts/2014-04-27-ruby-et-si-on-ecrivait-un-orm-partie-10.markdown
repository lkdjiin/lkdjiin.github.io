---
layout: post
title: "Ruby - Et si on écrivait un ORM ? - partie 10"
date: 2014-04-27 18:07
comments: true
categories: [ruby, intermédiaire, orm, base de données, sqlite, sorm]
---

{% level 2 %}

Je continue toujours le refactoring de SORM, cette fois je veux supprimer
le paramêtre `connection` dans l'initialisation de `Recorder`:

``` ruby
  class Recorder
    def initialize(connection, table, parameters)
      @connection = connection
      @table = table
      @parameters = parameters
    end

    def save
      @connection.execute(query)
    end
```

<!-- more -->

Bon, c'est tout simple, on utilise directement la classe `Database`:

``` ruby
  class Recorder
    def initialize(table, parameters)
      @table = table
      @parameters = parameters
    end

    def save
      Database.execute(query)
    end
```

``` ruby
  class Base
    # ...

    def self.save(parameters)
      Recorder.new(self.to_s.downcase, parameters).save
      self.new(parameters)
    end
```

Ok, c'est trop court comme article, non ? Alors je continue. Comme dit la
dernière fois, la méthode `Base.sql` me semble inutile. Je la supprime donc,
ce qui conduit à ce code:

``` ruby sorm.rb
require 'sqlite3'

module SORM

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
```

Mais maintenant ce sont les tests qui sont dans les choux ! Il faut
remplacer toutes les occurences de `Article.sql` par
`SORM::Database.execute`. Ce qui donne:

``` ruby sorm_spec.rb
require './sorm'

describe SORM::Database do
  describe 'connection' do
    it 'is not connected' do
      expect(SORM::Database.connected?).to be false
    end

    describe 'after connection' do
      it 'is connected' do
        SORM::Database.connect('test.db')
        expect(SORM::Database.connected?).to be true
      end
    end
  end
end

describe SORM::Base do
  class Article < SORM::Base ; end

  describe '.sql' do
    before do
      SORM::Database.execute("INSERT INTO article VALUES(1, 'Foo');")
      SORM::Database.execute("INSERT INTO article VALUES(2, 'Bar');")
    end

    after do
      SORM::Database.execute("DELETE FROM article;")
    end

    it 'returns the correct number of rows' do
      rows = SORM::Database.execute("SELECT * FROM article;")
      expect(rows.size).to eq 2
    end

    it 'returns correct values' do
      rows = SORM::Database.execute("SELECT * FROM article;")
      expect(rows[0][0]).to eq 1
      expect(rows[0][1]).to eq 'Foo'
      expect(rows[1][0]).to eq 2
      expect(rows[1][1]).to eq 'Bar'
    end
  end

  describe 'object creation' do
    after { SORM::Database.execute("DELETE FROM article;") }

    it 'creates a record' do
      Article.save(id: 1, name: 'bépo')
      rows = SORM::Database.execute("SELECT * FROM article WHERE id = 1;")
      expect(rows[0][0]).to eq 1
      expect(rows[0][1]).to eq 'bépo'
    end

    it 'returns an object with correct class' do
      article = Article.save(id: 1, name: 'bépo')
      expect(article.class).to eq Article
    end

    it 'returns an object with correct attributes' do
      article = Article.save(id: 1, name: 'bépo')
      expect(article.id).to eq 1
      expect(article.name).to eq 'bépo'
    end
  end
end
```

Et les tests passent de nouveau. Mais on a un nouveau problème !
Le bloc `describe '.sql'` suivant est devenu ridicule:

``` ruby
describe SORM::Base do
  class Article < SORM::Base ; end

  describe '.sql' do
    before do
      SORM::Database.execute("INSERT INTO article VALUES(1, 'Foo');")
      SORM::Database.execute("INSERT INTO article VALUES(2, 'Bar');")
    end

    after do
      SORM::Database.execute("DELETE FROM article;")
    end

    it 'returns the correct number of rows' do
      rows = SORM::Database.execute("SELECT * FROM article;")
      expect(rows.size).to eq 2
    end

    it 'returns correct values' do
      rows = SORM::Database.execute("SELECT * FROM article;")
      expect(rows[0][0]).to eq 1
      expect(rows[0][1]).to eq 'Foo'
      expect(rows[1][0]).to eq 2
      expect(rows[1][1]).to eq 'Bar'
    end
  end
```

1) Il n'y a plus de méthode `sql` et 2) il teste `Database.execute` et
n'a donc rien à faire ici. Je corrigerais ça la prochaine fois, et je pense
qu'il est temps aussi de *splitter* les fichiers tests et sources…

*To be continued*

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

