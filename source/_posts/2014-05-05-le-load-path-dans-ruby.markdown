---
layout: post
title: "Le LOAD_PATH dans Ruby"
date: 2014-05-05 21:02
comments: true
categories: [ruby, load_path, intermédiaire]
---

{% level 2 %}

En Ruby, la variable `$LOAD_PATH` contient tous les chemins vers les
bibliothèques chargées.

``` irb
>> $LOAD_PATH
[
    [0] "/home/xavier/.rvm/gems/ruby-2.1.0/gems/awesome_print-1.2.0/lib",
    [1] "/home/xavier/.rvm/rubies/ruby-2.1.0/lib/ruby/site_ruby/2.1.0",
    [2] "/home/xavier/.rvm/rubies/ruby-2.1.0/lib/ruby/site_ruby/2.1.0/i686-linux",
    [3] "/home/xavier/.rvm/rubies/ruby-2.1.0/lib/ruby/site_ruby",
    [4] "/home/xavier/.rvm/rubies/ruby-2.1.0/lib/ruby/vendor_ruby/2.1.0",
    [5] "/home/xavier/.rvm/rubies/ruby-2.1.0/lib/ruby/vendor_ruby/2.1.0/i686-linux",
    [6] "/home/xavier/.rvm/rubies/ruby-2.1.0/lib/ruby/vendor_ruby",
    [7] "/home/xavier/.rvm/rubies/ruby-2.1.0/lib/ruby/2.1.0",
    [8] "/home/xavier/.rvm/rubies/ruby-2.1.0/lib/ruby/2.1.0/i686-linux"
]
```

<!-- more -->

Si je charge Rspec, par exemple, son chemin va être ajouté dans la variable
`$LOAD_PATH`, ainsi que toutes les bibliothèques dont dépend Rspec:

``` irb
>> require 'rspec'
true
>> $LOAD_PATH
[
    [ 0] "/home/xavier/.rvm/gems/ruby-2.1.0/gems/awesome_print-1.2.0/lib",
    [ 1] "/home/xavier/.rvm/gems/ruby-2.1.0/gems/rspec-2.14.1/lib",
    [ 2] "/home/xavier/.rvm/gems/ruby-2.1.0/gems/rspec-core-2.14.8/lib",
    [ 3] "/home/xavier/.rvm/rubies/ruby-2.1.0/lib/ruby/site_ruby/2.1.0",
    [ 4] "/home/xavier/.rvm/rubies/ruby-2.1.0/lib/ruby/site_ruby/2.1.0/i686-linux",
    [ 5] "/home/xavier/.rvm/rubies/ruby-2.1.0/lib/ruby/site_ruby",
    [ 6] "/home/xavier/.rvm/rubies/ruby-2.1.0/lib/ruby/vendor_ruby/2.1.0",
    [ 7] "/home/xavier/.rvm/rubies/ruby-2.1.0/lib/ruby/vendor_ruby/2.1.0/i686-linux",
    [ 8] "/home/xavier/.rvm/rubies/ruby-2.1.0/lib/ruby/vendor_ruby",
    [ 9] "/home/xavier/.rvm/rubies/ruby-2.1.0/lib/ruby/2.1.0",
    [10] "/home/xavier/.rvm/rubies/ruby-2.1.0/lib/ruby/2.1.0/i686-linux"
]
```

Il y a encore quelques jours, je faisais systématiquement cela au début de
toutes mes gems:

``` ruby
$LOAD_PATH.unshift File.dirname(__FILE__)
```

Ceci pour que ma gem ajoute son propre chemin dans le `LOAD_PATH`.
Et bien je viens d'apprendre que non, c'est inutile ! L'utilitaire `gem`
fait très bien cela tout seul.

Aujourd'hui j'ai (encore) appris quelque chose ;)

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

