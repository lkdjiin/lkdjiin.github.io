---
layout: post
title: "Ruby - Et si on écrivait un ORM ? - partie 5"
date: 2014-04-19 21:14
legacy: true
tags: [ruby, intermédiaire, orm, base de données]
---



Au menu d'aujourd'hui: réparation du test défecteux et début de la
création/insertion d'un objet.

<!-- more -->

Tout d'abord on répare le test d'hier. Je sors les appels à `INSERT` dans
un bloc `before` et j'ajoute ce qui manquait cruellement, un appel à
`DELETE` dans un bloc `after`:

{% highlight ruby %}
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
{% endhighlight %}

Voilà, maintenant on peut passer à la partie création. J'ai envie que SORM
ait une méthode `save`, qui enregistrera les données en base et
renverra un objet. On commence avec un test pour l'enregistrement:

{% highlight ruby %}
require './sorm'

describe SORM do
  describe 'connection' do
    # ...
  end

  class Article < SORM
  end

  describe '.sql' do
    # ...
  end

  describe 'object creation' do
    after { Article.sql("DELETE FROM article;") }

    it 'creates a record' do
      Article.save(id: 1, name: 'bépo')
      rows = Article.sql("SELECT * FROM article WHERE id = 1;")
      expect(rows[0][0]).to eq 1
      expect(rows[0][1]).to eq 'bépo'
    end
  end
end
{% endhighlight %}

J'écris un premier jet de la méthode `save`, pour faire passer le test:

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

  def self.save(parameters)
    table = self.to_s.downcase
    columns = parameters.keys.join(',')
    values = parameters.values.map do |item|
      item.class == String ? "'#{item}'" : item
    end.join(',')
    query = "INSERT INTO #{table} (#{columns}) VALUES(#{values});"
    @@db.execute(query)
  end
end
{% endhighlight %}

Ça fonctionne, mais la méthode est moche. Ce sera l'occasion de faire du
refactoring dans un prochain article.

*To be continued*



À demain.



