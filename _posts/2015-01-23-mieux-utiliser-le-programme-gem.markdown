---
layout: post
title: "Mieux utiliser le programme gem"
date: 2015-01-23 11:49
legacy: true
tags: [ruby, débutant, gem]
---



Le programme `gem` est bien connu des rubyistes, et ce pour une bonne raison:
il est au coeur de l'utilisation de Ruby. Si je veux par exemple profiter
de [awesome_print](https://github.com/michaeldv/awesome_print)
dans ma console irb, je vais l'installer grâce à `gem`:

    $ gem install awesome_print

De même, avez-vous déjà vu une appli Rails se passer d'un Gemfile ?

{% highlight ruby %}
source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '4.0.0'
gem 'pg'
...
{% endhighlight %}

En fait, si vous avez fait seulement 3 jours de Ruby dans votre vie, vous savez
utiliser `gem`. Mais l'utilisez-vous à fond ? Moi, non. Enfin pas encore.

{% img center /images/diamond-1_512.png %}

<!-- more -->

Depuis 5 ou 6 ans que j'utilise quotidiennement Ruby, je n'avais jamais
écrit `gem --help`. Jamais. Pas une seule fois.

    $ gem --help
    RubyGems is a sophisticated package manager for Ruby.  This is a
    ...
      Further help:
        gem help commands            list all 'gem' commands
        gem help examples            show some examples of usage
        gem help gem_dependencies    gem dependencies file guide
        gem help platforms           gem platforms guide
        gem help <COMMAND>           show help on COMMAND
        gem server                   present a web page at
    ...

J'ai l'impression qu'il y a de quoi lire et de quoi faire. Voici donc un rapide
tour d'horizon des possibilités offertes par `gem`.

## gem help commands

Commençons par regarder les différentes commandes:

    $ gem help commands
    GEM commands are:

        build                  Build a gem from a gemspec
        cert                   Manage RubyGems certificates and signing settings
    ...
        wrappers               Re run generation of environment wrappers for gems.
        yank                   Remove a pushed gem from the index
    ...
    Commands may be abbreviated, so long as they are unambiguous.

J'ai abrégé la sortie ci-dessus car il y a **33 commandes**, je n'avais vraiment
pas la moindre idée d'un nombre si important de commande. En voici la liste:

- build
- cert
- check
- cleanup
- contents
- dependency
- environment
- fetch
- generate_index
- help
- install
- list
- lock
- mirror
- open
- outdated
- owner
- pristine
- push
- query
- rdoc
- regenerate_binstubs
- search
- server
- sources
- specification
- stale
- uninstall
- unpack
- update
- which
- wrappers
- yank

Personnellement j'ai déjà utilisé `build`, `cleanup`, `install`, `list`,
`push`, `uninstall`, `update` et c'est tout. 7 commandes sur 33, je suis loin du compte.

En regardant d'un peu plus près la sortie de `gem help commands`,
je m'aperçois qu'on peut abréger chaque commande:

    $ gem install my_gem

seras donc identique à:

    $ gem i my_gem

J'aime beaucoup cette idée.

## gem help a_command

On peut obtenir de l'aide sur une commande spécifique.
Par exemple, avec `gem help install`, j'apprend que les options permettant de
ne pas générer la documentation:

    --no-rdoc
    --no-ri

sont des options dépréciées. On peut maintenant utiliser:

    -N, --no-document

## gem help examples

Évidemment cette commande affiche plusieurs exemples ;) Comme la manière
d'installer une version spécifique d'une gem:

    $ gem install rake --version 0.3.1

Je ne sais pas pourquoi je ne me souviens jamais de cette manière de faire,
pourtant évidente. Maintenant je n'aurais plus besoin de poser la question à
un moteur de recherche, je me contenterais de `gem help examples`.

## gem server

Une petite curiosité : `gem server` fournit une page html, à consulter à
l'adresse `localhost:8808` avec la liste des gems installées. Ça semble un peu
gadget, d'autant plus qu'on peut avoir ces informations rapidement dans la
console avec la commande `list`:

    $ gem list

    *** LOCAL GEMS ***

    awesome_print (1.6.1)
    bigdecimal (1.2.6)
    bundler (1.7.9)
    ...

Et puis avec `gem help list`, j'ai trouvé comment obtenir des détails sur les
gems:

    $ gem list -d

    *** LOCAL GEMS ***

    awesome_print (1.6.1)
        Author: Michael Dvorkin
        Homepage: http://github.com/michaeldv/awesome_print
        License: MIT
        Installed at: /home/xavier/.rvm/gems/ruby-2.2.0

        Pretty print Ruby objects with proper indentation and colors

    bigdecimal (1.2.6)
        Authors: Kenta Murata, Zachary Scott, Shigeo Kobayashi
        Homepage: http://www.ruby-lang.org
        Installed at (default): /home/xavier/.rvm/rubies/ruby-2.2.0/lib/ruby/gems/2.2.0

    Arbitrary-precision decimal floating-point number library.

    ...

## Encore du boulot…

Je n'ai pas fini de la lire, cette documentation. Elle semble prometteuse, et
je sens que je vais apprendre encore pas mal de choses.

J'espère vous avoir donné envie de regarder certaines commandes plus en détails.
Dans un monde idéal, il faudrait que je regarde les 33…

À bientôt.


