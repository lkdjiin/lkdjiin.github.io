---
layout: post
title: "Ruby 2.1: la méthode Array#to_h"
date: 2013-12-29 11:31
comments: true
categories: [ruby, array, débutant, ruby 2.1]
---

{% level 1 %}

La version 2.1 de Ruby est sortie comme promis à Noël. La classe Array y gagne
une nouvelle méthode: `to_h`.

<!-- more -->

Pour transformer ce tableau:

``` ruby
[[:key1, "one"], [:key2, "two"], [:key3, "three"]]
```

en un Hash:

``` ruby
{:key1=>"one", :key2=>"two", :key3=>"three"}
```

La méthode était jusqu'ici la suivante:

``` irb
>> my_array = [[:key1, "one"], [:key2, "two"], [:key3, "three"]]
>> Hash[*my_array.flatten]
=> {:key1=>"one", :key2=>"two", :key3=>"three"}
```

Ruby 2.1 rend ceci plus simple, plus lisse, en ajoutant une méthode
de transformation à la classe Array, `to_h`:

``` irb
>> my_array.to_h
=> {:key1=>"one", :key2=>"two", :key3=>"three"}
```

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

