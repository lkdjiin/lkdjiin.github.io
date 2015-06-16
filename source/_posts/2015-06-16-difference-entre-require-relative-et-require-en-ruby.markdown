---
layout: post
title: "Différence entre require_relative et require en Ruby"
date: 2015-06-16 16:59
comments: true
categories: [ruby, débutant]
---

{% level 1 %}

Quelle est la différence entre `require` et `require_relative`, les deux
méthodes pour charger du code en Ruby ?

L'une, `require`, agit par rapport au répertoire de travail (dossier courant),
tandis que
l'autre, `require_relative`, agit par rapport au fichier qui l'utilise.

{% img center /images/we-want-you-with-us.jpeg %}

<!-- more -->

## require

Nous avons la structure suivante :

    $ tree
    .
    ├── foo.rb
    └── lib
        ├── bar.rb
        └── baz.rb

Le fichier `foo.rb`, dans le répertoire racine, qui *require* le fichier `bar.rb`, qui se trouve dans le répertoire `lib`:

``` ruby foo.rb
require 'lib/bar'
puts bar
```

Le fichier `bar.rb` *require* le fichier `baz.rb` qui se trouve dans le même
répertoire que lui:

``` ruby lib/bar.rb
require 'lib/baz.rb'

def bar
  baz
end
```

Et le fichier `baz.rb` ne fait rien d'extraordinaire:

``` ruby lib/baz.rb
def baz
  'Hello, world!'
end
```

Toute cette chaîne fonctionne correctement, si on prend garde à ajouter le
répertoire courant au chemin des bibliothèques (aussi connu comme le LOAD PATH):

``` bash
$ ruby -I. foo.rb 
Hello, world!
```

## require_relative

La structure reste exactement la même:

    $ tree
    .
    ├── foo.rb
    └── lib
        ├── bar.rb
        └── baz.rb

Bien entendu le code change légèrement dans `foo.rb`, et surtout dans `bar.rb`:

``` ruby foo.rb
require_relative 'lib/bar'
puts bar
```

``` ruby lib/bar.rb
require_relative 'baz.rb'

def bar
  baz
end
```

``` ruby lib/baz.rb
def baz
  'Hello, world!'
end
```

Cette fois il n'y a pas besoin du switch `-I` puisque les fichiers sont requis
*relativement à eux-mêmes*:

``` bash
$ ruby foo.rb 
Hello, world!
```

## Pourquoi utiliser l'un plutôt que l'autre ?

Avant, à l'époque de Ruby 1.8.x, il n'existait que `require` et le dossier
courant était automatiquement ajouté au LOAD PATH (*du moins si ma mémoire est
bonne*). Avant donc, la question ne se posait pas.

Aujourd'hui par contre la question peut se poser, et je n'ai pas de réponse
définitive. Personnellement j'utilise `require_relative` régulièrement dans
deux cas: 1) dans un script qui a *grossi* et que je sépare en plusieurs
fichiers, et 2) dans les tests (RSpec ou autres) pour importer des données.

{% connexe %}
