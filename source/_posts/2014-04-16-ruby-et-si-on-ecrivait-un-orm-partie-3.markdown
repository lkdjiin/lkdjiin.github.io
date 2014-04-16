---
layout: post
title: "Ruby - Et si on écrivait un ORM ? - partie 3"
date: 2014-04-16 21:23
comments: true
categories: [ruby, intermédiaire, orm, base de données]
---
{% level 2 %}

Cette fois je me dis qu'il faudrait quand même se connecter à la base de
données avant d'aller plus loin…

<!-- more -->

Alors au départ, la connexion est inexistante:

``` ruby sorm_spec.rb
require './sorm'

describe SORM do
  describe 'connection' do
    it 'is not connected' do
      expect(SORM.connected?).to be false
    end
  end
end
```

On fait passer ce test très facilement:

``` ruby sorm.rb
require 'sqlite3'

class SORM
  def self.connected?
    false
  end
end
```

Maintenant on cherche à se connecter à une base de données existante
(n'oubliez pas de la créer):

``` ruby sorm_spec.rb
require './sorm'

describe SORM do
  describe 'connection' do
    it 'is not connected' do
      expect(SORM.connected?).to be false
    end

    describe 'after connection' do
      it 'is connected' do
        SORM.connect('test.db')
        expect(SORM.connected?).to be true
      end
    end
  end
end
```

Pour implémenter cette fonctionnalité, ce à quoi je pense de plus rapide
et de plus simple est une variable de classe. Même si on a parfois des
scrupules à utiliser les variables de classe parce qu'elles sont partagées
aussi par les sous-classes, je me dis que c'est bien le comportement que
je voudrais obtenir. Donc voici le code qui fait passer notre test:

``` ruby sorm.rb
require 'sqlite3'

class SORM

  @@db = false

  def self.connect(database_filename)
    @@db = SQLite3::Database.open(database_filename)
  end

  def self.connected?
    @@db ? true : false
  end
end
```

*To be continued*

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

