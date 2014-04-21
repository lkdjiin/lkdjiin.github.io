---
layout: post
title: "Rails 4.1 avec Spring, Rspec ou Minitest et Coco"
date: 2014-04-21 21:15
comments: true
categories: [rails, rspec, minitest, coco, débutant]
---

{% level 1 %}

Rails 4.1 est sorti récemment. Une des nouveautés est qu'il est livré avec
[Spring](https://github.com/rails/spring), qui permet d'accélerer le
développement en gardant, en quelque sorte, l'application rails en mémoire.
Voici, très rapidement, comment configurer Rails 4.1 avec soit Rspec, soit
Minitest comme framework de test, et [Coco](https://github.com/lkdjiin/coco) comme outil de *code coverage*.

<!-- more -->

Tout d'abord, l'installation de la dernière version de rails:

    gem install rails

Puis la création d'une application de test:

    rails new testappli -T

Ensuite, si vous utiliser **Rspec**, le Gemfile:

``` ruby Gemfile
group :development, :test do
  gem 'spring-commands-rspec'
  gem 'rspec-rails'
end

group :test do
  gem 'coco'
end
```

L'installation des gems:

    bundle install

L'installation de rspec:

    rails g rspec:install

La création de `bin/rspec`:

    spring binstub --all

La mise en place de Coco dans le fichier `spec/spec_helper.rb`:

``` ruby spec/spec_helper.rb
# Toute dernière ligne (ou bien toute première, au choix)
require 'coco'
```

Finalement vous pouvez lancer les tests ainsi:

    bin/rspec


Si, au contraire, vous avez choisi **Minitest**, vous ajouterez ceci dans votre Gemfile:

``` ruby Gemfile
group :development, :test do
  gem 'minitest-rails', '2.0.0.beta1'
end

group :test do
  gem 'coco'
end
```

Ensuite, l'installation:

    bundle install
    rails g minitest:install 


La mise en place de Coco dans le fichier `test/test_helper.rb`:

``` ruby spec/spec_helper.rb
# Toute dernière ligne (ou bien toute première, au choix)
require 'coco'
```

Finalement vous pouvez lancer les tests ainsi:

    bin/rake

Ou bien:

    bin/rake test

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

