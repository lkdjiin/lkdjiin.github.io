---
layout: post
title: "Ruby - Et si on écrivait un ORM ? - partie 7"
date: 2014-04-24 21:01
comments: true
categories: [ruby, intermédiaire, orm, base de données, sqlite]
---

{% level 2 %}

Seconde partie du refactoring de SORM, mon *toy ORM* qui me sert de
prétexte pour quelques articles ;)

<!-- more -->

Parce que j'espère que vous avez compris que je n'était pas sérieusement
en train d'écrire un nouvel ORM pour Ruby, hein ? C'est juste pour étudier
un peu ensemble comment ça fonctionne…

Bref, il est temps je pense d'utiliser quelques namespace. `SORM::Database`
pour gérer la connexion et `SORM::Base` comme modèle de base. Voici donc les
tests remaniés:

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
      Article.sql("INSERT INTO article VALUES(1, 'Foo');")
      Article.sql("INSERT INTO article VALUES(2, 'Bar');")
    end

    after do
      Article.sql("DELETE FROM article;")
    end

    it 'returns the correct number of rows' do
      rows = Article.sql("SELECT * FROM article;")
      expect(rows.size).to eq 2
    end

    it 'returns correct values' do
      rows = Article.sql("SELECT * FROM article;")
      expect(rows[0][0]).to eq 1
      expect(rows[0][1]).to eq 'Foo'
      expect(rows[1][0]).to eq 2
      expect(rows[1][1]).to eq 'Bar'
    end
  end

  describe 'object creation' do
    after { Article.sql("DELETE FROM article;") }

    it 'creates a record' do
      Article.save(id: 1, name: 'bépo')
      rows = Article.sql("SELECT * FROM article WHERE id = 1;")
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

Et bien sûr la nouvelle implémentation qui va avec:

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

  class Base
    def self.sql(raw_query)
      Database.connection.execute(raw_query)
    end

    def self.save(parameters)
      Recorder.new(Database.connection, self.to_s.downcase, parameters).save
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
end
```

Voilà, ça fait pas mal de code sans explication :( mais j'ai peu de temps
aujourd'hui. La prochaine on fera… je sais pas… on verra bien ;)

*To be continued*

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

