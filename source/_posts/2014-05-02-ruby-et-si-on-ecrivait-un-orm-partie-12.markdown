---
layout: post
title: "Ruby - Et si on écrivait un ORM ? - partie 12"
date: 2014-05-02 20:59
comments: true
categories: [ruby, intermédiaire, orm, base de données, sqlite, sorm]
---

{% level 2 %}

Douzième partie déjà de cette série sur la construction d'un ORM en Ruby…

<!-- more -->

On doit ajouter une méthode `disconnect` à notre classe `Database`, voici
d'abord le test:

``` ruby spec/database_spec.rb
require './sorm'

describe SORM::Database do

  it 'is not connected by default' do
    expect(SORM::Database.connected?).to be false
  end

  describe 'after connection' do
    before { SORM::Database.connect('test.db') }
    after  { SORM::Database.disconnect }

    it 'is connected' do
      expect(SORM::Database.connected?).to be true
    end

    it 'is disconnected after disconnection' do
      SORM::Database.disconnect
      expect(SORM::Database.connected?).to be false
    end
  end
end
```

Et maintenant l'implémentation:

``` ruby
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
```

Rien à dire d'intéressant là-dessus. Je vais aussi configurer Rspec pour
qu'il joue les tests dans un ordre alétoire, et tant que j'y suis j'ajoute
un peu de couleur à la sortie:

``` raw .rspec
--color
--order=random
```

Et voici l'instant de vérité:

    $ rspec
    ........
    Finished in 0.03996 seconds
    8 examples, 0 failures
    Randomized with seed 55135

Parfait, on a splitté les tests, on les a mis dans un dossier `spec/`,
on les a amélioré. C'est tout bon. Maintenant on devrait pouvoir faire
facilement un truc similaire avec le fichier `sorm.rb`.

*To be continued*

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

