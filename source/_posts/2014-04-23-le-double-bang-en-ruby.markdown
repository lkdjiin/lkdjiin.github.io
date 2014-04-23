---
layout: post
title: "Le double bang en Ruby"
date: 2014-04-23 20:59
comments: true
categories: [ruby, débutant, bang]
---

{% level 1 %}

Ou encore !!, ou double point d'exclamation
-------------------------------------------

On peut voir ici ou là ce genre de code Ruby:

    !!expression

*-C'est un truc qui n'est d'ailleurs pas spécifique au langage Ruby-*
Pourquoi voudrait-on écrire ça ?

<!-- more -->

Le `!` (not) fait une négation booléenne. Donc si une expression est `true`,
cela va donner `false`, et inversement, si une expression est `false`, cela
va donner `true`. Exemple:

``` irb
$ irb
>> !true
=> false
>> !false
=> true
```

Donc le `!!` est la négation booléenne d'une négation booléenne! Hum, ça
a l'air un peu inutile, hein:

``` irb
>> !!true
=> true
>> !!false
=> false
```

Ce qu'il ne faut pas oublier, c'est qu'en Ruby, comme dans plein d'autres
langages, beaucoup de choses peuvent être **true** ou **false**.
La preuve pour `true`:

``` irb
>> puts 'ok' if 'kind of true value'
ok
puts 'ok' if [1, 2]
ok
>> puts 'ok' if []
ok
```

En fait, toute valeur autre que `false` ou `nil` est considérée comme `true`.
Et le corollaire: sont considérées comme `false` les valeurs `false` ou `nil`.

On peut maintenant voir l'intérêt du `!!`. Soit la classe suivante pour nous
servir d'exemple:

``` ruby
class Connection
  def initialize(connection = nil)
    @connection = connection
  end

  # Returns a boolean.
  def connected?
    !!@connection
  end
end
```

Bien que `@connection` soit `nil` ou un objet quelconque, je veux que
`connected?` renvoit `true` ou `false`. Pour ça je peux écrire:

    if @connection
      true
    else
      false
    end

ou bien encore:

    @connection ? true : false

Mais le `!!@connection` fonctionne tout aussi bien. Il est plus concis, et
surtout exprime bien le *cast* en booléen:

``` irb
>> c1 = Connection.new
=> #<Connection:0x9236910 @connection=nil>
>> c1.connected?
=> false
>> c2 = Connection.new(Object.new)
=> #<Connection:0x922deb4 @connection=#<Object:0x922dec8>>
>> c2.connected?
=> true
```

<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
