---
layout: post
title: "Ruby: Les méthodes du module Kernel 3"
date: 2013-09-29 12:51
legacy: true
tags: [ruby]
---



Aujourd'hui c'est dimanche, l'article sera court, on voit deux méthodes
utiles pour le débugage ou pour les fichiers
de log: `__method__` et `__dir__`.

<!-- more -->

`__method__`
------------

`__method__` renvoit le nom de la méthode courante comme un type Symbol:

{% highlight irb %}
>> def foo
>> __method__
>> end
nil
>> foo
:foo
{% endhighlight %}

Et si vous avez besoin de récupérer une chaîne de caractère:

{% highlight irb %}
>> def bar
>> __method__.to_s
>> end
nil
>> bar
"bar"
{% endhighlight %}

`__dir__`
---------

Comme son nom l'indique presque, cette méthode renvoit le nom (complet)
du répértoire du fichier dans lequel la méthode est appelée:

{% highlight ruby %}
def this_dir
  __dir__
end

puts this_dir
{% endhighlight %}

    [~/test]⇒ rvm use 2.0.0
    Using /home/xavier/.rvm/gems/ruby-2.0.0-p247
    [~/test]⇒ ruby dir.rb 
    /home/xavier/test





À demain.



