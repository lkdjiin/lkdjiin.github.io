---
layout: post
title: "Ruby - Et si on écrivait un ORM ? - partie 2"
date: 2014-04-14 21:08
comments: true
categories: [ruby, intermédiaire, orm, base de données]
---

{% level 2 %}

Après avoir installé sqlite et la gem sqlite3-ruby, on installe maintenant
rspec et on fait passer un premier test pour notre futur *Simple ORM*.

<!-- more -->

Pour écrire SORM, on va faire du *Test Driven Development*, parce que j'ai
envie d'encourager les bonnes pratiques ;) Pour les tests j'utiliserai
Rspec, puisque c'est le framework que je connais le mieux:

    gem install rspec

On écrit un premier test:

``` ruby sorm_spec.rb
require './sorm'

describe SORM do

  class Article < SORM
  end

  describe '.find_by_*' do
    it 'returns an array' do
      article = Article.find_by_whatever('foobar')
      expect(article.class).to eq Array
    end
  end
end
```

Alors c'est un test un peu *foireux*, ok. J'avoue que je n'ai pas réfléchi
une seconde au design de SORM. Je me dis qu'on s'adaptera au fur et à mesure.
Ici je teste qu'une méthode `.find_by_whatever` renvoie un tableau, c'est
tout. C'est histoire de se mettre en marche. Lancement du test:

    $ rspec sorm_spec.rb 
    sorm_spec.rb:3:in `<top (required)>': uninitialized constant SORM (NameError)

Et c'est partie pour l'écriture de notre classe `SORM`:

``` ruby sorm.rb
class SORM

end
```

Je relance le test:

    $ rspec sorm_spec.rb 
    F

    Failures:

      1) SORM.find_by_* returns an array
         Failure/Error: article = Article.find_by_whatever('foobar')
         NoMethodError:
           undefined method `find_by_whatever' for Article:Class
         # ./sorm_spec.rb:10:in `block (3 levels) in <top (required)>'

    Finished in 0.0009 seconds
    1 example, 1 failure

    Failed examples:

    rspec ./sorm_spec.rb:9 # SORM.find_by_* returns an array

La méthode `find_by_whatever` est bien sûr inconnue. Comme je veux gérer
les méthodes `find_by_*` avec `method_missing` j'écris:

``` ruby sorm.rb
class SORM

  def self.method_missing(method, *args)
    []
  end

end
```

Et maintenant on est sur la voie:

    $ rspec sorm_spec.rb 
    .

    Finished in 0.01664 seconds
    1 example, 0 failures

On a pas avancé beaucoup, mais on a quand même mis en place le TDD et notre
classe `SORM`.

*To be continued*

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

