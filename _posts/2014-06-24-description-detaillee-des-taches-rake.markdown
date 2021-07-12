---
layout: post
title: "Description détaillée des tâches rake"
date: 2014-06-24 21:15
legacy: true
tags: [débutant, ruby, rake, astuce]
---



Vous savez certainement comment obtenir la liste des tâches `rake` disponibles
dans votre projet Rails ou dans votre gem Ruby. Il faut utiliser le switch
`-T`. Par exemple, à partir d'un projet Rails bidon:

    $ rake -T
    rake about                              # List versions of all Rails framew...
    rake assets:clean[keep]                 # Remove old compiled assets
    rake assets:clobber                     # Remove compiled assets
    rake assets:environment                 # Load asset compile environment
    rake assets:precompile                  # Compile all the assets named in c...
    rake cache_digests:dependencies         # Lookup first-level dependencies f...
    rake cache_digests:nested_dependencies  # Lookup nested dependencies for TE...
    rake db:create                          # Creates the database from DATABAS...
    rake db:drop                            # Drops the database from DATABASE_...

<!-- more -->

Et il y en a quelques dizaines d'autres. Vous remarquez que certaines descriptions sont
tronquées, comme `# Compile all the assets named in c...`. Lorsqu'il s'agit d'une
tâche qu'on ne connait pas très bien, on aimerait pouvoir lire la description
complête. Pour cela, il faut utiliser le switch `-D`:

    $ rake -D
    rake about
        List versions of all Rails frameworks and the environment

    rake assets:clean[keep]
        Remove old compiled assets

    rake assets:clobber
        Remove compiled assets

    rake assets:environment
        Load asset compile environment

    rake assets:precompile
        Compile all the assets named in config.assets.precompile

    rake cache_digests:dependencies
        Lookup first-level dependencies for TEMPLATE (like messages/show or comments/_comment.html)

Pour en savoir plus sur les switchs de rake, tapez `rake --help`.



À demain.


