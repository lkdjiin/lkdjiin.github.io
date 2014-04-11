---
layout: post
title: "La méta programmation en Ruby - partie 2"
date: 2014-04-11 21:41
comments: true
categories: [ruby, intermédiaire, meta, programmation]
---

{% level 2 %}

Hier j'ai écris une [introduction à la méta programmation](http://lkdjiin.github.io/blog/2014/04/10/introduction-a-la-meta-programmation-en-ruby/).
Aujourd'hui j'approfondis un peu plus le sujet avec l'écriture d'un
*query builder* sommaire.

<!-- more -->

On va commencer avec une classe `Article`:

``` ruby
class Article
end
```

On peut pas faire plus simple ;) Cette classe ne sera pas très importante
pour la démonstration, c'est juste un support pour la pensée.
Ce que je veux, c'est écrire un *fabricant de requête SQL*. Je me limite
à un simple SELECT:

``` ruby
class QueryBuilder
  def self.find(table, column, value)
    "SELECT * from #{table} where #{column} = #{value};"
  end
end

puts QueryBuilder.find('article', 'name', 'Foo')
```

Résultat:

``` bash
$ ruby meta2.rb 
SELECT * from article where name = Foo;
```

Notre `QueryBuilder` fait son travail. Il peut servir quelle que soit la
table (et la colonne) recherchée. Mais j'aime pas :( Trop d'arguments et
la classe `Article` ne sert à rien…

On va donc réécrire le `QueryBuilder` pour qu'il trouve tout seul comme
un grand le nom de la table:

``` ruby
module QueryBuilder
  extend self
  def find(column, value)
    "SELECT * from #{self.to_s.downcase} where #{column} = #{value};"
  end
end

class Article
  extend QueryBuilder
end

puts Article.find('name', 'Foo')
```

C'est bien mieux ! Maintenant le nom de la table est déduit du nom de la
classe. Bien sûr ça nécessite de suivre une convention. Ici la convention
est «Un objet `Article` = une table `article`». Ça donne ceci:

``` bash
$ ruby meta2.rb 
SELECT * from article where name = Foo;
```

Ça marche bien et je pourrais vivre avec ça. Mais Ruby permet de faire
encore mieux, en tous cas il permet d'ajouter de la *magie* comme on
entend souvent. Voyons cela, on va à nouveau réécrire le `QueryBuilder`
pour n'avoir à passer qu'un seul argument:

``` ruby
module QueryBuilder
  extend self
  def method_missing(method, value)
    column = method.id2name.to_s.sub(/find_by_/, '')
    "SELECT * from #{self.to_s.downcase} where #{column} = #{value};"
  end
end

class Article
  extend QueryBuilder
end

p Article.find_by_id(123)
p Article.find_by_name('Foo')
p Article.find_by_price(12.34)
```

Et c'est magique, on a maintenant autant de méthode `find_by_*` que
l'on veut:

``` bash
$ ruby meta2.rb 
"SELECT * from article where id = 123;"
"SELECT * from article where name = Foo;"
"SELECT * from article where price = 12.34;"
```

Je vous laisse méditer là-dessus et j'expliquerais `method_missing`
dans le prochain article car il est déjà tard…

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

