---
layout: post
title: "Ruby: Les méthodes du module Kernel 3"
date: 2013-09-29 12:51
comments: true
categories: [ruby, débutant, kernel]
---

{% level 1 %}

Aujourd'hui c'est dimanche, l'article sera court, on voit deux méthodes
utiles pour le débugage ou pour les fichiers
de log: `__method__` et `__dir__`.

<!-- more -->

`__method__`
------------

`__method__` renvoit le nom de la méthode courante comme un type Symbol:

``` irb
>> def foo
>> __method__
>> end
nil
>> foo
:foo
```

Et si vous avez besoin de récupérer une chaîne de caractère:

``` irb
>> def bar
>> __method__.to_s
>> end
nil
>> bar
"bar"
```

`__dir__`
---------

Comme son nom l'indique presque, cette méthode renvoit le nom (complet)
du répértoire du fichier dans lequel la méthode est appelée:

``` ruby ~/test/dir.rb
def this_dir
  __dir__
end

puts this_dir
```

    [~/test]⇒ rvm use 2.0.0
    Using /home/xavier/.rvm/gems/ruby-2.0.0-p247
    [~/test]⇒ ruby dir.rb 
    /home/xavier/test

À demain.

{% connexe %}

