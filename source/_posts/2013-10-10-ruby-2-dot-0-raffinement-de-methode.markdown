---
layout: post
title: "Ruby 2.0: Raffinement de méthode"
date: 2013-10-10 18:18
comments: true
categories: [ruby, débutant, ruby 2.0]
---

{% level 1 %}

Ruby possède un truc cool : les classes ouvertes. Lorsque j'écris :

``` ruby
class String
  def foo
    "foo"
  end
end
```

Je ne suis pas en train de *définir* une nouvelle classe `String`, je suis
simplement en train *d'ouvrir* la classe `String` existante pour lui ajouter
une nouvelle méthode.

<!-- more -->

C'est très utile et très cohérent avec l'esprit orienté objet de Ruby.
Mettons que j'ai besoin de cacher les voyelles d'une phrase pour un
hypothétique jeu de lettre, je peux écrire un module avec une collection
de méthodes utilitaires, par exemple:

``` ruby
module Util
  def self.hide_vowels(string)
    string.tr('aeiouy', '*')
  end
end

puts Util.hide_vowels("bonjour xavier")
```

Ce qui donne:

    b*nj**r x*v**r

Mais on peut aussi tirer parti des classes ouvertes de cette manière:

``` ruby
class String
  def hide_vowels
    tr('aeiouy', '*')
  end
end

puts "bonjour xavier".hide_vowels
```

C'est plus élégant, à la fois dans la définition et dans l'utilisation.
Seulement ce genre de code peut poser problème quand il est utilisé dans
des bibliothèques, puisque une fois chargée, la nouvelle méthode est visible
dans tout le code client. Parfois c'est ce qu'on veut, parfois ce ne devrait
être qu'une méthode utilitaire du code tiers.

Ruby 2.0 propose le raffinement de méthode (*method refinement*) pour
pallier à ce problème. L'idée est de limiter la portée des méthodes ajoutées
ou modifiées avec le mécanisme des classes ouvertes. Voici un petit exemple:

```
module CoolString
  refine String do
    def hide_vowels
      tr('aeiouy', '*')
    end
  end
end

# puts "abc".hide_vowels

using CoolString
puts "abc".hide_vowels
```

La ligne en commentaire provoquerait une erreur (NoMethodError). Pour pouvoir
utiliser la méthode `hide_vowels` il faut explicitement écrire
`using CoolString`. La portée de `hide_vowels` s'étend du moment où on utilise
la méthode `using` jusqu'à la fin du fichier.

Le raffinement de méthode est expérimental dans Ruby 2.0 et devrait être
définitivement adopté dans Ruby 2.1. Pour aller plus loin, on peut se
reporter à la [documentation](http://www.ruby-doc.org/core-2.0.0/doc/syntax/refinements_rdoc.html).



<script id='fb33k8u'>(function(i){var f,s=document.getElementById(i);f=document.createElement('iframe');f.src='//api.flattr.com/button/view/?uid=lkdjiin&url='+encodeURIComponent(document.URL);f.title='Flattr';f.height=62;f.width=55;f.style.borderWidth=0;s.parentNode.insertBefore(f,s);})('fb33k8u');</script>

À demain.

{% connexe %}

