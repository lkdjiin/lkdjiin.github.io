---
layout: post
title: "Tester facilement vos dates avec Timecop"
date: 2014-04-01 21:06
comments: true
categories: [ruby, test, date, time, débutant]
---

{% level 1 %}

[Timecop](https://github.com/travisjeffery/timecop)
n'est pas une nouvelle gem. Mais je ne la découvre qu'aujourd'hui.
Ça fait pourtant 4 ans que je travaille quotidiennement avec Ruby
et/ou Rails… Et je ne me suis jamais sentis très à l'aise pour tester
les dates. Avec Timecop, ça devient un jeu d'enfant.

<!-- more -->

Pour voir un souci possible, prenons la classe suivante qui représente
un article:

``` ruby article.rb
class Article
  def initialize(name)
    @name = name
    @created_at = Time.now
  end

  attr_reader :name, :created_at
end
```

Dans le monde réel, ce serait surement un ActiveRecord, mais pour
l'exemple on se contentera bien de cette classe ;)

Maintenant testons la création d'un article:

``` ruby tc_article.rb
require_relative "article"
require "test/unit"

class TestArticle < Test::Unit::TestCase
  def test_creation
    article = Article.new('Foo')
    assert_equal 'Foo', article.name
    assert_equal Time.now, article.created_at
  end
end
```

Et voilà le souci, à quelques nano-secondes près ça pète:

``` bash
$ ruby tc_article.rb 
Run options: 

# Running tests:

[1/1] TestArticle#test_creation = 0.00 s
  1) Failure:
TestArticle#test_creation [tc_article.rb:8]:
<2014-04-01 21:05:10 +0200> (204201[ns]) expected but was
<2014-04-01 21:05:10 +0200> (176685[ns]).

Finished tests in 0.009979s, 100.2062 tests/s, 200.4125 assertions/s.
1 tests, 2 assertions, 1 failures, 0 errors, 0 skips
```

Timecop est la meilleure solution que j'ai vu jusqu'ici pour régler
ce type de problème. La gem propose tout simplement (entre autres)
*de geler le temps*:

``` ruby tc_article.rb
require_relative "article"
require "test/unit"
require "timecop"

class TestArticle < Test::Unit::TestCase
  def test_creation
    Timecop.freeze do
      article = Article.new('Foo')
      assert_equal 'Foo', article.name
      assert_equal Time.now, article.created_at
    end
  end
end
```

Et voilà le résultat:

``` bash
ruby tc_article.rb 
Run options: 

# Running tests:

Finished tests in 0.010756s, 92.9747 tests/s, 185.9494 assertions/s.
1 tests, 2 assertions, 0 failures, 0 errors, 0 skips
```

J'aimerais bien savoir quelles solutions vous avez adoptés pour
régler ce genre de soucis…

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
