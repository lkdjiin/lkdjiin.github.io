---
layout: post
title: "Ruby 2.1: la méthode Array#to_h"
date: 2013-12-29 11:31
legacy: true
tags: [ruby, array, débutant, ruby 2.1]
---



La version 2.1 de Ruby est sortie comme promis à Noël. La classe Array y gagne
une nouvelle méthode: `to_h`.

<!-- more -->

Pour transformer ce tableau:

{% highlight ruby %}
[[:key1, "one"], [:key2, "two"], [:key3, "three"]]
{% endhighlight %}

en un Hash:

{% highlight ruby %}
{:key1=>"one", :key2=>"two", :key3=>"three"}
{% endhighlight %}

La méthode était jusqu'ici la suivante:

{% highlight irb %}
>> my_array = [[:key1, "one"], [:key2, "two"], [:key3, "three"]]
>> Hash[*my_array.flatten]
=> {:key1=>"one", :key2=>"two", :key3=>"three"}
{% endhighlight %}

Ruby 2.1 rend ceci plus simple, plus lisse, en ajoutant une méthode
de transformation à la classe Array, `to_h`:

{% highlight irb %}
>> my_array.to_h
=> {:key1=>"one", :key2=>"two", :key3=>"three"}
{% endhighlight %}



À demain.



