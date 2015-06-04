---
layout: post
title: "Hacker la classe Fixnum"
date: 2015-05-23 08:48
comments: true
categories: [ruby, débutant]
---

{% level 1 %}

## Ou les classes ouvertes en Ruby

``` ruby
1.hour_in_minutes #=> 60

37.celsius_in_farenheit #=> 0

2.dozens #=> 24
```

C'est un aspect du langage que tous les rubyistes confirmés connaissent, mais
il est toujours utile d'en reparler pour les plus novices&nbsp;: En Ruby, même les
classes dites *système* peuvent être redéfinies, modifiées, augmentées, pliées
à vos besoins.

En un mot, on dit que les classes restent **ouvertes**.

{% img center /images/open-640.jpg %}

<!-- more -->

Si je veux par exemple pouvoir transformer les nombres entiers en *bytes* et en
*words*, je peux écrire les méthodes `to_bytes` et `to_words`.

> Un byte = un octet    
> Un word = deux octets

Voici ces méthodes simples, définies dans une session irb&nbsp;:

``` irb
>> def to_bytes(number)
>>   number
>> end

>> def to_words(number)
>>   number * 2
>> end

>> to_bytes(11)
11
>> to_words(11)
22
```

Ça fonctionne très bien mais 1) ça n'est pas très *orienté objet*, et 2) ça
n'est pas très *ruby*. Plutôt que `to_words(11)`, on écrirait plus volontiers
`11.words`, c'est quand même plus classe (oh le jeu de mot à deux balles).

En parlant de classe justement, voyons quelle est la classe d'un nombre entier&nbsp;:

``` irb
>> 123.class
Fixnum < Integer
```

C'est tout ce qu'il nous faut savoir pour *augmenter* les nombres entiers avec
nos propres méthodes `byte`, `bytes`, `word` et `words`&nbsp;:

``` ruby
class Fixnum
  def byte
    self
  end
  alias_method :bytes, :byte

  def word
    2 * self
  end
  alias_method :words, :word
end
```

Comme vous pouvez le constater, j'ai *ouvert* la classe Fixnum pour y ajouter
mes méthodes. Je rappelle que `self` est l'objet courant.

Si vous ne savez pas ce qu'est ce `alias_method`, dites vous que ceci&nbsp;:

``` ruby
  def word
    2 * self
  end
  alias_method :words, :word
```

est équivalent à cela&nbsp;:

``` ruby
  def word
    2 * self
  end

  def words
    word
  end
```

Et voilà&nbsp;:

``` ruby
1.byte  #=> 1
2.bytes #=> 2
1.word  #=> 2
3.words #=> 6
```

{% connexe %}
