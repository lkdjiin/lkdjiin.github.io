---
layout: post
title: "Racket pour les Rubyists 7: Module basique"
date: 2013-11-15 10:18
comments: true
categories: [racket, ruby, tutoriel, débutant, module]
---

{% level 1 %}

La dernière fois, on a écrit notre [première fonction en Racket](http://lkdjiin.github.io/blog/2013/11/11/racket-pour-les-rubyists-6-une-premiere-fonction/). Et avant
d'écrire des tests unitaires pour pouvoir la passer à la moulinette du
*refactoring*, il faut explorer un peu les modules Racket.

<!-- more -->

La notion de module en Racket
-----------------------------

Jusqu'ici on a utilisé le REPL, il est temps maintenant de mettre notre
code dans un fichier. Voyons le programme suivant, à mettre dans un
fichier `foo.rkt`:

``` racket foo.rkt
#lang racket

(define (times-2 n)
  (* 2 n))

(define (times-3 n)
  (* 3 n))

(provide times-2)
```

Vous reconnaissez la définition de deux fonctions: `times-2` et `times-3`
qui multiplient respectivements leur argument par 2 et par 3. En plus de ça,
il y a trois éléments nouveaux:

### Spécification d'un dialecte

La ligne `#lang racket` spécifie à Racket le dialecte utilisé. Il y en a
plein et je n'utiliserais que celui-ci. Il faudra penser à toujours placé
cette ligne au début de chaque fichier.

### Convention de nommage

Un petit exemple vaut mieux qu'un long discours:

    thisIsJavaConvention

    this_is_ruby_convention

    this-is-racket-convention

### La fonction provide

La fonction `provide`, qu'on peut placer n'importe où dans le fichier (donc
au début ou à la fin), permet *d'exporter* les fonctions données en
argument. Les autres fonctions (celle qui ne sont pas données à `provide`)
sont visible dans le fichier, mais pas à l'extérieur. Autrement dit,
`provide` permet de spécifier l'API, les fonctions publiques.


Utilisation d'un module
-----------------------

Dans le REPL, *démaré dans le même dossier que le fichier "foo.rkt"*,
on utilise la fonction `require`:

    -> (require "foo.rkt")

On peut maintenant utiliser la fonction *publique* `times-2`:

    -> (times-2 9)
    18

Et comme attendu, on ne peut pas utiliser `times-3`:

    -> (times-3 9)
    ; times-3: undefined;
    ;  cannot reference undefined identifier

Comparaison avec les modules Ruby
---------------------------------

Voici le pendant du fichier `foo.rkt` écrit en Ruby:

``` ruby foo.rb
module Foo
  class << self
    def times_2(n)
      2 * n
    end

    private

    def times_3(n)
      3 * n
    end
  end
end
```

Et voici comment on s'en sert dans une session irb:

``` irb
>> require "foo"
LoadError: cannot load such file -- foo
>> require "./foo"
true
>> Foo.times_2 9
18
>> Foo.times_3 9
NoMethodError: private method `times_3' called for Foo:Module
```

Le comportement est assez similaire. Petite différence, Ruby oblige à définir
le fichier requis par rapport au dossier courant alors que Racket le fait
automatiquement (ok, j'aurais pu utiliser `require_relative`…).

Mais la **grande différence** est qu'un module Ruby définit un espace
de nom, pas un module Racket. *À l'heure actuelle je ne sais pas si Racket
possède un mécanisme pour les espaces de nom, je n'en suis pas encore là,
mais j'espère que oui…*

La prochaine fois, on verra comment faire des tests unitaires simples en
Racket.

À demain.

{% connexe %}

