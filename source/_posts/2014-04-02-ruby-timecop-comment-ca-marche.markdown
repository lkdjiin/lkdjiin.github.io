---
layout: post
title: "Ruby Timecop - Comment ça marche ?"
date: 2014-04-02 21:07
comments: true
categories: [ruby, test, date, time, meta, intermédiaire]
---

{% level 2 %}

Hier je vous parlais de Timecop, une gem Ruby qui *arrête le
temps*, très utile pour tester les dates. J'y ai repensé un
peu aujourd'hui sur le mode : «j'aurais pu y penser avant !».

Alors justement, si j'avais eu cette idée, comment j'aurais
fait ? C'est l'occasion de parler de méta-programmation.
Allez j'essaye d'écrire ma propre méthode
`Time.freeze`, on verra bien…

<!-- more -->

Voilà les étapes qui me semble nécessaires:

1. Geler le temps et le retenir.
2. Faire un backup de Time.now.
3. Définir une nouvelle méthode Time.now qui renvoie toujours
   le même temps.
4. Appeler le block passé à la méthode.
5. Restaurer la méthode Time.now originale.

Avant de coder, j'écris un test:

``` ruby
puts "Time before #{Time.now}"
sleep 3

Time.freeze do
  puts Time.now.to_s
  sleep 3
  puts Time.now.to_s
end

sleep 3
puts "Time after #{Time.now}"
```

Je veux donc obtenir un affichage du genre:

    Time before hh:mm:00
    hh:mm:03
    hh:mm:03
    Time after hh:mm:09

Ok ? C'est parti.

Ouvrir la classe Time
---------------------

``` ruby
class Time
  def self.freeze
  end
end
```

Premier truc à savoir, une classe Ruby est toujours ouverte
à la modification. Même si il s'agit d'une classe du coeur
du langage, comme Object ou Kernel. *Si vous êtes perdus,
faites une recherche sur «ruby open class».*

Arrêter le temps
----------------

``` ruby
class Time
  def self.freeze
    freezed = Time.now
  end
end
```

Pas grand chose à dire. On pourra renvoyer l'objet `freezed`
chaque fois qu'on nous demandera `Time.now`.

Sauvegarder Time.now original
-----------------------------

``` ruby
class Time
  def self.freeze
    freezed = Time.now
    singleton_class.send(:alias_method, :old_now, :now)
  end
end
```

Là il y a beaucoup à dire. On rentre dans la
méta-programmation et je n'ai pas la place (ni le temps) dans
cet article pour parler du modêle objet de Ruby.
N'hésitez pas à faire une recherche sur «ruby object model» ou
«ruby eigenclass».

On dit à la classe `Time` de créer un alias de la méthode de
classe `now` avec le nom `old_now`.

Un nouveau Time.now
-------------------

``` ruby
class Time
  def self.freeze
    freezed = Time.now
    singleton_class.send(:alias_method, :old_now, :now)
    define_singleton_method('now') { freezed }
  end
end
```

Cette fois, je dis à la classe `Time` de créer une méthode de
classe qui s'appelle `now` et qui renvoie notre objet
`freezed`.

Appeler le block
----------------

``` ruby
class Time
  def self.freeze
    freezed = Time.now
    singleton_class.send(:alias_method, :old_now, :now)
    define_singleton_method('now') { freezed }
    yield
  end
end
```

Bon, ça c'était facile ;)

Restaurer Time.now
------------------

``` ruby
class Time
  def self.freeze
    freezed = Time.now
    singleton_class.send(:alias_method, :old_now, :now)
    define_singleton_method('now') { freezed }
    yield
    singleton_class.send(:alias_method, :now, :old_now)
  end
end
```

Ça me semble tout bon. On teste ?

Le test
-------

``` ruby freeze.rb
class Time
  def self.freeze
    freezed = Time.now
    singleton_class.send(:alias_method, :old_now, :now)
    define_singleton_method('now') { freezed }
    yield
    singleton_class.send(:alias_method, :now, :old_now)
    # singleton_class.send(:remove_method, :old_now)
  end
end

puts "Time before #{Time.now}"
sleep 3

Time.freeze do
  puts Time.now.to_s
  sleep 3
  puts Time.now.to_s
end

sleep 3
puts "Time after #{Time.now}"
```

``` bash
$ ruby freeze.rb 
Time before 2014-04-02 21:40:57 +0200
2014-04-02 21:41:00 +0200
2014-04-02 21:41:00 +0200
Time after 2014-04-02 21:41:06 +0200
```

Excellent !

Il reste un léger problème : la méthode `Time.old_now`
existe toujours, ce qui n'est pas très propre. On pourra
la supprimer ainsi:

    singleton_class.send(:remove_method, :old_now)

Voilà, j'aurais quand même pu y penser avant… J'espère
trouver du temps une prochaine fois pour jeter un coup
d'oeil au code de Timecop pour comparer avec le code
d'aujourd'hui.


<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}
