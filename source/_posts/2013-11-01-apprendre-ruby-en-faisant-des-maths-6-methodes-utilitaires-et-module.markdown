---
layout: post
title: "Apprendre Ruby en faisant des maths 6: méthodes utilitaires et module"
date: 2013-11-01 21:54
comments: true
categories: [ruby, débutant, tutoriel, module]
---

{% level 1 %}

Dans les articles précédents, nous avons définis trois méthodes:
`divisors`, `proper_divisors` et `sum_of_proper_divisors`.
Ces trois méthodes commencent à former ce qu'on appelle une
collection, ou un ensemble, de méthodes utilitaires. Nous allons
aujourd'hui les regrouper dans un module.

<!-- more -->

Pour l'instant nous n'avons que trois méthodes, et elles portent toutes
sur les nombres. Mais nous allons bientôt en ajouter d'autres, peut-être
beaucoup d'autres. Certaines porteront peut-être sur la géométrie ou les
probabilités ? Il est plus propre de regrouper entre elles les méthodes
qui traitent du même sujet, alors pourquoi attendre ?

Voici comment on peut regrouper nos méthodes au sein du module `Number`:

``` ruby number.rb
module Number
  def self.divisors(n)
    (1..n).select {|i| n % i == 0 }
  end

  def self.proper_divisors(n)
    divisors(n)[0..-2]
  end

  def self.sum_of_proper_divisors(n)
    proper_divisors(n).reduce(:+)
  end
end
```

Vous voyez que les méthodes sont insérées à l'intérieur de:

``` ruby
module Number
end
```

Vous voyez aussi qu'on a ajouté `self.` devant le nom de chaque méthode.
Cela indique à Ruby qu'on veut utiliser ces méthodes sans pour autant
avoir à créer un objet (*si vous ne savez pas encore ce qu'est un objet,
ne vous inquiétez pas, nous n'en avons pas besoin pour l'instant*).

Voici une seconde manière de regrouper nos méthodes au sein du module `Number`:

``` ruby number.rb
module Number
  class << self
    def divisors(n)
      (1..n).select {|i| n % i == 0 }
    end

    def proper_divisors(n)
      divisors(n)[0..-2]
    end

    def sum_of_proper_divisors(n)
      proper_divisors(n).reduce(:+)
    end
  end
end
```

Cette deuxième syntaxe, qui peut sembler un peu bizarre si vous la
rencontrez pour la première fois, fait exactement la même chose que
la première syntaxe. Avec Ruby, il y a souvent plusieurs façons de dire
une même chose.
Je ne vais pas expliquer cette syntaxe aujourd'hui, mais sachez qu'elle
est très prisée dans la communauté Ruby et que vous la rencontrerez
souvent. Vous pouvez choisir celle que vous voulez.

Notez que, **par convention**, le module Number doit être enregistré
dans le fichier `number.rb`. Il n'y a pas d'obligation, mais avouez
que ça facilite grandement les choses.

Comment utiliser un module ?
-----------------------------

**Première solution**, vous pouvez écrire votre code à la suite du module:

``` ruby number.rb
module Number
  class << self
    def divisors(n)
      (1..n).select {|i| n % i == 0 }
    end

    def proper_divisors(n)
      divisors(n)[0..-2]
    end

    def sum_of_proper_divisors(n)
      proper_divisors(n).reduce(:+)
    end
  end
end

puts Number.sum_of_proper_divisors 8
```

Puis vous lancez le programme:

    [~/]⇒ ruby number.rb 
    7

**Deuxième solution**, vous lancez irb, *dans le même dossier* que le fichier
`number.rb` et vous chargez le module:

    [~/]⇒ irb
    >> require "./number"
    true
    >> Number.sum_of_proper_divisors 8
    7

**Troisième solution**, vous écrivez un programme dans un fichier séparé, par
exemple `test.rb`, *dans le même dossier* que le fichier
`number.rb`:

``` ruby test.rb
require "./number"

puts Number.sum_of_proper_divisors 8
```

Puis vous le lancez:

    [~/]⇒ ruby test.rb
    7



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

