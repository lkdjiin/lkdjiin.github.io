---
layout: post
title: "Du nouveau dans Ruby 2.1: Le suffixe r"
date: 2013-11-25 23:56
comments: true
categories: [ruby, nombre rationnel, débutant, ruby 2.1]
---

{% level 1 %}

Aujourd'hui on voit une nouvelle façon d'écrire un nombre rationnel dans
Ruby 2.1.

<!-- more -->

Jusqu'ici pour écrire un nombre rationnel, on devait faire ceci:

``` ruby
Rational('1/3')
```

Ce qui est loin d'être concis:

    [~]⇒ rvm use 2.0.0
    [~]⇒ irb
    >> Rational('1/3') + Rational('1/9')
    4/9

Désormais, avec Ruby 2.1, on pourra se servir du suffixe `r`:

    [~]⇒ rvm use 2.1.0-preview1
    [~]⇒ irb
    >> 1/3r + 1/9r
    => (4/9)

Encore un peu plus de sucre dans notre langage ;)

**Source (pdf)** [toruby](http://www.atdot.net/~ko1/activities/toruby05-ko1.pdf)



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
