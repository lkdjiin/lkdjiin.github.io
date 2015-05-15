---
layout: post
title: "Créer plusieurs fichiers en Bash"
date: 2015-05-15 13:46
comments: true
categories: [bash, débutant, automatisation]
---

{% level 1 %}

*Faire deux fois la même chose, c'est une coincidence ; faire
trois fois la même chose, c'est déjà deux de trop.*

Mettons que j'ai besoin de créer 20 fichiers quelconques (ici en Ruby) nommés ainsi :

- `asm01.rb`
- `asm02.rb`
- `asm03.rb`
- etcétéra jusqu'à `asm20.rb`

<!-- more -->

Je peux les créer les uns après les autres de cette manière :

``` bash
$ touch lib/c8dasm/assemblies/asm01.rb
$ touch lib/c8dasm/assemblies/asm02.rb
$ touch lib/c8dasm/assemblies/asm03.rb
$ # même chose jusqu'à :
$ touch lib/c8dasm/assemblies/asm20.rb
```

Imaginez si vous deviez en faire 200 comme cela ! Et même s'il n'y en avait que
10, c'est juste ennuyeux au possible. En tant que développeurs, **nous devrions
apprendre à automatiser ces tâches pour notre confort**.

On peut utiliser une boucle pour résoudre ce problème :

``` bash
$ for i in {01..20}; do
… > touch lib/c8dasm/assemblies/asm$i.rb
… > done
```

Ou bien la version sur une seule ligne :

``` bash
$ for i in {01..20}; do touch lib/c8dasm/assemblies/asm$i.rb; done
```

À bientôt.

{% connexe %}

